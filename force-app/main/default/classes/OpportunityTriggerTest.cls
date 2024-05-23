@istest
public class OpportunityTriggerTest {
@istest
    public static void OpportunityTriggerTestMethod(){
        
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
        Update opp; 
        
        
       
    }

}