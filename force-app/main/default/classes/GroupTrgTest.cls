/*
Author: Aamir Maqsood
Date Created: 12/11/2019
Purpose: Test class to cover the GroupTrg
*/

@isTest
public class GroupTrgTest {
   static testMethod  void CertificateTrgs() {
     
     Id AccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IMI Global').getRecordTypeId();
     Id OpportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Verification/Certification').getRecordTypeId();
     Id CertificateRecordTypeId = Schema.SObjectType.Certificate__c.getRecordTypeInfosByName().get('Umbrella & Other Shipping').getRecordTypeId();

     Account acct = new Account(Name='Test Account',  RecordTypeId = AccountRecordTypeId );     
     insert acct;
      
     Opportunity opp = new Opportunity(Name=acct.Name + ' Opportunity',
                                       StageName='New',
                                       CloseDate=System.today().addMonths(1),
                                       AccountId=acct.Id,
                                       RecordTypeId = OpportunityRecordTypeId );
     insert opp;
       
     Group__c g = new Group__c(Name='Test Group',Programs_Claims__c = 'GAP Step 1;GAP Step 2', Opportunity__c = opp.Id);
     insert g;
     
     Certificate__c c = new Certificate__c(Name='Test Certificate',
                                           Group__c = g.Id,
                                           Opportunity_Name__c = opp.Id,
                                           RecordTypeId = CertificateRecordTypeId,
                                           IsUmbrellaOROtherJS__c = True 
                                        );
     
     insert c;  
     
     Test.StartTest();
     
     g.Programs_Claims__c = 'GAP Step 1';
     update g;
     
     g.Programs_Claims__c = null;
     update g;
     
     Test.StopTest();
      

  }
}