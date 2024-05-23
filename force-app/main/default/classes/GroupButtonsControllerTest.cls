@isTest
public class GroupButtonsControllerTest {
	@isTest
    public static void OpportunityButtonsConversionTestMethod(){
        
        Account acc = new Account(Name = 'test');
        Insert acc;
        
        Opportunity opp = new Opportunity();
        opp.Name = ' OppTest OppTest OppTest Opp Test OppTest OppTest OppTest OppTest OppTest OppTest Opp Test OppTest OppTest Opp';
        opp.CloseDate = Date.today();
        opp.StageName = 'New';
		opp.AccountId = acc.ID;
        opp.Programs_Claims_Other__c = '100% Vegetarian Fed;Source Verification;Age Verification';
        opp.Programs_Claims_GAP__c= 'GAP Collection Point';
        opp.Programs_Claims_Umbrella__c= '*Not eligible for 100% Vegetarian Fed claim';
        opp.Estimate_Ship_Date__c = Date.today();
		insert opp;        
        
        Group__c g = new Group__c();
        g.Source_of_Origin_ID__c = '12';
        g.Name = 'test test test test test test test test test test test test test test';
       	g.Opportunity__c = opp.Id;
        g.Programs_Claims__c = '100% Vegetarian Fed;Source Verification;Age Verification';
        insert g;
        
        Id NewShippingCertficateRecordTypeId = Schema.SObjectType.Certificate__c.getRecordTypeInfosByName().get('Umbrella & Other Shipping').getRecordTypeId();
        
        Certificate__c c = new Certificate__c();
        c.Name = 'test';
        c.Group__c = g.Id;
        c.Opportunity_Name__c = opp.id;
        c.IsUmbrellaOROtherJS__c = true;
        c.RecordTypeId = NewShippingCertficateRecordTypeId;
        insert c;
        
        ID recordId = g.ID;
        
        Test.startTest();

        GroupButtonsController.newShippingCertificate(recordId);
 		
        Test.stopTest();
    }
}