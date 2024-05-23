@isTest
public class TagOrderTest {
    @isTest(seealldata=true)
    public static void testTagOrderSendHelper(){
        checkRecursive.runOnce();
        Opportunity o = [select id from Opportunity limit 1]; 
        Product2 p = [select id from Product2 WHERE ProductCode != null limit 1];
         Id devRecordTypeId = Schema.SObjectType.Tag_Order__c.getRecordTypeInfosByName().get('Tag Order').getRecordTypeId();
       
        
        Tag_Order__c tagorder = new Tag_Order__c(
            Name = 'CS Production Test Order3',                        // Tag Order Name
            Opportunity__c = o.id,                          // Opportunity
            Vendor__c = 'AllFlex',                                       // Vendor
            Tags_Ordered__c = Date.today(),                            // AllFlex Sync Message
            Status__c = 'Ready to Send' ,
            recordTypeId = devRecordTypeId// Status
        );
        insert tagorder;
        
        TagOrderLineItem__c line = new TagOrderLineItem__c(
            Name = 'test line',             // Tag Order Line Item Name
            Product__c = p.id,   // Products
            Quantity__c = 1000,               // Quantity
            Unit_Price__c = 2.25,             // Unit Price
            TagOrder__c = tagorder.Id  // Tag Order
        );
        insert line;
        
        TagOrderLineTag__c tag = new TagOrderLineTag__c(
            EID__c = '9',                           // EID
            SerialNumber__c = '0',                    // Serial Number
            Management__c = 'MN9',                    // Management
            TagOrderLineItem__c = line.id,  // Tag Order Line Item
            ContainerId__c = 'case',                  // ContainerId
            InnerContainerId__c = 'B1'               // InnerContainerId
        );
        insert tag;
        
        
        TagOrderSendHelper.TagDetail td = new TagOrderSendHelper.TagDetail();
        td.Name = 'test';
        td.lineId = line.id;
        td.lineQuantity = '1';
        td.lineprice = '1';
        
        TagOrderSendHelper.TagDetailChild tdc = new TagOrderSendHelper.TagDetailChild();
        tdc.parentId = line.id;
        tdc.eid = '123';
        tdc.serialnumber = 't123';
        tdc.management = 'test';
        tdc.containerid = 'test';
        tdc.innercontainerid = 'test';
        
        TagOrderSendHelper.TagDetailChild tdc2 = new TagOrderSendHelper.TagDetailChild();
        tdc2.parentId = line.id;
        tdc2.eid = '123';
        tdc2.serialnumber = 't123';
        tdc2.management = 'test';
        tdc2.containerid = 'test';
        tdc2.innercontainerid = 'test';
        
        List<TagOrderSendHelper.TagDetailChild> tdcList = new List<TagOrderSendHelper.TagDetailChild>();
        tdcList.add(tdc);
        tdcList.add(tdc2);
        tdcList.sort();
        
        List<Tag_Order__c> orders = new List<Tag_Order__c>();
        orders.add(tagorder);
        
        Test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new AllflexCalloutMockPost());
        HttpRequest req = new HttpRequest();
        req.setEndpoint('http://fakeErrorResponse');
        req.setMethod('POST');
        Http h = new Http();
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(tagorder);
        TagOrderSendHelper sendHelper = new TagOrderSendHelper(sc);
        sendHelper.tagOrderId = tagorder.id;
        PageReference pageRef = Page.TagOrderManifest;
        pageRef.getParameters().put('id', String.valueOf(tagorder.Id));
        Test.setCurrentPage(pageRef);
        
        sendHelper.SendOrder();
        sendHelper.getManifest();
        sendHelper.exportManifest();
        sendHelper.UpdateOrder();
         
        Test.stopTest();
    }

    @isTest(seealldata=true)
    public static void testTagOrderSendHelper2(){
        checkRecursive.runOnce();
        Opportunity o = [select id from Opportunity limit 1];
        Product2 p = [select id from Product2 WHERE ProductCode != null limit 1];
         Id devRecordTypeId = Schema.SObjectType.Tag_Order__c.getRecordTypeInfosByName().get('Tag Order').getRecordTypeId();
       
        
        Tag_Order__c tagorder = new Tag_Order__c(
            Name = 'CS Production Test Order3',                        // Tag Order Name
            Opportunity__c = o.id,                          // Opportunity
            Vendor__c = 'AllFlex',                                       // Vendor
            Tags_Ordered__c = Date.today(),                            // AllFlex Sync Message
            Status__c = 'Ready to Send' ,
            recordTypeId = devRecordTypeId// Status
        );
        insert tagorder;
        
        TagOrderLineItem__c line = new TagOrderLineItem__c(
            Name = 'test line',             // Tag Order Line Item Name
            Product__c = p.id,   // Product
            Quantity__c = 1000,               // Quantity
            Unit_Price__c = 2.25,             // Unit Price
            TagOrder__c = tagorder.Id  // Tag Order
        );
        insert line;
        
        TagOrderLineTag__c tag = new TagOrderLineTag__c(
            EID__c = '9',                           // EID
            SerialNumber__c = '0',                    // Serial Number
            Management__c = 'MN9',                    // Management
            TagOrderLineItem__c = line.id,  // Tag Order Line Item
            ContainerId__c = 'case',                  // ContainerId
            InnerContainerId__c = 'B1'               // InnerContainerId
        );
        insert tag;
        
        
        TagOrderSendHelper.TagDetail td = new TagOrderSendHelper.TagDetail();
        td.Name = 'test';
        td.lineId = line.id;
        td.lineQuantity = '1';
        td.lineprice = '1';
        
        TagOrderSendHelper.TagDetailChild tdc = new TagOrderSendHelper.TagDetailChild();
        tdc.parentId = line.id;
        tdc.eid = '123';
        tdc.serialnumber = 't123';
        tdc.management = 'test';
        tdc.containerid = 'test';
        tdc.innercontainerid = 'test';
        
        TagOrderSendHelper.TagDetailChild tdc2 = new TagOrderSendHelper.TagDetailChild();
        tdc2.parentId = line.id;
        tdc2.eid = '123';
        tdc2.serialnumber = 't123';
        tdc2.management = 'test';
        tdc2.containerid = 'test';
        tdc2.innercontainerid = 'test';
        
        List<TagOrderSendHelper.TagDetailChild> tdcList = new List<TagOrderSendHelper.TagDetailChild>();
        tdcList.add(tdc);
        tdcList.add(tdc2);
        tdcList.sort();
        
        List<Tag_Order__c> orders = new List<Tag_Order__c>();
        orders.add(tagorder);
        
        Test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new AllflexCalloutMockPost());
        HttpRequest req = new HttpRequest();
        req.setEndpoint('http://fakeErrorResponse');
        req.setMethod('POST');
        Http h = new Http();
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(tagorder);
        TagOrderSendHelper sendHelper = new TagOrderSendHelper(sc);
        sendHelper.tagOrderId = tagorder.id;
        PageReference pageRef = Page.TagOrderManifest;
        pageRef.getParameters().put('id', String.valueOf(tagorder.Id));
        Test.setCurrentPage(pageRef);
        
        sendHelper.UpdateOrder();
         
        Test.stopTest();
    }
    
    @isTest(seealldata=true)
    public static void testTagStatusHelper(){
        Opportunity o = [select id from Opportunity limit 1];
        Product2 p = [select id from Product2 WHERE ProductCode != null limit 1];
         Id devRecordTypeId = Schema.SObjectType.Tag_Order__c.getRecordTypeInfosByName().get('Tag Order').getRecordTypeId();
       
        Tag_Order__c tagorder = new Tag_Order__c(
            Name = 'CS Production Test Order3',                        // Tag Order Name
            Opportunity__c = o.id,                          // Opportunity
            Vendor__c = 'AllFlex',                                       // Vendor
            Tags_Ordered__c = Date.today(),                            // AllFlex Sync Message
            Status__c = 'Ready to Send',
            recordTypeId = devRecordtypeId// Status
        );
        insert tagorder;
        
        TagOrderLineItem__c line = new TagOrderLineItem__c(
            Name = 'test line',             // Tag Order Line Item Name
            Product__c = p.id,   // Product
            Quantity__c = 1000,               // Quantity
            Unit_Price__c = 2.25,             // Unit Price
            TagOrder__c = tagorder.Id  // Tag Order
        );
        insert line;
        
        TagOrderLineTag__c tag = new TagOrderLineTag__c(
            EID__c = '9',                           // EID
            SerialNumber__c = '0',                    // Serial Number
            Management__c = 'MN9',                    // Management
            TagOrderLineItem__c = line.id,  // Tag Order Line Item
            ContainerId__c = 'case',                  // ContainerId
            InnerContainerId__c = 'B1'               // InnerContainerId
        );
        insert tag;
        
        
        Test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new AllflexCalloutMock());
        HttpRequest req = new HttpRequest();
        req.setEndpoint('http://fakeErrorResponse');
        req.setMethod('GET');
        Http h = new Http();
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        HttpResponse res = h.send(req);
        
        TagOrderStatusHelper.getPendingOrders();
        TagOrderStatusHelper.getOrderStatus(tagorder, null); 
        TagOrderStatusHelper.getOrderStatus(tagorder); 
        Test.stopTest();
    }
    
    @isTest(seealldata=true)
    public static void testTagOrderScheduleandBatch(){
        Opportunity o = [select id from Opportunity limit 1];
        Product2 p = [select id from Product2 WHERE ProductCode != null limit 1];
        Id devRecordTypeId = Schema.SObjectType.Tag_Order__c.getRecordTypeInfosByName().get('Tag Order').getRecordTypeId();
        
        Tag_Order__c tagorder = new Tag_Order__c(
            Name = 'CS Production Test Order3',                        // Tag Order Name
            Opportunity__c = o.id,                          // Opportunity
            Vendor__c = 'AllFlex',                                       // Vendor
            Tags_Ordered__c = Date.today(),                            // AllFlex Sync Message
            Status__c = 'Ready to Send',
            recordTypeId = devRecordTypeId// Status
        );
        insert tagorder;
        
        TagOrderLineItem__c line = new TagOrderLineItem__c(
            Name = 'test line',             // Tag Order Line Item Name
            Product__c = p.id,   // Product
            Quantity__c = 1000,               // Quantity
            Unit_Price__c = 2.25,             // Unit Price
            TagOrder__c = tagorder.Id  // Tag Order
        );
        insert line;
        
        TagOrderLineTag__c tag = new TagOrderLineTag__c(
            EID__c = '9',                           // EID
            SerialNumber__c = '0',                    // Serial Number
            Management__c = 'MN9',                    // Management
            TagOrderLineItem__c = line.id,  // Tag Order Line Item
            ContainerId__c = 'case',                  // ContainerId
            InnerContainerId__c = 'B1'               // InnerContainerId
        );
        insert tag;
        
        try{
        	TagOrderLineTag__c tag2 = tag.clone(); //inserting duplicated EID
        	insert tag2;
        }catch(Exception ex){
        }
        
        List<Tag_Order__c> orders = new List<Tag_Order__c>();
        orders.add(tagorder);
        
        
        TagOrderStatusScheduler qcs = new TagOrderStatusScheduler();
        String schedule = '0 0 * * * ?';
        qcs.execute(null);
        //String jobID = system.schedule('Tag Order Sync Job', schedule, qcs);
        
        
        TagOrderStatusBatch tagBatch = new TagOrderStatusBatch();
        tagBatch.start(null);
        tagBatch.execute(null, orders);
        tagBatch.finish(null);
    }
    
    @istest (seealldata=true)
    public static void testTagOrderXMLToSv2(){
        Opportunity o = [select id from Opportunity limit 1];
        Product2 p = [select id, ProductCode from Product2 WHERE ProductCode != null limit 1];
         Id devRecordTypeId = Schema.SObjectType.Tag_Order__c.getRecordTypeInfosByName().get('Tag Order').getRecordTypeId();
       
        Tag_Order__c tagorder = new Tag_Order__c(
            Name = 'CS Production Test Order3',                        // Tag Order Name
            Opportunity__c = o.id,                          // Opportunity
            Vendor__c = 'AllFlex',                                       // Vendor
            Tags_Ordered__c = Date.today(),                            // AllFlex Sync Message
            Status__c = 'Ready to Send',
            recordTypeId = devRecordTypeId// Status
        );
        insert tagorder;
        
        TagOrderLineItem__c line = new TagOrderLineItem__c(
            Name = 'test line',             // Tag Order Line Item Name
            Product__c = p.id,   // Product
            Quantity__c = 1000,               // Quantity
            Unit_Price__c = 2.25,             // Unit Price
            TagOrder__c = tagorder.Id  // Tag Order
        );
        insert line;
        
        TagOrderLineTag__c tag = new TagOrderLineTag__c(
            EID__c = '9',                           // EID
            SerialNumber__c = '0',                    // Serial Number
            Management__c = 'MN9',                    // Management
            TagOrderLineItem__c = line.id,  // Tag Order Line Item
            ContainerId__c = 'case',                  // ContainerId
            InnerContainerId__c = 'B1'               // InnerContainerId
        );
        insert tag;

//Attach response as file
        ContentVersion cont = new ContentVersion();
        cont.Title = 'Order Update: ' + order.Name + ' - Manifest Created';
        cont.PathOnClient = 'file_' + Datetime.now().getTime() + '.xml';
        cont.VersionData = Blob.valueOf(TagOrderStatusHelper.getSampleResponse());
        cont.Origin = 'H';
        insert cont;
        
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cont.Id].ContentDocumentId;
        cdl.LinkedEntityId = tagorder.Id;
        cdl.ShareType = 'I';
        insert cdl;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(tagorder);
        TagOrderXMLToSV2 sv = new TagOrderXMLToSV2(sc);
        sv.sendXMLFromTagOrderToSV2();
        
    }
    
    public class AllflexCalloutMock implements HttpCalloutMock {
        //Mocks Reservation Detail Call
        public HTTPResponse respond(HTTPRequest req) {
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/xml');
            
            String body = '';
            body += '<OrderStatus';
body += 'xmlns:xsd="http://www.w3.org/2001/XMLSchema"';
body += 'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">';
body += '<WSOrderId>9cfd8f70-8752-4892-9123-23ea54523c81</WSOrderId>';
body += '<PO>KBraddock-0809</PO>';
body += '<MasterId>11014574</MasterId>';
body += '<OrderId>EID085486</OrderId>';
body += '<Status>Invoiced</Status>';
body += '<CustomerNumber>32172</CustomerNumber>';
body += '<Shipment>';
body += '<ShipMethod>UPS GROUND</ShipMethod>';
body += '<FreightAmount>15.13</FreightAmount>';
body += '<TrackingNumber>1Z74X1690340179617</TrackingNumber>';
body += '<ShippingDate>2018-06-12T15:45:17.947</ShippingDate>';
body += '<Address>';
body += '<Name>Rosewood Ennis LLC</Name>';
body += '<Phone />';
body += '<Address1>2101 Cedar Springs Rd</Address1>';
body += '<Address2>ShipToAddress21</Address2>';
body += '<City>Dallas</City>';
body += '<State>TX</State>';
body += '<PostalCode>75201</PostalCode>';
body += '<Country>USA</Country>';
body += '</Address>';
body += '<OrderLine>';
body += '<LineNumber>3572506</LineNumber>';
body += '<ItemNumber>IMI-FDXOTP982-BG/GESM-G-20</ItemNumber>';
body += '<Quantity>200</Quantity>';
body += '<Template>IMI_9OFGESM1_20</Template>';
body += '<Status>Invoiced</Status>';
body += '<TagManifest>';
body += '<Container>';
body += '<ID>B22300435</ID>';
body += '<Type>Bag</Type>';
body += '<Tags>';
body += '<TagSet>';
body += '<Variable>';
body += '<Name>EID</Name>';
body += '<Value>982000424805088</Value>';
body += '</Variable>';
body += '</TagSet>';
body += '<TagSet>';
body += '<Variable>';
body += '<Name>EID</Name>';
body += '<Value>982000424805087</Value>';
body += '</Variable>';
body += '</TagSet>';
body += '<TagSet>';
body += '<Variable>';
body += '<Name>EID</Name>';
body += '<Value>982000424805086</Value>';
body += '</Variable>';
body += '</TagSet>';
body += '<TagSet>';
body += '<Variable>';
body += '<Name>EID</Name>';
body += '<Value>982000424805085</Value>';
body += '</Variable>';
body += '</TagSet>';
body += '<TagSet>';
body += '<Variable>';
body += '<Name>EID</Name>';
body += '<Value>982000424805084</Value>';
body += '</Variable>';
body += '</TagSet>';
body += '<TagSet>';
body += '<Variable>';
body += '<Name>EID</Name>';
body += '<Value>982000424805083</Value>';
body += '</Variable>';
body += '</TagSet>';
body += '<TagSet>';
body += '<Variable>';
body += '<Name>EID</Name>';
body += '<Value>982000424805082</Value>';
body += '</Variable>';
body += '</TagSet>';
body += '<TagSet>';
body += '<Variable>';
body += '<Name>EID</Name>';
body += '<Value>982000424805081</Value>';
body += '</Variable>';
body += '</TagSet>';
body += '<TagSet>';
body += '<Variable>';
body += '<Name>EID</Name>';
body += '<Value>982000424805080</Value>';
body += '</Variable>';
body += '</TagSet>';
body += '<TagSet>';
body += '<Variable>';
body += '<Name>EID</Name>';
body += '<Value>982000424805079</Value>';
body += '</Variable>';
body += '</TagSet>';
body += '<TagSet>';
body += '<Variable>';
body += '<Name>EID</Name>';
body += '<Value>982000424805078</Value>';
body += '</Variable>';
body += '</TagSet>';
body += '<TagSet>';
body += '<Variable>';
body += '<Name>EID</Name>';
body += '<Value>982000424805077</Value>';
body += '</Variable>';
body += '</TagSet>';
body += '<TagSet>';
body += '<Variable>';
body += '<Name>EID</Name>';
body += '<Value>982000424805076</Value>';
body += '</Variable>';
body += '</TagSet>';
body += '<TagSet>';
body += '<Variable>';
body += '<Name>EID</Name>';
body += '<Value>982000424805075</Value>';
body += '</Variable>';
body += '</TagSet>';
body += '<TagSet>';
body += '<Variable>';
body += '<Name>EID</Name>';
body += '<Value>982000424805074</Value>';
body += '</Variable>';
body += '</TagSet>';
body += '<TagSet>';
body += '<Variable>';
body += '<Name>EID</Name>';
body += '<Value>982000424805073</Value>';
body += '</Variable>';
body += '</TagSet>';
body += '<TagSet>';
body += '<Variable>';
body += '<Name>EID</Name>';
body += '<Value>982000424805072</Value>';
body += '</Variable>';
body += '</TagSet>';
body += '<TagSet>';
body += '<Variable>';
body += '<Name>EID</Name>';
body += '<Value>982000424805071</Value>';
body += '</Variable>';
body += '</TagSet>';
body += '<TagSet>';
body += '<Variable>';
body += '<Name>EID</Name>';
body += '<Value>982000424805070</Value>';
body += '</Variable>';
body += '</TagSet>';
body += '<TagSet>';
body += '<Variable>';
body += '<Name>EID</Name>';
body += '<Value>982000424805069</Value>';
body += '</Variable>';
body += '</TagSet>';
body += '</Tags>';
body += '</Container>';
body += '<Container>';
body += '<ID>B22300434</ID>';
body += '<Type>Bag</Type>';
body += '<Tags>';
body += '<TagSet>';
body += '<Variable>';
body += '<Name>EID</Name>';
body += '<Value>982000424805068</Value>';
body += '</Variable>';
body += '</TagSet>';
body += '<TagSet>';
body += '<Variable>';
body += '<Name>EID</Name>';
body += '<Value>982000424805067</Value>';
body += '</Variable>';
body += '</TagSet>';
body += '<TagSet>';
            
            
            res.setBody(body);
            res.setStatusCode(200);
            return res;
        }
    }
    
    public class AllflexCalloutMockPost implements HttpCalloutMock {
        //Mocks Reservation Detail Call
        public HTTPResponse respond(HTTPRequest req) {
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/xml');
            
            String body = TagOrderStatusHelper.getSampleResponse();
            res.setBody(body);
            res.setStatusCode(200);
            return res;
        }
    }
}