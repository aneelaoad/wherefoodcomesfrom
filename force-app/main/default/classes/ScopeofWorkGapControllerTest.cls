/*
Author: Aamir Maqsood
Created Date: 12/11/2019 
Description:

    This test class is used to cover ScopeofWorkGapController

*/
@isTest
private with sharing class ScopeofWorkGapControllerTest
{
    /*-----------------VARIABLES---------------------*/
    private static ApexPages.StandardController controller;
    
    /*-----------------TEST METHODS---------------------*/
    static testMethod void ScopeofWorkGapControllerTest() 
    {
  
  
           String AccountRecordTypeID =     [ SELECT Id from RecordType WHERE sObjectType='Account' 
                                              AND Name = 'IMI Global'].Id;
           String OpportunityRecordTypeID = [SELECT Id from RecordType WHERE sObjectType='Opportunity' 
                                             AND Name = 'Verification/Certification'].Id;
                                        
           Account acct = new Account(Name='Test Account',RecordTypeId = AccountRecordTypeID );     
           insert acct;
      
           Opportunity opp = new Opportunity(Name=acct.Name + ' Opportunity',
                                             StageName='New',
                                             CloseDate=System.today().addMonths(1),
                                             AccountId=acct.Id,
                                             RecordTypeId = OpportunityRecordTypeID);
                                       
                                           
           insert opp; 
           
           ScopeofWorkGAP__c sowGAP = new ScopeofWorkGAP__c();
           sowGAP.Name = 'ScopeofWorkGAP';
           sowGAP.ScopeofWorkGAP_HiddenFromDate__c = Date.valueOF('2019-12-1');
           insert sowGAP;

        Test.StartTest();
        
        controller = new ApexPages.StandardController(opp);  
        ApexPages.currentPage().getParameters().put('id', opp.Id);
        ScopeofWorkGapController oppC = new ScopeofWorkGapController(controller);
        oppC.editPage();
        oppC.savePage();
        oppC.editPage();
        oppC.cancelPage();
        
        Test.StopTest();
        
        System.assertEquals(oppC.opp.StageName=='New', true);
    }
}