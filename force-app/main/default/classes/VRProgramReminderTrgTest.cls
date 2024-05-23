/*
 Created By : Muhammad Jawwad
 Date: 04-August-2022
 Purpose: Cover Custom Field validation Trigger '' and UpdateTextFieldBasedOnMPHelper test
*/
@isTest
public class VRProgramReminderTrgTest {
    @isTest
    public Static void testMethod1(){
        
         //Initialize Account and insert Account test data
        Account acc = new Account();
        acc.Name='Test';
        insert acc;
        
        Id WFCFOrganicOppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('WFCF Organic').getRecordTypeId();
        //Initialize Opportunity and insert Opportunity test data
        Opportunity opp = new Opportunity();
        opp.Name='Test WFCF Organic';
        opp.StageName='New';
        opp.CloseDate=Date.today();
        opp.AccountId = acc.Id;
        opp.Customer_Type__c='Crop;Livestock;Handler';
        opp.RecordTypeId = WFCFOrganicOppRecordTypeId;
        insert opp;
        
		Verification_Report__c vr1 = new Verification_Report__c();
        
        vr1.Name = 'Test Major NC';
        vr1.Opportunity__c = opp.id;
		vr1.Program_Reminders__c = 'Ranch';
        insert vr1;
        
        Verification_Report__c vr2 = new Verification_Report__c();
        
        vr2.Name = 'Test Major NC';
        vr2.Opportunity__c = opp.id;
		vr2.Program_Reminders__c = 'Salesbarn';
        insert vr2;
        
        Verification_Report__c vr3 = new Verification_Report__c();
        
        vr3.Name = 'Test Major NC';
        vr3.Opportunity__c = opp.id;
		vr3.Program_Reminders__c = 'Feedlot';
        insert vr3;
        
        vr3.Program_Reminders__c = 'Ranch - BeefCARE SAV';
        update vr3;
        
        Verification_Report__c vr4 = new Verification_Report__c();
        
        vr4.Name = 'Test Major NC';
        vr4.Opportunity__c = opp.id;
		vr4.Program_Reminders__c = 'Backgrounder';
        insert vr4;
        
	 	Verification_Report__c vr5 = new Verification_Report__c();
        vr5.Id = vr1.id;
        vr5.Program_Reminders__c = 'Backgrounder';
        update vr5;
      
        
        Verification_Report__c vr6 = new Verification_Report__c();
        
        vr6.Name = 'Test Major NC';
        vr6.Opportunity__c = opp.id;
		vr6.Program_Reminders__c = 'Ranch - BeefCARE SAV';
        insert vr6;
        

        
    }
}