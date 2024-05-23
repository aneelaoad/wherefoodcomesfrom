@isTest
public class nonConformityTest {
    @isTest(seealldata=true)
    public static void testNonConformity(){
        
       /* Account a = new Account(name='test123456', Primary_Contact2__c = null);
        insert a;
                
        Opportunity opp = new Opportunity(
            Name = 'Test opp7',         // Opportunity Name
            Account = a,  // Account Name
            Probability = 100,           // Probability (%)
            StageName = 'New',
            Closedate = date.today(),
            recordtypeid = '01236000000FcrEAAS'
        );
        insert opp;*/
        
        Opportunity opp = [Select Id, CloseDate from Opportunity where closedate < :date.today() 
                           AND cvs_Assigned__c =null and Programs_Claims_Other__c = null and Programs_claims_umbrella__c = null 
                           and customer_type__c = null limit 1];
        
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
            ncIdentified2__c = '4',                                                      // ncIdentified2
            Send_NC_Due_Notice__c = true
        );
        insert report;
        
        List<Non_Conformity__c> nonCons = new List<Non_Conformity__c>();
        
        for(Integer i = 0; i<10; i++){
            Non_Conformity__c nonCon = new Non_Conformity__c(
                NC_Description__c = 'scription',
                NC_Clearance__c = 'No',
                NC_Identified_Standard_Number__c = '123',
                Verification_Report__c = report.id,
                Note__c = 'test'
            );
            
            nonCons.add(nonCon);
        }
       
        insert NonCons;
        
        report.ncIdentified2__c = '5';
        update report;
    }
}