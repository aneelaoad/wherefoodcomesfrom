@istest
public class OpportunityButtonsConversionTest {
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
		opp.CVS_Assigned_Users__c = 'Sameer Afsar';
		insert opp;        
        
        Group__c g1 = new Group__c(Name = 'Group1',Opportunity__c = opp.id);
       
        insert g1;
        
        Group__c g2 = new Group__c(Name = 'Group1',Opportunity__c = opp.id);
       
        insert g2;
        
        Group__c g3 = new Group__c(Name = 'Group1',Opportunity__c = opp.id);
       
        insert g3;
        
        ID recordId = opp.ID;
        
        Test.startTest();

        OpportunityButtonsConversion.cloneAmericanGrown(recordId);
        OpportunityButtonsConversion.cloneOpportunityJS(recordId);
        OpportunityButtonsConversion.cloneOrganicOpportunity(recordId);
        OpportunityButtonsConversion.createTagOrder(recordId);
        OpportunityButtonsConversion.newGroup(recordId);
        OpportunityButtonsConversion.newOtherCertficate(recordId);
        OpportunityButtonsConversion.newUmberellaCertficate(recordId);
        OpportunityButtonsConversion.notifyCVSFileUpload(recordId);
 		
        Test.stopTest();
    }
}