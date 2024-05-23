trigger TagOrderLineItemTrigger on TagOrderLineItem__c (before insert, before update) {
    if(Trigger.isBefore){
        TagOrderLineItemTriggerHandler.fillInPrice(Trigger.new);
    }
 }