public class TagOrderLineItemTriggerHandler {
    public static void fillInPrice(List<TagOrderLineItem__c> lines){
		Set<ID> productIds = new Set<ID>();
        for(TagOrderLineItem__c line : lines){
            productIds.add(line.Product__c);
        }
        
        Pricebook2 standardPricebook = [select id, name from Pricebook2 where isStandard = true limit 1];
        
        List<PricebookEntry> pbEntries = [Select Id, UnitPrice, Product2Id FROM PricebookEntry WHERE Product2Id IN :productIds
                                         AND isActive = true AND Pricebook2Id = :standardPricebook.Id];
        
        Map<ID, Decimal> productToPrice = new Map<ID, Decimal>();
        if(pbEntries.size()>0){
            for(PricebookEntry pe : pbEntries){
                productToPrice.put(pe.Product2Id, pe.UnitPrice);
            }
        }
        
        for(TagOrderLineItem__c tagline : lines){
            if(tagLine.Product__c != null){
                Decimal price = productToPrice.get(tagline.Product__c);
                if(price != null){
                    tagline.unit_price__c = price;
                }
            }
        }
    }
}