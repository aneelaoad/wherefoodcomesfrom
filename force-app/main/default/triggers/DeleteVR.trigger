trigger DeleteVR on Verification_Report__c(after insert) {
    Set<Id> lstId = new Set<Id>();
    
    for(Verification_Report__c vr: Trigger.new){
        if(vr.Active_Record__c == 'No'){
            lstId.add(vr.id);
        }
   
        
    } 
    List<Verification_Report__c> existVRList = [Select Id from Verification_Report__c where ID in :lstId];
    delete existVRList;
    
}