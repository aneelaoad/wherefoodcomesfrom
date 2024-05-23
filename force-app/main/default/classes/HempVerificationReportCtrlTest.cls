@isTest
public class HempVerificationReportCtrlTest {

    public static Account acc;
    public static Verification_Report__c vr;
    
    public static void initializeTestEnvironment()
    {        
        acc = new Account();
        acc.Name = 'test123123123';
        insert acc;        
       
        Contact cont = new Contact();
        cont.LastName = 'testContact';
        cont.AccountId = acc.Id;
        insert cont;
        
        acc.Primary_Contact2__c = cont.Id;
        update acc;
        
        Opportunity opty = new Opportunity();
        opty.AccountId = acc.Id;
        opty.Name = 'test';
        opty.StageName = 'New';
        opty.CloseDate = Date.today();
        opty.Opportunity_Status__c = 'New';
        opty.Programs_Claims_Umbrella__c = 'Prime Pursuits';
        opty.Release_Form_on_File__c = 'Yes';
        insert opty;    
        
        Certificate__c cert = new Certificate__c();
        cert.Name = 'tttt';
        cert.Opportunity_Name__c = opty.Id;
        insert cert;
        
        vr = new Verification_Report__c();
        vr.Opportunity__c = opty.Id;
        //vr.RecordTypeId = Schema.SObjectType.Verification_Report__c.getRecordTypeInforsByName().get('U.S. Hemp Authority Verification Report').getRecordTypeId();
        insert vr;       

        Non_Conformity__c conformity = new Non_Conformity__c();
        conformity.Verification_Report__c = vr.Id;
        insert conformity;
    }
    
    public static testmethod void testNonConformity()
    {
        initializeTestEnvironment();
        
        test.startTest();
        
        ApexPages.currentPage().getParameters().put('id', vr.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(vr);
        
        HempVerificationReportCtrl ctrl = new HempVerificationReportCtrl(sc);
        ctrl.getNonConformities();
        string  addresses  = ctrl.ReportAddress1to4;
        string bg= ctrl.background;
        test.stopTest();
    }
    
}