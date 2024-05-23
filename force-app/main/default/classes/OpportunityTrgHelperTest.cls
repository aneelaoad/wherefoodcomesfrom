@isTest
public class OpportunityTrgHelperTest {
	
    @istest
    public static void testOppTrgHelper(){
         
        //Test Data Creation
        Account Acc = new Account(Name='test');
        insert Acc;
        
        Opportunity Opp = new Opportunity(CloseDate=date.today(), Name='test', stagename='new', accountId = Acc.id,  Stage_of_Work_Umbrella__c='pre-review', Stage_of_Work_Other__c='pre-review');
        insert Opp;
       
        Opp.Stage_of_Work_Umbrella__c='approval'; 
        Opp.Stage_of_Work_Other__c='approval';
        Opp.Expiration_Date_Umbrella__c = date.today();
         Opp.Expiration_Date_Other__c = date.today();
        update opp;
        
        
        Opportunity_Status_History__c OSH = new Opportunity_Status_History__c(Opportunity__c=Opp.id, status__c='Stage of Work Umbrella',Start_Date__c = System.Now(),Status_From__c='pre-review' );
        insert OSH;

        
        Opportunity_Status_History__c OSH1 = new Opportunity_Status_History__c(Opportunity__c=Opp.id, status__c='Stage of Work Other',Start_Date__c = System.Now(), Status_From__c='pre-review');
        insert OSH1;
        
        
        } 
   
}