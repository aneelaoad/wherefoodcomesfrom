@isTest
public class VerificationReportUpdateTest {
	@isTest(seealldata=true)
    public static void testVRU(){
        VerificationReportUpdateScheduler vrs = new VerificationReportUpdateScheduler();
        String schedule = '0 11 15 * * ?';  //Seconds Minutes Hours Day_of_month Month Day_of_week Optional_year
        String jobID = system.schedule('Verification Report Update Job', schedule, vrs);        
    }
    
    @isTest
    public static void testVRUBatch(){
        Account a = new Account(name='test123456', Primary_Contact2__c = null);
        insert a;
                
        Opportunity opp = new Opportunity(
            Name = 'Test opp7',         // Opportunity Name
            AccountId = a.Id,  // Account Name
            Probability = 100,           // Probability (%)
            StageName = 'New',
            Closedate = date.today(),
            recordtypeid = '01236000000FcrEAAS'
        );
        insert opp;
        
        Verification_Report__c report = new Verification_Report__c(
            Name = 'CS Beef VR',                                                       // Verification Report Name
            Species_GAP__c = 'Beef',                                                     // Species
            Operation_Type_Other__c = 'Other',                                           // Operation Type Other
            Corrective_Action_Required__c = 'Yes',                                       // Corrective Action Required
            Corrective_Action_Required_by__c = Date.today() + 7,               // Corrective Action Required by
            Opportunity__c = opp.id,                                          // Opportunity
            X1_Ranch_farm_Plan_Documentation_Beef__c = 'Pending Corrective Actions',     // 1 - Ranch/Farm Plan & Documentation
            X6_Feed_Water_Beef__c = 'Pending Corrective Actions',                        // 6 - Feed & Water
            X2_Breeding_Source_of_Animals_Beef__c = 'Pending Corrective Actions',        // 2 - Breeding & Source of Animals
            X7_Range_Pasture_Outdoor_Requiremen_Beef__c = 'Pending Corrective Actions',  // 7 - Range/Pasture & Outdoor Requirements
            X3_Animal_Health_Beef__c = 'Pending Corrective Actions',                     // 3 - Animal Health
            X8_Housing_Conditions_Beef__c = 'Pending Corrective Actions',                // 8 - Housing Conditions
            X4_Animal_Handling_Beef__c = 'Pending Corrective Actions',                   // 4 - Animal Handling
            X9_Insect_Rodent_Predator_Control_Beef__c = 'Pending Corrective Actions',    // 9 - Insect, Rodent & Predator Control
            X5_Animal_Management_Beef__c = 'Pending Corrective Actions',                 // 5 - Animal Management
            X10_Movement_Transport_of_Animals_Beef__c = 'Pending Corrective Actions',    // 10 - Movement & Transport of Animals
            ncDescription1__c = 'test',                                                  // ncDescription1
            ncDescription2__c = 'scription',                                             // ncDescription2
            ncIdentified2__c = '4'                                                      // ncIdentified2
        );
        insert report;
        List<ID> vrIds = new List<ID>();
       
       //Get all reports
       List<Verification_Report__c> verificationReports = [Select Id FROM Verification_Report__c];
       
       //Add the report ids to the list of ids
       for(Verification_Report__c vReport: verificationReports){
           vrIds.add(vReport.id);
       }
       VerificationReportUpdateBatch vr = new VerificationReportUpdateBatch(vrIds);
       Id batchJobId = Database.executeBatch(vr, 1);
        VerificationReportCheckMissingBatch vr2 = new VerificationReportCheckMissingBatch(vrIds);
       Id batchJobId2 = Database.executeBatch(vr2, 1);
        
    }
}