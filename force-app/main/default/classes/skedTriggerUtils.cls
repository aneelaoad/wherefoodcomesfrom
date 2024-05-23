public class skedTriggerUtils { 
    
    /*
    * Update Job Allocation's status from 'Pending Dispatch' to 'Dispatched' if the JA is assigned to a resource
    * and Job's Start time is empty
    */
    public static void dispatchJobs(list<sked__Job_Allocation__c> jaList){
        Set<Id> jobIDs = new Set<Id>();
        for(sked__Job_Allocation__c ja : jaList){
            jobIDs.add(ja.sked__Job__c);
        }
        Map<Id, sked__Job__c> jobMap = new Map<Id, sked__Job__c>([Select Id from sked__Job__c where Id IN :jobIDs and sked__Start__c = null]);
        for(sked__Job_Allocation__c ja : jaList){            
            if(ja.sked__Status__c=='Pending Dispatch' && ja.sked__Resource__c!=null && jobMap.containsKey(ja.sked__Job__c)){
                ja.sked__Status__c	= 'Dispatched';                
                skedDispatchServices.notifyResource(ja.sked__Job__c, ja.sked__resource__c);
            }
        }
    }
    
    /*
    * Get Ids of the cases with fieldName updated 
    */
	public static Set<Id> getObjectIDs_FieldChanged(Map<Id,sObject> oldMap, list<sObject> newRecs, String fieldName, boolean isNewValNotNull){
        sObject oldRec;
        Set<Id> objectIDs = new Set<Id>();
        //Find cases with type of training changed
        for(sObject newRec : newRecs){
            oldRec = oldMap.get( newRec.Id );
			if( isNewValNotNull==true &&  newRec.get(fieldName)==null) continue;
            if( newRec.get(fieldName) != oldRec.get(fieldName) ){
                objectIDs.add( newRec.Id );
            }
        }
        return objectIDs;
    }
}