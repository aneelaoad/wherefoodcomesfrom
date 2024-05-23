public class OpportunityHelper {
    private final Opportunity opp;
    public list<Contact> contacts {get;set;}
    
    // The extension constructor initializes the private member
    // variable acct by using the getRecord method from the standard
    // controller.
    public OpportunityHelper(ApexPages.StandardController stdController) {
        opp = (Opportunity)stdController.getRecord();
        List<Opportunity> opps = [Select Id, AccountId FROM Opportunity WHERE ID = :opp.id];
        contacts = [Select Id, FirstName, LastName, Title, Phone, MobilePhone, Email, Primary_Contact__c FROM Contact WHERE AccountId = :opps[0].AccountId];
    }
}