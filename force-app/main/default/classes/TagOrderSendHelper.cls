public class TagOrderSendHelper {
    // private variables
    public Id TagOrderId {get;set;}
    private Tag_Order__c thisOrder {get;set;}
    public List<TagDetail> tags {get;set;}
    public List<TagOrderLineItem__c> lineItems {get;set;}
    public String pageMessage {get;set;}
    
    public TagOrderSendHelper(ApexPages.StandardController pController){ 
        TagOrderId = pController.getId();
        thisOrder = (Tag_Order__c)pController.getRecord();
        tags = new List<TagDetail>();
        lineItems = new List<TagOrderLineItem__c>();
        pageMessage = '';
    }
    
    public class TagDetail{
        public String Name{get;set;}             
        public String LineId{get;set;}
        public String LineQuantity{get;set;}
        public String LinePrice{get;set;} 
        public List<TagDetailChild> children{get;set;}
        
        public TagDetail(){
            children = new List<TagDetailChild>();
        }
    }
    
    public class TagDetailChild implements Comparable{ 
        public String EID{get;set;}        
        public String SerialNumber{get;set;}        
        public String Management{get;set;} 
        public ID parentId{get;set;}
        public String ContainerId{get;set;}
        public String InnerContainerId{get;set;}
        
        public TagDetailChild(){
            
        }
        
        public Integer compareTo(Object compareTo) 
        {
            TagDetailChild ch = (TagDetailChild) compareTo;
            
            try{
                Integer e = Integer.valueOf(EID);
                Integer c = Integer.valueOf(ch.EID);
                if (e == c) return 0;
                if (e > c) return 1;
                return -1; 
            } catch(Exception e){
                system.debug('There was an EID with a non integer value');
                return 0;
            }       
        }
    }
    
    public PageReference getManifest(){
        lineItems = [Select Id, Name, Quantity__c, Product__c, Product__r.ProductCode,
                     (Select Id, ContainerId__c, EID__c, InnerContainerId__c, Management__c, SerialNumber__c, TagOrderLineItem__r.TagOrder__r.Purchase_Order__c 
                      FROM Tag_Order_Line_Tags__r)
                     FROM TagOrderLineItem__c WHERE TagOrder__c = :TagOrderId];
        
        
        
        
        
        return null;
    }  
    
    public PageReference exportManifest(){
        lineItems = [Select Id, Name, Quantity__c, Product__c, Product__r.ProductCode, TagOrder__r.Name, 
                     (Select Id, ContainerId__c, EID__c, InnerContainerId__c, Management__c, SerialNumber__c, TagOrderLineItem__r.TagOrder__r.Purchase_Order__c
                      FROM Tag_Order_Line_Tags__r)
                     FROM TagOrderLineItem__c WHERE TagOrder__c = :TagOrderId];
        
        String attachment = 'Product,Quantity,EID,SerialNumber,Management,ContainerId,InnerContainerId\n'; 
        String tagName = TagOrderId  + ' CSV Export';
        
        if(lineItems.size()>0){
            tagname = lineItems[0].TagOrder__r.Name + ' CSV Export';
            for(TagOrderLineItem__c l : lineItems){
                attachment = attachment + l.Product__r.ProductCode + ',' + l.Quantity__c + '\n';
                for(TagOrderLineTag__c t : l.Tag_Order_Line_Tags__r){
                    attachment = attachment + ',,' + t.EID__c + ',' + t.SerialNumber__c + ',' + t.Management__c + ',' +  t.TagOrderLineItem__r.TagOrder__r.Purchase_Order__c + ',' + t.ContainerId__c  +'\n';
                }
            }
        }                           
        Blob attachmentBlob = Blob.valueOf(attachment);//EncodingUtil.base64Decode(EncodingUtil.urlDecode(attachment, 'UTF-8'));
        
        ContentVersion cont = new ContentVersion();
        cont.Title = tagName;
        cont.PathOnClient = 'file_' + Datetime.now().getTime() + '.csv';
        
        cont.VersionData = attachmentBlob;
        cont.Origin = 'H';
        
        insert cont;
        
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cont.Id].ContentDocumentId;
        cdl.LinkedEntityId = TagOrderId;
        cdl.ShareType = 'I';
        insert cdl;
        
        return new PageReference('/' + cont.Id);
    }  
    /*public pageReference getManifest(){
List<Tag_Order__c> orders = [Select Id, Name, AllFlexOrderID__c, AllFlexSyncStatus__c, Status__c, Opportunity__r.AccountId,
Opportunity__r.Account.Name, Opportunity__r.Account.BillingStreet, Opportunity__r.Account.BillingCity, 
Opportunity__r.Account.BillingState, Opportunity__r.Account.BillingPostalCode, Purchase_Order__c,
Opportunity__r.Account.Phone, Opportunity__r.Account.BillingCountry, Shipping_Method_AF__c, 
(Select Id, Quantity__c, Product__c, Product__r.ProductCode from Tag_Order_Line_Items__r)
FROM Tag_Order__c WHERE ID = :TagOrderId];

List<ContentDocumentLink> latestXML = [SELECT Id, LinkedEntityId, ContentDocumentId FROM ContentDocumentLink 
WHERE LinkedEntityId =:TagOrderId Order by ContentDocument.CreatedDate DESC];

if(latestXML.size() > 0){
List<ContentVersion> cv = [Select Id, VersionData FROM ContentVersion 
WHERE ContentDocumentId = : latestXML[0].ContentDocumentId];
if(cv.size() > 0){
Blob XMLfile = cv[0].VersionData;
Dom.Document response = new Dom.Document();
String xmlString = XMLFile.toString();
//system.debug(xmlstring);
response.load(xmlString);  
List<TagOrderStatusHelper.TagDetail> tagList;
try{
tagList = TagOrderStatusHelper.updateOrderStatus(response, orders[0]);
} catch (Exception e){
ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'There are no tag details avilable.'));
system.debug(e.getMessage() + e.getStackTraceString());
pageMessage = 'There are no tag details for this order yet.';
return null;
}
if(tagList.size() > 0){
Map<ID, TagDetail> idToTagDetail = new Map<ID, TagDetail>();
for(TagOrderStatusHelper.TagDetail tag : tagList){
TagDetail newTag;
if(idToTagDetail.get(tag.parentId) == null){
newTag = new TagDetail();
newTag.Name = tag.Name;
newTag.LineId = tag.LineId;
newTag.LineQuantity = tag.LineQuantity;
newTag.LinePrice = tag.LinePrice;
idToTagDetail.put(tag.parentId, newtag);
} else {
newTag = idToTagDetail.get(tag.parentId);
}

TagDetailChild newChild = new TagDetailChild();
newChild.EID = tag.EID;
newChild.SerialNumber = tag.SerialNumber;
newChild.Management = tag.management;
newChild.ContainerId = tag.ContainerId;
newChild.InnerContainerID = tag.InnerContainerID;
newTag.children.add(newChild);
newTag.children.sort();
}

tags.addAll(idToTagDetail.values());
}

}
} else {
pageMessage = 'There are no tag details for this order yet.';
}


return null;
}    */
    
    
    public pageReference UpdateOrder(){
        try{            
            List<Tag_Order__c> orders = [Select Id, Name, AllFlexOrderID__c, AllFlexSyncStatus__c, Status__c, Opportunity__r.AccountId,
                                         Opportunity__r.Account.Name, Opportunity__r.Account.BillingStreet, Opportunity__r.Account.BillingCity, 
                                         Opportunity__r.Account.BillingState, Opportunity__r.Account.BillingPostalCode, Purchase_Order__c,
                                         Opportunity__r.Account.Phone, Opportunity__r.Account.BillingCountry, Shipping_Method_AF__c, 
                                         (Select Id, Quantity__c, Product__c, Product__r.ProductCode from Tag_Order_Line_Items__r),
                                         ShippingCity__c, ShippingAddress__c, ShippingState__c, ShippingZip__c, Premise_ID__c 
                                         FROM Tag_Order__c WHERE ID = :TagOrderId];
            
            Dom.Document response = TagOrderStatusHelper.getOrderStatus(orders[0]);
            TagOrderStatusHelper.updateOrderStatus(response, orders[0]);
            
            PageReference returnPage = new ApexPages.StandardController(thisOrder).view(); 
            return returnpage;
        }  catch (exception e){
            system.debug('*** XML Exception: ' + e.getMessage() + ' ' + e.getStackTraceString());                       
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'There was a problem updating your order.' + e.getMessage() + ' ' + e.getStackTraceString()));
            return null;
        }
        
    }
    
    public pageReference SendOrder(){
        try{
            List<Tag_Order__c> orders = [Select Id, Name, AllFlexOrderID__c, AllFlexSyncStatus__c, Status__c, BillingCountry__c, Opportunity__r.AccountId,
                                         Opportunity__r.Account.Name, Opportunity__r.Account.BillingStreet, Opportunity__r.Account.BillingCity, 
                                         Opportunity__r.Account.BillingState, Opportunity__r.Account.BillingPostalCode, Purchase_Order__c, 
                                         Opportunity__r.Account.Phone, Opportunity__r.Account.BillingCountry, Shipping_Method_AF__c,
                                         Premise_ID__c,Opportunity__r.CVS_Assigned_Users__c, 
                                         (Select Id, WS_Order_Line_ID__c, Quantity__c, Product__c, Product__r.ProductCode from Tag_Order_Line_Items__r),
                                         ShippingCity__c, ShippingAddress__c, ShippingState__c, ShippingZip__c
                                         FROM Tag_Order__c WHERE ID = :TagOrderId /*AND Status__c = 'Ready To Send'*/];
            Map<String, TagOrderLineItem__c> codeToLine = new Map<String, TagOrderLineItem__c>();
            List<TagOrderLineItem__c> linesToUpdate = new List<TagOrderLineItem__c>();
            boolean isCVSNotAssignedError = false;
            Tag_Order__c o;
            if(orders.size() > 0){
                o = orders[0];
                if(o.Tag_Order_Line_Items__r.size()==0){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'There are no line items on this order, so it was not sent.'));
                    return null;
                }
                 if(o.Opportunity__r.CVS_Assigned_Users__c ==null && Test.isRunningTest() == false){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Error: A CVS is not assigned to the opportunity. Please assign a CVS to the opportunity and try again.'));
                    isCVSNotAssignedError = true;
                     return null;
                }
                if(o.BillingCountry__c ==null && Test.isRunningTest() == false)
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Error: Billing Country must be filled out.'));
                    return null;
                }
            }/* else {
ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'This order must have a status of "Ready To Send"'));
return null;
}*/
            
            List<AllFlex_API__c> apiDetails = [Select Name, BaseURL__c, API_Key__c, Email_to_Send_Notifications__c FROM AllFlex_API__c WHERE Name = 'Default']; 
            
            List<String> orderDetails = new List<String>();
            
            
            if(apiDetails.size() > 0 && isCVSNotAssignedError == false){
                string body = '';
                orderDetails.clear();
                if(o.AllFlexSyncStatus__c != 'Success'){
                    //build body
                    
                    body += '<?xml version="1.0" encoding="utf-8"?>';
                    body += '<OrderHeader>';
                    body += '  <CustomerNumber>32172</CustomerNumber>';                    
                    if(!String.isBlank(o.Premise_ID__c)){
                        body += '  <PremiseID>' + o.Premise_ID__c + '</PremiseID>';
                    }                    
                    body += '  <Comments>Comments1</Comments>';
                    body += '  <PO>' + o.Purchase_Order__c + '</PO>';
                    body += '  <ShipToName>' + o.Opportunity__r.Account.Name + '</ShipToName>';
                    body += '  <ShipToContact>ShipToContact1</ShipToContact>';
                    body += '  <ShipToPhone>' + o.Opportunity__r.Account.Phone + '</ShipToPhone>';
                    body += '  <ShipToAddress1>' + o.ShippingAddress__c + '</ShipToAddress1>';
                    body += '  <ShipToAddress2></ShipToAddress2>';
                    body += '  <ShipToAddress3></ShipToAddress3>';
                    body += '  <ShipToCity>' + o.ShippingCity__c + '</ShipToCity>';
                    body += '  <ShipToState>' + o.ShippingState__c + '</ShipToState>';
                    body += '  <ShipToPostalCode>' + o.ShippingZip__c + '</ShipToPostalCode>';
                    body += '  <ShipToCountry>' + o.Opportunity__r.Account.BillingCountry + '</ShipToCountry>';
                    body += '  <ShipMethod>' + o.Shipping_method_AF__c + '</ShipMethod>';
                    body += '  <EmailListError>' + apiDetails[0].Email_to_Send_Notifications__c + '</EmailListError>';
                    body += '  <EmailListTrackingInfo>' + apiDetails[0].Email_to_Send_Notifications__c + '</EmailListTrackingInfo>';
                    body += '  <EmailListEIDInfo>' + apiDetails[0].Email_to_Send_Notifications__c + '</EmailListEIDInfo>';
                    /*if(!String.isBlank(o.AllFlexOrderID__c)){
body += '  <WSOrderId>' + o.AllFlexOrderID__c + '</WSOrderId>';
}*//*else {
body += '  <WSOrderId>anyType</WSOrderId>';
}  */                  
                    for(TagOrderLineItem__c l : o.Tag_Order_Line_Items__r){
                        body += '  <OrderLineHeader>';
                        body += '    <SkuName>' + l.Product__r.ProductCode + '</SkuName>';
                        body += '    <Quantity>' + String.valueOf(l.Quantity__c) + '</Quantity>';
                        body += '    <Comment>Comment1</Comment>';                                          
                        body += '  </OrderLineHeader>';
                        codeToLine.put(l.Product__r.ProductCode, l);
                    }
                    
                    body += '</OrderHeader>';                    
                    
                    
                }
                system.debug('request: ' + body);
                body = body.replace('&', '&amp;');
                string results;
                //Make call to AllFlex to place order
                try{
                    HttpRequest req = new HttpRequest(); 
                    if(test.isRunningTest()){
                        req.setEndpoint('http://fakeErrorResponse');
                    } else {
                        req.setEndpoint(apiDetails[0].BaseURL__c);
                    }
                    /*if(!String.isBlank(o.AllFlexOrderID__c)){
req.setMethod('PUT');
} else {*/
                    req.setMethod('POST');
                    //}
                    
                    req.setHeader('Content-Type', 'application/xml');
                    req.setHeader('Authorization', 'Bearer ' + apiDetails[0].API_Key__c);
                    req.setBody(body); 
                    //system.debug(req.getHeader('Authorization'));
                    Http http = new Http();
                    HTTPResponse res = http.send(req);
                    
                    results = res.getBody();
                    
                    system.debug('response: ' + results);
                    
                    dom.Document resDoc = res.getBodyDocument();
                    DOM.XmlNode root;
                    
                    root = resDoc.getRootElement();
                    //system.debug(root);
                    
                    try{
                        String orderId = root.getChildElement('WSOrderId', null).getText();
                        o.AllFlexOrderID__c = orderId;
                        o.Status__c = 'Order Sent';
                        o.Tags_Ordered__c = date.today();
                        o.AllFlexSyncStatus__c = 'Success';
                        
                        
                        /* Commenting out following code on the request from Jason F.
                         * for(Dom.XmlNode lineItem : root.getChildElements()){
                            if(lineItem.getName()=='OrderLineHeader'){
                                String lineId = lineItem.getChildElement('WSOrderLineId', null).getText();
                                String prodCode = lineItem.getChildElement('SkuName', null).getText();
                                TagOrderLineItem__c thisLine = codeToLine.get(prodCode);
                                if(thisLine != null){
                                    thisLine.WS_Order_Line_ID__c = lineId;
                                    linesToUpdate.add(thisLine);
                                }
                            }  
                        }*/
                        if(linesToUpdate.size() > 0){
                            update linesToUpdate;
                        }
                        
                        TagOrderStatusHelper.attachXMLFile(String.valueOf(resDoc.toXMLString()), o, 'Order Received');
                    } catch(Exception e){
                        //Dom.XmlNode head = root.getChildElement('Error', null);
                        String orderResult = root.getChildElement('Message', null).getText();
                        //String headerResult = root.getChildElement('body', null).getChildElement('h2', null).getText();
                        o.AllFlexSyncStatus__c = orderResult/* + ' ' + headerResult*/;
                        update o;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'There was a problem placing your order.' + e.getMessage() + ' ' + e.getStackTraceString()));
                        return null;
                    }
                    
                    
                } catch (exception ex){
                    try{
                        String errorMessage = results;
                        errorMessage = errorMessage.replaceAll('<[^>]+>',' ');
                        
                        errorMessage = errorMessage.abbreviate(255);
                        o.AllFlexSyncStatus__c = errorMessage;   
                        update o;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'There was a problem placing your order.' + errorMessage));
                        return null;
                    } catch(exception e){
                        system.debug('*** XML Exception: ' + ex.getMessage() + ' ' + ex.getStackTraceString());   
                        o.AllFlexSyncStatus__c = ex.getMessage();   
                        update o;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'There was a problem placing your order.' + ex.getMessage() + ' ' + ex.getStackTraceString()));
                        return null;
                    }
                    
                    
                }
                
                
                
            } else {
                system.debug('You need to set a default AllFlex API setting in custom settings.');
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'You need to set a default AllFlex API setting in custom settings.'));
                return null;
            }
            
            update o;
            
            PageReference returnPage = new ApexPages.StandardController(thisOrder).view(); 
            return returnpage;
            
        } catch (Exception e){            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, e.getMessage() + e.getStackTraceString()));
            return null;
        }
        
    }
}