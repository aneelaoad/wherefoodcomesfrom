global class VerificationReportUpdateScheduler implements Schedulable {
   global void execute(SchedulableContext SC) {  
       //All code that should fire goes here
       List<ID> vrIds = new List<ID>();
       
       //Get all reports
       List<Verification_Report__c> verificationReports = [Select Id FROM Verification_Report__c];
       
       //Add the report ids to the list of ids
       for(Verification_Report__c vReport: verificationReports){
           vrIds.add(vReport.id);
       }
       VerificationReportUpdateBatch vr = new VerificationReportUpdateBatch(vrIds);
       Id batchJobId = Database.executeBatch(vr, 20);
   }
    
/**********************
 * Run this in Execute Anon Window to start scheduled Apex Class or Add schedule through Setup > Apex Classes: 
 	VerificationReportUpdateScheduler vrs = new VerificationReportUpdateScheduler();
    String schedule = '0 0 0 * * ?';  //Seconds Minutes Hours Day_of_month Month Day_of_week Optional_year
    String jobID = system.schedule('Verification Report Update Job', schedule, vrs);
*******************/
}