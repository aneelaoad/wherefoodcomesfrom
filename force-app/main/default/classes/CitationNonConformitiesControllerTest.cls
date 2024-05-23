@isTest
public class CitationNonConformitiesControllerTest {
    
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
		
        insert vr;
        
        Citation__c c = new Citation__c();
        c.Name = '§205.100';
        c.Title__c='§205.100 What has to be certified.';
        c.Citation_Description__c='test';
        
        insert c;
        
        Id CitationRecordTypeId = Schema.SObjectType.Non_Conformity__c.getRecordTypeInfosByName().get('Citation (Non-Conformities)').getRecordTypeId();
        Non_Conformity__c nc = new Non_Conformity__c();
        nc.Verification_Report__c = vr.id;
        nc.RecordTypeId = CitationRecordTypeId;
        nc.Citation_Name_Picklist__c = '§205.100 What has to be certified.';
        nc.Citation__c = c.id;
        insert nc;
        
        
        Test.startTest();
        PageReference pageRef = Page.CitationNonConformities;
        
        Test.setCurrentPage(PageRef);
        
       
        
        ApexPages.StandardController sc = new ApexPages.StandardController(vr);
        
        pageRef.getParameters().put('id',String.valueOf(vr.Id));
        CitationNonConformitiesController CNCC = new CitationNonConformitiesController(sc);
      
        
        CNCC.getOptions();
        CNCC.selectedOption =c.ID;
        CNCC.description();
        CNCC.saveNonConformity();  
        Test.stopTest();
    }

}