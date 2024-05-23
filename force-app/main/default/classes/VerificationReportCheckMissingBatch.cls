global class VerificationReportCheckMissingBatch implements Database.Batchable<ID> {
    private List<ID> reportsToUpdate;
    
    public VerificationReportCheckMissingBatch(List<ID> reportIds){
        reportsToUpdate = reportIds;
    }
    //Create the whole list of verification report ids that need to be updated
    global Iterable<ID> start(Database.BatchableContext info){ 
                
        return reportsToUpdate;
    }     
    
    //Fire the code to be executed in batches according to size that was passed to it
    global void execute(Database.BatchableContext info, List<ID> scope){
             
            //Get all reports from this given batch
            List<Verification_Report__c> verificationReports = [Select Id, ncTimestamp__c FROM Verification_Report__c WHERE ID IN :scope];
            //Update the reports
            for(Verification_Report__c vr : verificationReports){
                vr.ncTimeStamp__c = date.today();
            }
            update verificationReports;
            

    }
    
    global void finish(Database.BatchableContext info){ 
        
    }
        
}