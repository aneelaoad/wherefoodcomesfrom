@isTest
public class TagOrderLineItemTriggerHandlerTest {
	@isTest(seealldata=true)
    public static void testTOLTH(){
        Product2 prod = new Product2(Name = 'GreenTag', 
            Family = 'tags');
        insert prod;
        
        // Get standard price book ID.
        // This is available irrespective of the state of SeeAllData.
        Id pricebookId = Test.getStandardPricebookId();
        
        // 1. Insert a price book entry for the standard price book.
        // Standard price book entries require the standard price book ID we got earlier.
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = prod.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        // Create a custom price book
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        // 2. Insert a price book entry with a custom price.
        PricebookEntry customPrice = new PricebookEntry(
            Pricebook2Id = customPB.Id, Product2Id = prod.Id,
            UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
        
        Opportunity o = [select id from Opportunity limit 1];
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
            Product__c = prod.id,   // Product
            Quantity__c = 1000,              // Unit Price
            TagOrder__c = tagorder.Id  // Tag Order
        );
        insert line;
    }
}