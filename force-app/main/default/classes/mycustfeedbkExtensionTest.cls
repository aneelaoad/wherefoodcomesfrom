@isTest
public class mycustfeedbkExtensionTest {
    @isTest
    public static void testmycustfeedbk() {
        Account a = new Account(Name='Test Account');
        insert a;
        
        PageReference pr = Page.CustomerFeedback;
        pr.getParameters().put('id', a.id);
        Test.setCurrentPageReference(pr);
        ApexPages.StandardController sc = new ApexPages.StandardController(a);
        mycustfeedbkExtension fe = new mycustfeedbkExtension(sc);
 		fe.doInsert();
    }
    
    @isTest
    public static void testmycustfeedbk2() {
        Account a = new Account(Name='Test Account');
        insert a;
        
        PageReference pr = Page.CustomerFeedback2;
        //pr.getParameters().put('id', a.id);
        Test.setCurrentPageReference(pr);
        ApexPages.StandardController sc = new ApexPages.StandardController(a);
        mycustfeedbkExtension2 fe = new mycustfeedbkExtension2(sc);
        fe.AccountInput = 'Test Account';
        fe.doInsert();
    }
}