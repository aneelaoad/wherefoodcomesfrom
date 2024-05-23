public class TagOrderStatusHelper {
    public class TagDetail{
        public String Name;        
        public String EID;        
        public String SerialNumber;        
        public String Management;       
        public String LineId;
        public String LineQuantity;
        public String LinePrice; 
        public ID parentId;
        public String ContainerId;
        public String InnerContainerId;
        
        public TagDetail(){
            
        }
    }
    
    public static List<Tag_Order__c> getPendingOrders(){
        List<Tag_Order__c> orders = [Select Id, Name, AllFlexOrderID__c, AllFlexSyncStatus__c, Status__c, Opportunity__r.AccountId,
                                         Opportunity__r.Account.Name, Opportunity__r.Account.BillingStreet, Opportunity__r.Account.BillingCity, 
                                         Opportunity__r.Account.BillingState, Opportunity__r.Account.BillingPostalCode, Purchase_Order__c,
                                         Opportunity__r.Account.Phone, Opportunity__r.Account.BillingCountry, Shipping_Method_AF__c, 
                                         (Select Id, Quantity__c, Product__c, Product__r.ProductCode from Tag_Order_Line_Items__r),
                                         ShippingCity__c, ShippingAddress__c, ShippingState__c, ShippingZip__c, Premise_ID__c, 
                                     Tracking__c, Tags_Allocated__c
                                     FROM Tag_Order__c 
                                     WHERE Status__c != 'Manifest Created'  AND AllFlexOrderId__c != null];
        
        return Orders;
        
    }
    
    public static void startBatchToGetOrders(){
        // call batch process and past list of orders
        TagOrderStatusBatch tagBatch = new TagOrderStatusBatch();
        Database.executeBatch(tagBatch,60); //60 records per batch, as certification API has a limitation to 60 calls per minute
          
    }
    
    public static Dom.Document getOrderStatus(Tag_Order__c order){
         
        String afOrderId = order.AllFlexOrderID__c;
        
        AllFlex_API__c apiDetail = [Select Name, BaseURL__c, API_Key__c FROM AllFlex_API__c WHERE Name = 'Default' limit 1]; 
        
        //Call API and get order status for this orderid
        
        try{
            HttpRequest req = new HttpRequest(); 
            if(test.isRunningTest()){
                req.setEndpoint('http://fakeErrorResponse');
            } else {
                req.setEndpoint(apiDetail.BaseURL__c + 'status/' + order.AllFlexOrderID__c);
            }
            req.setMethod('GET');
            req.setHeader('Content-Type', 'application/xml');
            req.setHeader('Authorization', 'Bearer ' + apiDetail.API_Key__c);
            
            Http http = new Http();
            HTTPResponse res = null;
            
            if(test.isRunningTest() == false)
                res = http.send(req);
            
            string results;            
            
            //fake response
            if(test.isRunningTest()){
                results = getSampleResponse();
                //end fake response
            } else {                    
                //real response
                results = res.getBody();
                //end real response
            }
            
            system.debug('tag order status helper response: ' + results);
            //return the API response
            Dom.Document response = new Dom.Document();
            response.load(results);            
            
            return response;    
            
        } catch (exception e){
            system.debug('*** XML Exception: ' + e.getMessage() + ' ' + e.getStackTraceString());   
            order.AllFlexSyncStatus__c = e.getMessage();
            update order;
            throw e;
        }
        
        
    }
    
    
    
    //calling the Flex API to get the order status
    public static Dom.Document getOrderStatus(Tag_Order__c order, AllFlex_API__c apiDetail){
         
        String afOrderId = order.AllFlexOrderID__c;
        if (apiDetail == null)
            apiDetail = [Select Name, BaseURL__c, API_Key__c FROM AllFlex_API__c WHERE Name = 'Default' limit 1]; 
        
        //Call API and get order status for this orderid
        
        try{
            HttpRequest req = new HttpRequest(); 
            if(test.isRunningTest()){
                req.setEndpoint('http://fakeErrorResponse');
            } else {
                req.setEndpoint(apiDetail.BaseURL__c + 'status/' + order.AllFlexOrderID__c);
            }
            req.setMethod('GET');
            req.setHeader('Content-Type', 'application/xml');
            req.setHeader('Authorization', 'Bearer ' + apiDetail.API_Key__c);
            
            Http http = new Http();
            HTTPResponse res = null;
            
            if(test.isRunningTest() == false)
                res = http.send(req);
            
            string results;            
            
            //fake response
            if(test.isRunningTest()){
                results = getSampleResponse();
                //end fake response
            } else {                    
                //real response
                results = res.getBody();
                //end real response
            }
            
            system.debug('tag order status helper response: ' + results);
            //return the API response
            Dom.Document response = new Dom.Document();
            response.load(results);            
            
            return response;    
            
        } catch (exception e){
            system.debug('*** XML Exception: ' + e.getMessage() + ' ' + e.getStackTraceString());   
            order.AllFlexSyncStatus__c = e.getMessage();
            update order;
            throw e;
        }
        
        
    }
    
    
    public static void attachXMLFile(String root, Tag_Order__c order, String stringToAdd){
        //Attach response as file
        ContentVersion cont = new ContentVersion();
        cont.Title = 'Order Update: ' + order.Name + ' - ' + stringToAdd;
        cont.PathOnClient = 'file_' + Datetime.now().getTime() + '.xml';
        cont.VersionData = Blob.valueOf(root);
        cont.Origin = 'H';
        insert cont;
        
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cont.Id].ContentDocumentId;
        cdl.LinkedEntityId = order.Id;
        cdl.ShareType = 'I';
        insert cdl;
    }
    
    public static void updateOrderStatus(Dom.Document response, Tag_Order__c order){
        List<SV2_API__mdt> apiDetails = [Select Send_to_SV2__c, UserName__c, Base_URL__c, Password__c FROM SV2_API__mdt WHERE Label = 'Default']; 
        Boolean sendToSV2 = true;
        if(apiDetails.size() > 0){
            sendToSv2 = apiDetails[0].Send_to_SV2__c;
        }
        updateOrderStatus(response, order, sendToSV2);
    }
    
    public static boolean updateOrderTags(Dom.Document response, Tag_Order__c order
                                          , List<TagOrderLineItem__c> tagLines, list<TagOrderLineTag__c> orderTags
                                         , string taskPerformed, boolean sendToSV2)
    {  
        tagLines.clear();
        taskPerformed = '';
        tagLines.addAll(order.Tag_Order_Line_Items__r);
        Map<String, ID> productSKUToParentId = new Map<String, ID>();
        order.AllFlexSyncStatus__c = '';
        map<Id, TagOrderLineItem__c> tagOrderLineItemsById = new map<Id, TagOrderLineItem__c>(); 
        if(tagLines.size() > 0){
            for(TagOrderLineItem__c tagL : tagLines){
                productSKUToParentId.put(tagL.Product__r.ProductCode, tagL.Id);
                tagL.AllFlexSyncStatus__c = '';
                tagOrderLineItemsById.put(tagL.Id, tagL);
            }
        } else {
            system.debug('no tag lines exist for this order.');
            order.AllFlexSyncStatus__c += ' - No tag lines exist for this order.';
        }
        
        //Get first node (OrderStatus)
        DOM.XmlNode root = response.getRootElement();
        
        //Make a list of tags to add
        //List<TagDetail> tagsToAdd = new List<TagDetail>();
        //List<TagOrderLineTag__c> tagManifestList = new List<TagOrderLineTag__c>();
        orderTags.clear();
        
        String namespace = root.getNamespace();  
        
        //Keeps track of if there is an error message in the file
        Boolean hasError = false;        
        String Status = '';        
        
        Boolean StatusChanged = false;
        Boolean XMLFileAttached = false;
        try{
            if (root.getChildElement('Status', namespace) == null)
            {
                order.AllFlexSyncStatus__c += '-Status child element not found.';
            }
            else
            {
                Status = root.getChildElement('Status', namespace).getText();
            
                system.debug(root);
                order.AllFlexSyncStatus__c = 'Success';
                XMLFileAttached = false;
                
                if(order.Status__c != Status){
                    order.Status__c = Status; 
                    Dom.XmlNode mess = root.getChildElement('Messages', namespace);
                    if(mess != null){
                        if(mess.getChildElement('ErrorMessage', namespace) != null){
                            order.AllflexSyncStatus__c = mess.getChildElement('ErrorMessage', namespace).getText();                        
                        }
                    }
                    StatusChanged = true;  
                    XMLFileAttached = true;   
                }
            }
            
            //Get shipping method if there
            try{
                String method = '';
                
                if(root.getChildElement('Shipment', namespace) == null)
                {
                    order.AllFlexSyncStatus__c += '-Shipment child element not found.';
                }
                else
                {                
                    method = root.getChildElement('Shipment', namespace).getChildElement('ShipMethod', namespace).getText();
                    
                    if(order.Shipping_Method_AF__c != method && !XMLFileAttached && StatusChanged){
                        //attachXMLFile(response.toXMLString(), order, 'Shipping Method Update');
                        XMLFileAttached = true;
                        taskPerformed += 'Shipping Method Updated -';
                    }
                    order.Shipping_Method_AF__c = method;
                }
            }catch(Exception e){
                system.debug('shipping method not ready yet' + e.getMessage() + e.getStackTraceString());
                order.AllFlexSyncStatus__c = order.AllFlexSyncStatus__c == '' ? 'Shipping method not found from AllFlex response.' : order.AllFlexSyncStatus__c + '\nShipping method not found from AllFlex response.';
            }
            
            //Get tracking number if there
            try{
                String trackingNum = root.getChildElement('Shipment', namespace).getChildElement('TrackingNumber', namespace).getText();
                system.debug(trackingNum);
                if(order.Tracking__c != trackingNum && !XMLFileAttached && StatusChanged){
                    //attachXMLFile(response.toXMLString(), order, 'Tracking Update');
                    taskPerformed += 'Tracking Update -';
                    XMLFileAttached = true;
                }
                order.Tracking__c = trackingNum;
            }catch(Exception e){
                system.debug('tracking not ready yet' + e.getMessage() + e.getStackTraceString());
                order.AllFlexSyncStatus__c = order.AllFlexSyncStatus__c == '' ? 'Tracking not found from AllFlex response.' : order.AllFlexSyncStatus__c + '\nTracking not found from AllFlex response.';
            }
            
            //Get tags if there
            try{    
                
                Dom.XmlNode Shipment = root.getChildElement('Shipment', namespace);
                
                for(Dom.XmlNode child : Shipment.getChildElements()){
                    if(child.getName() == 'OrderLine'){
                        Dom.XmlNode OrderLine = child;
                        String lineId = OrderLine.getChildElement('ItemNumber', namespace).getText();
                        String quantity = OrderLine.getChildElement('Quantity', namespace).getText();
                        try{
                            Dom.XmlNode TagManifest = OrderLine.getChildElement('TagManifest', namespace);
                            if(TagManifest != null){
                                for(Dom.XmlNode container : TagManifest.getChildElements()){                                    
                                    if(container.getName() == 'Container'){
                                        String containerId = container.getChildElement('ID', namespace).getText();
                                        String innerContainerId = container.getChildElement('Type', namespace).getText();
                                        Dom.XmlNode TagList = container.getChildElement('Tags', namespace);
                                        
                                        
                                        for(Dom.XmlNode TagSet : TagList.getChildElements()){
                                            if(TagSet.getName() == 'TagSet'){
                                                TagOrderLineTag__c newTag = new TagOrderLineTag__c();
                                                newTag.TagOrderLineItem__c = productSKUToParentId.get(lineId);
                                                newTag.ContainerId__c = containerId;
                                                newTag.InnerContainerId__c = innerContainerId;
                                                for(Dom.XMLNode Variable : TagSet.getChildElements()){
                                                    String varName = Variable.getChildElement('Name', namespace).getText();
                                                    String varValue = Variable.getChildElement('Value', namespace).getText();                                 
                                                    
                                                    if(varName == 'EID'){                                    
                                                        newTag.EID__c = varValue;
                                                    } else if(varName == 'RegistrationNumber'){
                                                        newTag.SerialNumber__c = varValue;
                                                    } else if(varName == 'ManagementNumber'){
                                                        newTag.Management__c = varValue;
                                                    }
                                                    
                                                }
                                                
                                                orderTags.add(newTag);
                                                
                                                
                                            }
                                        }
                                        
                                    }
                                }
                            }
                        } catch(Exception e){
                            system.debug('Tag Line: ' + lineId + ' does not have a tag manifest'  + e.getMessage() + e.getStackTraceString());
                            string lineItemId = productSKUToParentId.get(lineId);
                            TagOrderLineItem__c lineItem = tagOrderLineItemsById.get(lineItemId);
                            if(lineItem.AllFlexSyncStatus__c == '')
                                lineItem.AllFlexSyncStatus__c = 'Tag Line: ' + lineId + ' does not have a tag manifest';
                            else
                                lineItem.AllFlexSyncStatus__c = '\nTag Line: ' + lineId + ' does not have a tag manifest';
                            
                        }
                        
                        
                        
                    }
                }
                
            }catch(Exception e){
                system.debug('tags not ready yet' + e.getMessage() + e.getStackTraceString());
            }
            
            
        } catch(Exception e){
            system.debug('error: ' + e.getMessage() + e.getStackTraceString());
            Dom.XmlNode head = root.getChildElement('head', null);
            String orderResult = head.getChildElement('title', null).getText();
            String headerResult = root.getChildElement('body', null).getChildElement('h2', null).getText();
            order.AllFlexSyncStatus__c = orderResult + ' ' + headerResult;
        }
        
        /*if(tagsToAdd.size() > 0){
order.Tags_Allocated__c = 'Yes';
}*/     
        
        if(orderTags.size() > 0){
            order.Tags_Allocated__c = 'Yes';
            
            //insert TagManifestList;
            //Schema.SObjectField f = TagOrderLineTag__c.Fields.EID__c;
            //database.upsert(tagManifestList, f, true); //to get the exception

            order.Status__c = 'Manifest Created';
            Status = 'Manifest Created';
            StatusChanged = true;

            if((sendToSV2 || Test.isRunningTest())){
            //    TagOrderXMLToSV2.sendXMLToXV2(response.toXMLString()); //calling future method
            }
        }

        if(StatusChanged){
                //attachXMLFile(response.toXMLString(), order, Status);
        }
        taskPerformed = Status;
        return Statuschanged;
    }
    
    public static void updateOrderStatus(Dom.Document response, Tag_Order__c order, Boolean sendToSV2)
    {       
        List<TagOrderLineItem__c> tagLines = order.Tag_Order_Line_Items__r;
        Map<String, ID> productSKUToParentId = new Map<String, ID>();
        order.AllFlexSyncStatus__c = '';
        map<Id, TagOrderLineItem__c> tagOrderLineItemsById = new map<Id, TagOrderLineItem__c>(); 
        if(tagLines.size() > 0){
            for(TagOrderLineItem__c tagL : tagLines){
                productSKUToParentId.put(tagL.Product__r.ProductCode, tagL.Id);
                tagL.AllFlexSyncStatus__c = '';
                tagOrderLineItemsById.put(tagL.Id, tagL);
            }
        } else {
            system.debug('no tag lines exist for this order.');
            order.AllFlexSyncStatus__c = 'No tag lines exist for this order.';
        }
        
        //Get first node (OrderStatus)
        DOM.XmlNode root = response.getRootElement();
        
        //Make a list of tags to add
        //List<TagDetail> tagsToAdd = new List<TagDetail>();
        List<TagOrderLineTag__c> tagManifestList = new List<TagOrderLineTag__c>();
        
        String namespace = root.getNamespace();  
        
        //Keeps track of if there is an error message in the file
        Boolean hasError = false;        
        String Status = '';        
        
        Boolean StatusChanged = false;
        
        try{
            Status = root.getChildElement('Status', namespace).getText();
            system.debug(root);
            order.AllFlexSyncStatus__c = 'Success';
            Boolean XMLFileAttached = false;
            
            if(order.Status__c != Status){
                order.Status__c = Status; 
                Dom.XmlNode mess = root.getChildElement('Messages', namespace);
                if(mess != null){
                    if(mess.getChildElement('ErrorMessage', namespace) != null){
                        order.AllflexSyncStatus__c = mess.getChildElement('ErrorMessage', namespace).getText();                        
                    }
                }
                StatusChanged = true;  
                XMLFileAttached = true;              
            }
            
            //Get shipping method if there
            try{
                String method = root.getChildElement('Shipment', namespace).getChildElement('ShipMethod', namespace).getText();
                
                if(order.Shipping_Method_AF__c != method && !XMLFileAttached && StatusChanged){
                    attachXMLFile(response.toXMLString(), order, 'Shipping Method Update');
                    XMLFileAttached = true;
                }
                order.Shipping_Method_AF__c = method;
            }catch(Exception e){
                system.debug('shipping method not ready yet' + e.getMessage() + e.getStackTraceString());
                order.AllFlexSyncStatus__c = order.AllFlexSyncStatus__c == '' ? 'Shipping method not found from AllFlex response.' : order.AllFlexSyncStatus__c + '\nShipping method not found from AllFlex response.';
            }
            
            //Get tracking number if there
            try{
                String trackingNum = root.getChildElement('Shipment', namespace).getChildElement('TrackingNumber', namespace).getText();
                system.debug(trackingNum);
                if(order.Tracking__c != trackingNum && !XMLFileAttached && StatusChanged){
                    attachXMLFile(response.toXMLString(), order, 'Tracking Update');
                    XMLFileAttached = true;
                }
                
                //Aamir Maqsood - 12/12/2019
                //as long as the status is confirmed and tracking number is available then update
                if((order.Status__c=='Confirmed' || Status == 'Confirmed') && order.Tracking__c == null && trackingNum !=null)
                {
                  order.Tracking__c = trackingNum;
                }
            
            }catch(Exception e){
                system.debug('tracking not ready yet' + e.getMessage() + e.getStackTraceString());
                order.AllFlexSyncStatus__c = order.AllFlexSyncStatus__c == '' ? 'Tracking not found from AllFlex response.' : order.AllFlexSyncStatus__c + '\nTracking not found from AllFlex response.';
            }
            
            //Get tags if there
            try{    
                
                Dom.XmlNode Shipment = root.getChildElement('Shipment', namespace);
                
                for(Dom.XmlNode child : Shipment.getChildElements()){
                    if(child.getName() == 'OrderLine'){
                        Dom.XmlNode OrderLine = child;
                        String lineId = OrderLine.getChildElement('ItemNumber', namespace).getText();
                        String quantity = OrderLine.getChildElement('Quantity', namespace).getText();
                        try{
                            Dom.XmlNode TagManifest = OrderLine.getChildElement('TagManifest', namespace);
                            if(TagManifest != null){
                                for(Dom.XmlNode container : TagManifest.getChildElements()){                                    
                                    if(container.getName() == 'Container'){
                                        String containerId = container.getChildElement('ID', namespace).getText();
                                        String innerContainerId = container.getChildElement('Type', namespace).getText();
                                        Dom.XmlNode TagList = container.getChildElement('Tags', namespace);
                                        
                                        
                                        for(Dom.XmlNode TagSet : TagList.getChildElements()){
                                            if(TagSet.getName() == 'TagSet'){
                                                TagOrderLineTag__c newTag = new TagOrderLineTag__c();
                                                newTag.TagOrderLineItem__c = productSKUToParentId.get(lineId);
                                                newTag.ContainerId__c = containerId;
                                                newTag.InnerContainerId__c = innerContainerId;
                                                for(Dom.XMLNode Variable : TagSet.getChildElements()){
                                                    String varName = Variable.getChildElement('Name', namespace).getText();
                                                    String varValue = Variable.getChildElement('Value', namespace).getText();                                 
                                                    
                                                    if(varName == 'EID'){                                    
                                                        newTag.EID__c = varValue;
                                                    } else if(varName == 'RegistrationNumber'){
                                                        newTag.SerialNumber__c = varValue;
                                                    } else if(varName == 'ManagementNumber'){
                                                        newTag.Management__c = varValue;
                                                    }
                                                    
                                                }
                                                
                                                tagManifestList.add(newTag);
                                                
                                                
                                            }
                                        }
                                        
                                    }
                                }
                            }
                        } catch(Exception e){
                            system.debug('Tag Line: ' + lineId + ' does not have a tag manifest'  + e.getMessage() + e.getStackTraceString());
                            string lineItemId = productSKUToParentId.get(lineId);
                            TagOrderLineItem__c lineItem = tagOrderLineItemsById.get(lineItemId);
                            if(lineItem.AllFlexSyncStatus__c == '')
                                lineItem.AllFlexSyncStatus__c = 'Tag Line: ' + lineId + ' does not have a tag manifest';
                            else
                                lineItem.AllFlexSyncStatus__c = '\nTag Line: ' + lineId + ' does not have a tag manifest';
                            
                        }
                        
                        
                        
                    }
                }
                
            }catch(Exception e){
                system.debug('tags not ready yet' + e.getMessage() + e.getStackTraceString());
            }
            
            
        } catch(Exception e){
            system.debug('error: ' + e.getMessage() + e.getStackTraceString());
            Dom.XmlNode head = root.getChildElement('head', null);
            String orderResult = head.getChildElement('title', null).getText();
            String headerResult = root.getChildElement('body', null).getChildElement('h2', null).getText();
            order.AllFlexSyncStatus__c = orderResult + ' ' + headerResult;
        }
        
        /*if(tagsToAdd.size() > 0){
order.Tags_Allocated__c = 'Yes';
}*/     
        
        if(TagManifestList.size() > 0){
            order.Tags_Allocated__c = 'Yes';
            
            //insert TagManifestList;
            Schema.SObjectField f = TagOrderLineTag__c.Fields.EID__c;
            database.upsert(tagManifestList, f, true); //to get the exception

            order.Status__c = 'Manifest Created';
            Status = 'Manifest Created';
            StatusChanged = true;

            if((sendToSV2 || Test.isRunningTest())){
                TagOrderXMLToSV2.sendXMLToXV2(response.toXMLString());
            }
        }

        if(StatusChanged){
                attachXMLFile(response.toXMLString(), order, Status);
        }
        
        update order;
        update tagLines;
        
        //return tagsToAdd;
    }    
    
    public static String getSampleResponse(){
        String body = '';
        body += '<?xml version="1.0" encoding="utf-8"?>';
        body += '<OrderStatus xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">';
        body += '<WSOrderId>9f5add04-6e29-4044-965a-3e7d0166db1c</WSOrderId>';
        body += '<PO>DJones-0009</PO>';
        body += '<MasterId>10904437</MasterId>';
        body += '<OrderId>EID079451</OrderId>';
        body += '<Status>Invoiced</Status>';
        body += '<Progress>100</Progress>';
        body += '<Shipment>';
        body += '<ShipMethod />';
        body += '<FreightAmount>0</FreightAmount>';
        body += '<TrackingNumber></TrackingNumber>';
        body += '<ShippingDate>2018-01-12T00:00:00</ShippingDate>';
        body += '<Address>';
        body += '<Name>test account</Name>';
        body += '<Phone>508-555-9999</Phone>';
        body += '<Address1>123 Dennis Ave</Address1>';
        body += '<Address2>Ship to Address 2</Address2>';
        body += '<City>Dennis</City>';
        body += '<State>MA</State>';
        body += '<PostalCode>02638</PostalCode>';
        body += '<Country>USA</Country>';
        body += '</Address>';
        body += '<OrderLine>';
        body += '<LineNumber>0</LineNumber>';
        body += '<ItemNumber>IMI-FDXOTP982-BG/GESM-G-20</ItemNumber>';
        body += '<Quantity>20</Quantity>';
        body += '<Template />';
        body += '<Status>Shipped</Status>';
        body += '<Progress>0</Progress>';
        body += '<TagManifest>';
        body += '<Container>';
        body += '<ID>case</ID>';
        body += '<Type>Case</Type>';
        body += '<Tags />';
        body += '<Container>';
        body += '<ID>B1</ID>';
        body += '<Type>Bag</Type>';
        body += '<Tags>';
        body += '<TagSet>';
        body += '<Variable>';
        body += '<Name>ManagementNumber</Name>';
        body += '<Value>MN9</Value>';
        body += '</Variable>';
        body += '<Variable>';
        body += '<Name>RegistrationNumber</Name>';
        body += '<Value>0</Value>';
        body += '</Variable>';
        body += '<Variable>';
        body += '<Name>EID</Name>';
        body += '<Value>9</Value>';
        body += '</Variable>';
        body += '</TagSet>';
        body += '<TagSet>';
        body += '<Variable>';
        body += '<Name>ManagementNumber</Name>';
        body += '<Value>MN8</Value>';
        body += '</Variable>';
        body += '<Variable>';
        body += '<Name>RegistrationNumber</Name>';
        body += '<Value>0</Value>';
        body += '</Variable>';
        body += '<Variable>';
        body += '<Name>EID</Name>';
        body += '<Value>8</Value>';
        body += '</Variable>';
        body += '</TagSet>';
        body += '<TagSet>';
        body += '<Variable>';
        body += '<Name>ManagementNumber</Name>';
        body += '<Value>MN7</Value>';
        body += '</Variable>';
        body += '<Variable>';
        body += '<Name>RegistrationNumber</Name>';
        body += '<Value>0</Value>';
        body += '</Variable>';
        body += '<Variable>';
        body += '<Name>EID</Name>';
        body += '<Value>7</Value>';
        body += '</Variable>';
        body += '</TagSet>';
        body += '<TagSet>';
        body += '<Variable>';
        body += '<Name>ManagementNumber</Name>';
        body += '<Value>MN6</Value>';
        body += '</Variable>';
        body += '<Variable>';
        body += '<Name>RegistrationNumber</Name>';
        body += '<Value>0</Value>';
        body += '</Variable>';
        body += '<Variable>';
        body += '<Name>EID</Name>';
        body += '<Value>6</Value>';
        body += '</Variable>';
        body += '</TagSet>';
        body += '<TagSet>';
        body += '<Variable>';
        body += '<Name>ManagementNumber</Name>';
        body += '<Value>MN5</Value>';
        body += '</Variable>';
        body += '<Variable>';
        body += '<Name>RegistrationNumber</Name>';
        body += '<Value>0</Value>';
        body += '</Variable>';
        body += '<Variable>';
        body += '<Name>EID</Name>';
        body += '<Value>5</Value>';
        body += '</Variable>';
        body += '</TagSet>';
        body += '<TagSet>';
        body += '<Variable>';
        body += '<Name>ManagementNumber</Name>';
        body += '<Value>MN4</Value>';
        body += '</Variable>';
        body += '<Variable>';
        body += '<Name>RegistrationNumber</Name>';
        body += '<Value>0</Value>';
        body += '</Variable>';
        body += '<Variable>';
        body += '<Name>EID</Name>';
        body += '<Value>4</Value>';
        body += '</Variable>';
        body += '</TagSet>';
        body += '<TagSet>';
        body += '<Variable>';
        body += '<Name>ManagementNumber</Name>';
        body += '<Value>MN3</Value>';
        body += '</Variable>';
        body += '<Variable>';
        body += '<Name>RegistrationNumber</Name>';
        body += '<Value>0</Value>';
        body += '</Variable>';
        body += '<Variable>';
        body += '<Name>EID</Name>';
        body += '<Value>3</Value>';
        body += '</Variable>';
        body += '</TagSet>';
        body += '<TagSet>';
        body += '<Variable>';
        body += '<Name>ManagementNumber</Name>';
        body += '<Value>MN20</Value>';
        body += '</Variable>';
        body += '<Variable>';
        body += '<Name>RegistrationNumber</Name>';
        body += '<Value>0</Value>';
        body += '</Variable>';
        body += '<Variable>';
        body += '<Name>EID</Name>';
        body += '<Value>20</Value>';
        body += '</Variable>';
        body += '</TagSet>';
        body += '<TagSet>';
        body += '<Variable>';
        body += '<Name>ManagementNumber</Name>';
        body += '<Value>MN2</Value>';
        body += '</Variable>';
        body += '<Variable>';
        body += '<Name>RegistrationNumber</Name>';
        body += '<Value>0</Value>';
        body += '</Variable>';
        body += '<Variable>';
        body += '<Name>EID</Name>';
        body += '<Value>2</Value>';
        body += '</Variable>';
        body += '</TagSet>';
        body += '</Tags>';
        body += '</Container>';
        body += '</Container>';
        body += '</TagManifest>';
        body += '</OrderLine>';
        body += '</Shipment>';
        body += '</OrderStatus>';
        
        
        
        return body;
    }
}