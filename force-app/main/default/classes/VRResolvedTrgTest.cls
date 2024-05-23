/*
 Created By : Muhammad Jawwad
 Date: 27-October-2020
 Purpose: Cover Custom Field validation Trigger 'VRResolvedTrg' and UpdateTextFieldBasedOnMPHelper test
*/
@isTest
public class VRResolvedTrgTest {

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
        
		Verification_Report__c vr = new Verification_Report__c();
        
        vr.Name = 'Test Major NC';
        vr.Opportunity__c = opp.id;
		vr.Resolved__c = 'Yes';
        vr.Supporting_Documentation__c = 'Inspection Report Text;Sampling Results';
        insert vr;
        

        
        Id CitationRecordTypeId = Schema.SObjectType.Non_Conformity__c.getRecordTypeInfosByName().get('Citation (Non-Conformities)').getRecordTypeId();
        Non_Conformity__c nc = new Non_Conformity__c();
        nc.Verification_Report__c = vr.id;
        nc.RecordTypeId = CitationRecordTypeId;
        nc.Resolved__c = 'No';
        insert nc;
        
    }
}