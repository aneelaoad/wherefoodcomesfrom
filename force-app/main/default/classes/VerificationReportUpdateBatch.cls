global class VerificationReportUpdateBatch implements Database.Batchable<ID> {
    private List<ID> reportsToUpdate;
    
    public VerificationReportUpdateBatch(List<ID> reportIds){
        reportsToUpdate = reportIds;
    }
    //Create the whole list of verification report ids that need to be updated
    global Iterable<ID> start(Database.BatchableContext info){ 
        
        /*List<ID> reportsToUpdate = new List<ID>();
        
        //Get all reports
     	List<Verification_Report__c> verificationReports = [Select Id FROM Verification_Report__c];
        
        //Add the report ids to the list of ids
        for(Verification_Report__c vReport: verificationReports){
            reportsToUpdate.add(vReport.id);
        }*/
        
        return reportsToUpdate;
    }     
    
    //Fire the code to be executed in batches according to size that was passed to it
    global void execute(Database.BatchableContext info, List<ID> scope){
      
        //try {
            //Get all reports from this given batch
            List<Verification_Report__c> verificationReports = [Select Id, ncTimestamp__c FROM Verification_Report__c WHERE ID IN :scope];
            //Update the reports
            for(Verification_Report__c vr : verificationReports){
                vr.ncTimeStamp__c = date.today();
            }
            update verificationReports;
            
        /*} catch (exception e){
            system.debug('*** Verification Report Update Batch Exception: ' + e.getMessage() + ' Line: ' + e.getLineNumber());
        }*/

    }
    
    global void finish(Database.BatchableContext info){     
        // Look at any reports that didn't update and redo the batch one at a time to narrow down which ones were erroring out.
        List<ID> vrIds = new List<ID>();
       
       //Get all reports
       List<Verification_Report__c> verificationReports = [Select Id FROM Verification_Report__c 
                                                          WHERE (ncTimestamp__c = null OR ncTimestamp__c < today)];
       
       //Add the report ids to the list of ids
       for(Verification_Report__c vReport: verificationReports){
           vrIds.add(vReport.id);
       }
        
        if(vrIds.size() > 0){
            VerificationReportCheckMissingBatch vr = new VerificationReportCheckMissingBatch(vrIds);
                Id batchJobId = Database.executeBatch(vr, 1);
        }
       
       
    } 
    
}