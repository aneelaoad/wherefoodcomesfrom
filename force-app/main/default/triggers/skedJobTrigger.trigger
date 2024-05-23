trigger skedJobTrigger on sked__Job__c (before insert, before update, before delete, after insert, after update, after delete) {

    if(skedJobTriggerHandler.bypassJobTrigger == true) return;

    if(Trigger.isBefore){
        if ( trigger.isInsert ) {
            skedJobTriggerHandler.onBeforeInsert();
        }
        if(Trigger.isUpdate) {
            Set<Id> jobIDs_RescheduleDateChanged = skedTriggerUtils.getObjectIDs_FieldChanged(Trigger.oldMap, Trigger.new, 'Reschedule_Date__c', true);
            Set<Id> jobIDs_RescheduleTimeChanged = skedTriggerUtils.getObjectIDs_FieldChanged(Trigger.oldMap, Trigger.new, 'Reschedule_Duration_Mins__c', true);
            For(sked__Job__c job : Trigger.new){
                if(jobIDs_RescheduleDateChanged.contains(job.Id) && job.Reschedule_Date__c!=null){
                    job.sked__Start__c		= job.Reschedule_Date__c;
                    job.sked__Finish__c		= job.sked__Start__c.addMinutes(Integer.valueOf(job.sked__Duration__c));
                }
                if(jobIDs_RescheduleTimeChanged.contains(job.Id) && job.Reschedule_Duration_Mins__c!=null){
                    job.sked__Duration__c	= job.Reschedule_Duration_Mins__c;
                    job.sked__Finish__c		= job.sked__Start__c.addMinutes(Integer.valueOf(job.Reschedule_Duration_Mins__c));
                }
            }
            skedJobTriggerHandler.onBeforeUpdate();
        }                         
    }else{
        if(Trigger.isInsert){
            skedJobTriggerHandler.onAfterInsert(Trigger.old, Trigger.newMap);
        }else if(Trigger.isUpdate){
            skedJobTriggerHandler.onAfterUpdate(Trigger.old, Trigger.newMap);
        }
    }
}