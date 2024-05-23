public class skedJobTriggerHandler {

    public static boolean bypassJobTrigger  = false;

    public static void onBeforeInsert() {
        for ( sked__Job__c job : (List<sked__Job__c>)trigger.new ) {
            if ( job.GAP_Programs_and_Claims__c != NULL ) {
                job.GAP_Programs_and_Claims_Text__c = job.GAP_Programs_and_Claims__c;
            }
            if ( job.Other_Programs_and__c != NULL ) {
                job.Other_Programs_and_Claims_Text__c = job.Other_Programs_and__c;
            }
            if ( job.Umbrella_Programs_and_Claims__c != NULL ) {
                job.Umbrella_Programs_and_Claims_Text__c = job.Umbrella_Programs_and_Claims__c;
            }
        }
    }
    
    public static void onBeforeUpdate() {
        List<sked__Job__c> newJobs = (List<sked__Job__c>)trigger.new;
        Map<Id, sked__Job__c> mapOldJobs = (Map<Id, sked__Job__c>)trigger.oldMap;        
        for ( sked__Job__c newJob : newJobs ) {
            sked__Job__c oldJob = mapOldJobs.get(newJob.Id);
            if ( newJob.GAP_Programs_and_Claims__c != oldJob.GAP_Programs_and_Claims__c && newJob.GAP_Programs_and_Claims__c != NULL ) {
                newJob.GAP_Programs_and_Claims_Text__c = newJob.GAP_Programs_and_Claims__c;
            }
            if ( newJob.Other_Programs_and__c != oldJob.Other_Programs_and__c && newJob.Other_Programs_and__c != NULL ) {
                newJob.Other_Programs_and_Claims_Text__c = newJob.Other_Programs_and__c;
            }
            if ( newJob.Umbrella_Programs_and_Claims__c != oldJob.Umbrella_Programs_and_Claims__c && newJob.Umbrella_Programs_and_Claims__c != NULL ) {
                newJob.Umbrella_Programs_and_Claims_Text__c = newJob.Umbrella_Programs_and_Claims__c;
            }
        }
    }

    /*
    *
    */
    public static void onAfterInsert(list<sked__Job__c> oldList, Map<Id,sked__Job__c> newMap) {
        //skedLocationServices.updateLocationGeocode(oldList, newMap, skedLocationServices.OBJ_JOB); //Do not need to calculate Geolocation for jobs because it can be retrieved from the Account
    }

    /*
    *
    */
    public static void onAfterUpdate(list<sked__Job__c> oldList, Map<Id,sked__Job__c> newMap) {
        //skedLocationServices.updateLocationGeocode(oldList, newMap, skedLocationServices.OBJ_JOB);
    }
}