@isTest
public class OpportunityHelperTest {
    @istest
    public static void testOppHelper(){
        Account a = new Account(Name='test');
        insert a;
        Opportunity o = new Opportunity(CloseDate=date.today()+1, Name='test', stagename='new', accountId = a.id);
        insert o;
        ApexPages.StandardController sc = new ApexPages.StandardController(o);
        OpportunityHelper oh = new OpportunityHelper(sc);
        
        
        //  Covering the code changes in OpportunityBeforeInsertBeforeUpdate trigger 
        //  for Process Builder named "Opp - Pre Review and Approval Time Stamp" 
        
        
        Opportunity o1 = new Opportunity(CloseDate=date.today()+1, Name='test', 
                                         stagename='new', accountId = a.id,preReviewCheck__c ='No',Stage_of_Work_Umbrella__c = 'pre-review');
        insert o1;
        
         Case c = new Case(
          Opportunity__c = o1.Id
         );
         insert c;
        
        o1.preReviewCheck__c ='Yes';
        o1.Stage_of_Work_Umbrella__c = 'approval';
        update o1;
        
        o1.isCloneAmericanGrown__c = TRUE;
        update o1;
        
    }
}