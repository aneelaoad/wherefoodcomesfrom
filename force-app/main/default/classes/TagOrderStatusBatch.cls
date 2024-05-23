global class TagOrderStatusBatch implements Database.Batchable<sObject>, Database.AllowsCallouts{
    
    public string Query {get;set;}
    
    public TagOrderStatusBatch()
    {
        Query = 'Select Id, Name, AllFlexOrderID__c, AllFlexSyncStatus__c, Status__c, Opportunity__r.AccountId, ' +
                                         ' Opportunity__r.Account.Name, Opportunity__r.Account.BillingStreet, Opportunity__r.Account.BillingCity, ' +
                                         ' Opportunity__r.Account.BillingState, Opportunity__r.Account.BillingPostalCode, Purchase_Order__c, ' +
                                         ' Opportunity__r.Account.Phone, Opportunity__r.Account.BillingCountry, Shipping_Method_AF__c, ' +
                                         ' (Select Id, Quantity__c, Product__c, Product__r.ProductCode from Tag_Order_Line_Items__r), ' +
                                         ' ShippingCity__c, ShippingAddress__c, ShippingState__c, ShippingZip__c, Premise_ID__c, ' +
                                     ' Tracking__c, Tags_Allocated__c ' +
                                     ' FROM Tag_Order__c ' +
                                     ' WHERE Status__c != \'Manifest Created\'  AND AllFlexOrderId__c != null ';
		      
        //Query = 'SELECT Id, EID__c from TagOrderLineTag__c order by LastModifiedDate asc';
        
        if (test.isRunningTest() == true)
            Query += ' limit 10';
    }    
   
    
    global Database.QueryLocator start(Database.BatchableContext info){ 
        return Database.getQueryLocator(Query);
    }     
    
    private class ResponseDetail
    {
        public string Response{get;set;}
        public string UsedFor{get;set;}
        public Tag_Order__c Order{get;set;}
        public ContentVersion Content{get;set;}
    }
    
    global void execute(Database.BatchableContext info, List<sObject> scope){
        
        datetime starttime = datetime.now();
        datetime estimatedEndTime = starttime.addMinutes(1); //ideally, it should end within a minute 

        List<TagOrderLineItem__c> allTagLines = new List<TagOrderLineItem__c>();
        list<TagOrderLineTag__c> allTags = new list<TagOrderLineTag__c>();
        list<ResponseDetail> allResponses = new list<ResponseDetail>();
        list<Tag_Order__c> allOrders = new list<Tag_Order__c>();
        AllFlex_API__c apiDetail = [Select Name, BaseURL__c, API_Key__c FROM AllFlex_API__c WHERE Name = 'Default' limit 1]; 
        List<SV2_API__mdt> sendToSV2Api = [Select Send_to_SV2__c, UserName__c, Base_URL__c, Password__c FROM SV2_API__mdt WHERE Label = 'Default']; 
        Boolean sendToSV2 = false;
        if(sendToSV2Api.size() > 0){
            sendToSv2 = sendToSV2Api[0].Send_to_SV2__c;
        }
        
        //deleting duplicate records
        //AggregateResult<TagOrderLineTag__c> tags = [SELECT Id, EID__c from TagOrderLineTag__c, count(EID__c) group by Id, Eid__c Having count(Eid__c) > 1];  
        try {
            integer count = 0;
            for(sObject obj : scope){ 
                
                count++;
                
                if ((count >= 59 && estimatedEndTime < DateTime.now())
                     || Test.isRunningTest() == true ) //we reached the api call limit within 60 seeconds, we need to wait
                {
                    sleepUntil(estimatedEndTime);
                    
                    //now reset the start and endtime as the api limit must be reset on the YM server
                    starttime = DateTime.now();
                    estimatedEndTime = starttime.addMinutes(1);
                    count = 0;
                } 
                
                Tag_Order__c odr = (Tag_Order__c) obj;
                odr.AllFlexSyncStatus__c = '';
                List<TagOrderLineItem__c> tagLines = new List<TagOrderLineItem__c>();
                list<TagOrderLineTag__c> tags = new list<TagOrderLineTag__c>();
                Dom.Document response = TagOrderStatusHelper.getOrderStatus(odr, apiDetail); //callout
                if (response != null)
                {
                    string taskPerformed = '';
                	if (TagOrderStatusHelper.updateOrderTags(response, odr, tagLines, tags, taskPerformed, sendToSv2 ) == true)
                    {
                        ResponseDetail res = new ResponseDetail();
                        res.Response = response.toXmlString();
                        res.UsedFor = taskPerformed;
                        res.order= odr;
                        allResponses.add(res);
                        
                        if (sendToSv2 == true)
                        	TagOrderXMLToSV2.sendXMLToXV2(Blob.valueOf(response.toXMLString()), sendToSV2Api[0]); //calling future method
                    }
                    allOrders.add(odr);
                    alltagLines.addAll(tagLines);
                    alltags.addAll(tags);
                    
                    //TagOrderStatusHelper.updateOrderStatus(response, odr);                
                }
            }   
        } catch (exception e){
            system.debug('*** Tag Order Batch Process Exception: ' + e.getMessage() + ' Line: ' + e.getLineNumber());
            throw e;
        }
        
        //updating Orders, LineItems and upserting Tags
        update allOrders;
        update alltagLines;
        Schema.SObjectField f = TagOrderLineTag__c.Fields.EID__c;
        database.upsert(alltags, f, true); //to get the exception
        
        list<ContentVersion> allContents = new list<ContentVersion>();
        for(ResponseDetail rd: allResponses)
        {
            ContentVersion cont = new ContentVersion();
            cont.Title = 'Order Update: ' + rd.order.Name + ' - ' + rd.UsedFor;
            cont.PathOnClient = 'file_' + Datetime.now().getTime() + '.xml';
            cont.VersionData = Blob.valueOf(rd.Response);
            cont.Origin = 'H';
            allContents.add(cont);
            rd.Content = cont;
        }
        
        insert allContents;
        
        map<Id, ContentVersion> contentDetailById = new  map<Id, ContentVersion>([SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id IN: allContents]);
        
        list<ContentDocumentLink> allContentLinks = new list<ContentDocumentLink>();
        
        for(ResponseDetail rd: allResponses)
        {
            ContentVersion contentDetail = contentDetailById.get(rd.Content.Id);
            ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.ContentDocumentId = contentDetail.ContentDocumentId;
            cdl.LinkedEntityId = rd.Order.Id;
            cdl.ShareType = 'I';
            allContentLinks.add(cdl);
        }
        
        insert allContentLinks;
        
 
        
                
        // We now need to pause the integration - this is solely because of API limitations on the YM Side
        // We can only make 60 calls to the certification API per minute - we are going to make sure this integration took at least 10 seconds to run
        // For the record - this is a crummy way to do this and we may hit some other limitations - but Salesforce doesn't have another way to sleep a thread
        sleepUntil(estimatedEndTime);
    }
    
    private void sleepUntil(DateTime aEndtime)
    {           
        while(datetime.now() < aEndtime && test.isRunningTest() == false){
            //do nothing - just sit around
        }
    }
    
    global void finish(Database.BatchableContext info){  
    } 
    
}