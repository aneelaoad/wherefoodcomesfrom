/*
Created By: Muhammad Jawwad
Date: 1-Oct-2020

*/

@isTest
public class WFCFOrganicCertControllerTest {
    
    @isTest
    public Static void testMethod1(){
        
        
        
        Account acc = new Account();
        acc.Name='Test';
        insert acc;
        
        //Initialize Site Address and insert Site Address test data
        Site_Address__c sa = new Site_Address__c();
        sa.Account__c = acc.id;
        sa.Address__c = '4th Street';
        sa.City__c = 'Chicago';
        sa.State__c = 'CA';
        sa.Zip__c = '12838';
        sa.Country__c = 'USA';
        sa.is_Selected__c = true;
        insert sa;
        
        //Initialize Account Products and insert Account Products for crop test data
        account_products__c ap = new account_products__c();
        ap.Account__c = acc.Id;
        ap.Customer_Type__c = 'Crop';
        ap.ID_Mark__c ='N/A';
        ap.is_Selected__c=true;
        ap.Effective_Date__c= Date.today();
        ap.Product__c = 'Shiitake (raw and dried)';
        ap.Product_Status__c ='100% Organic';
        insert ap;     
        
     
        //Initialize Account Products and insert Account Products for Handler test data
        account_products__c ap1 = new account_products__c();
        ap1.Account__c = acc.Id;
        ap1.Customer_Type__c = 'Handler';
        ap1.ID_Mark__c ='N/A';
        ap1.is_Selected__c=true;
        ap1.Effective_Date__c= Date.today();
        ap1.Product__c = 'Shiitake (raw and dried)';
        ap1.Product_Status__c ='100% Organic';
        insert ap1;   
        
        //Initialize Account Products and insert Account Products for Livestock test data
        account_products__c ap2 = new account_products__c();
        ap2.Account__c = acc.Id;
        ap2.Customer_Type__c = 'Livestock';
        ap2.ID_Mark__c ='N/A';
        ap2.is_Selected__c=true;
        ap2.Effective_Date__c= Date.today();
        ap2.Product__c = 'Shiitake (raw and dried)';
        ap2.Product_Status__c ='100% Organic';
        insert ap2;

        account_products__c ap3 = new account_products__c();
        ap3.Account__c = acc.Id;
        ap3.Customer_Type__c = 'Wild Crop';
        ap3.ID_Mark__c ='N/A';
        ap3.is_Selected__c=true;
        ap3.Effective_Date__c= Date.today();
        ap3.Product__c = 'Shiitake (raw and dried)';
        ap3.Product_Status__c ='100% Organic';
        insert ap3;
        
        
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
        
        Id ABeeOrganicCertRecordTypeId = Schema.SObjectType.Certificate__c.getRecordTypeInfosByName().get('A Bee Organic').getRecordTypeId();
        //Initialize Certificate and insert Certificate test data
        Certificate__c cert = new Certificate__c();
        //cert.AccountID__c = acc.id;
        cert.Opportunity_Name__c = opp.id;
        cert.RecordTypeId = ABeeOrganicCertRecordTypeId;
        insert cert;
        
        Test.StartTest();
        TestABeeOrganicController(cert);
        
        Id WFCFOrganicCertRecordTypeId = Schema.SObjectType.Certificate__c.getRecordTypeInfosByName().get('WFCF Organic').getRecordTypeId();
        //Initialize Certificate and insert Certificate test data
        Certificate__c cert1 = new Certificate__c();
        //cert1.AccountID__c = acc.id;
        cert1.RecordTypeId = WFCFOrganicCertRecordTypeId;
        cert1.Opportunity_Name__c = opp.id;
        insert cert1;
        
        TestWFCFOController(cert1);
        
        Id ICSCertRecordTypeId = Schema.SObjectType.Certificate__c.getRecordTypeInfosByName().get('ICS').getRecordTypeId();
        //Initialize Certificate and insert Certificate test data
        Certificate__c cert2 = new Certificate__c();
        //cert1.AccountID__c = acc.id;
        cert2.RecordTypeId = ICSCertRecordTypeId;
        cert2.Opportunity_Name__c = opp.id;
        insert cert2;
        
        TestICSController(cert2);
        
        
        Test.stopTest();
    }
    
    
    public Static void TestABeeOrganicController(Certificate__c cert)
    {    
        PageReference pageRef = Page.WFCFOrganicCert;
        
        Test.setCurrentPage(PageRef);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(cert);
        
        pageRef.getParameters().put('id',String.valueOf(cert.Id));
        WFCFOrganicCertController WOC = new WFCFOrganicCertController(sc);
        WOC.processSelected();  
        WOC.next();
        WOC.prev();
        WOC.process();
        WOC.GetAccountProducts();
    }
    
    
    public Static void TestWFCFOController(Certificate__c cert)
    {
        PageReference pageRef = Page.WFCFOrganicCert;
        
        Test.setCurrentPage(PageRef);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(cert);
        
        pageRef.getParameters().put('id',String.valueOf(cert.Id));
        WFCFOrganicCertController WOC = new WFCFOrganicCertController(sc);
        WOC.processSelected();
        WOC.next();
        WOC.prev();
        WOC.process();


    }
    
     public Static void TestICSController(Certificate__c cert)
    {
        PageReference pageRef = Page.WFCFOrganicCert;
        
        Test.setCurrentPage(PageRef);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(cert);
        
        pageRef.getParameters().put('id',String.valueOf(cert.Id));
        WFCFOrganicCertController WOC = new WFCFOrganicCertController(sc);
        WOC.processSelected();
        WOC.pageNumber = 0;
        WOC.pageSize = 1;
        
        WOC.getPrv();
        WOC.getNxt();
        
        WOC.displayError('error');
       
        
        
        account_products__c ap1 = [SELECT Account__c , Customer_Type__c  , ID_Mark__c , is_Selected__c , Effective_Date__c , Product__c , Product_Status__c from account_products__c LIMIT 1];
        
        WFCFOrganicCertController.wrapAccountProduct asd = new WFCFOrganicCertController.wrapAccountProduct(ap1,true);
        WFCFOrganicCertController.wrapAccountProduct asd1 = new WFCFOrganicCertController.wrapAccountProduct(ap1);
        List<Account_Products__c> apList=[SELECT Account__c , Customer_Type__c  , ID_Mark__c , is_Selected__c , Effective_Date__c , Product__c , Product_Status__c from account_products__c LIMIT 2];
        WOC.process();
            
        

    }
}