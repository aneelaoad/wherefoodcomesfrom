trigger skedJobAllocationTrigger on sked__Job_Allocation__c (before insert) {

    if(Trigger.isBefore){
        if(Trigger.isInsert){
            skedTriggerUtils.dispatchJobs(Trigger.new);
        }
    }
}