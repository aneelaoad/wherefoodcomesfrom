@isTest
public class OrganicCertControllerTest {
	@TestSetup
    public static void testSetup(){
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
        
        Id certRecordType = Schema.SObjectType.Certificate__c.getRecordTypeInfosByName().get('Umbrella & Other').getRecordTypeId();
        Certificate__c cert = new Certificate__c();
        cert.AccountID__c = acc.id;
        cert.Opportunity_Name__c = opp.id;       
        cert.RecordTypeId =certRecordType;
        cert.IsUmbrellaOROtherJS__c =true;
        insert cert;
        
        Id certRecordType1 = Schema.SObjectType.Certificate__c.getRecordTypeInfosByName().get('A Bee Organic').getRecordTypeId();
        Certificate__c cert1 = new Certificate__c();
        cert1.AccountID__c = acc.id;
        cert1.Opportunity_Name__c = opp.id;       
        cert1.RecordTypeId =certRecordType1;
        cert1.IsUmbrellaOROtherJS__c =true;
        insert cert1;
        
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
    }
    @isTest public static void testmethod1(){            
        Test.startTest();
        Certificate__c cert = [SELECT ID FROM Certificate__c LIMIT 1];
        OrganicCertController.getCert(cert.id);        
        Test.stopTest();
    }
    @isTest public static void testmethod2(){
        Test.startTest();
        List<account_products__c> aps = [SELECT ID FROM account_products__c];
        List<String> s  = new List<String>();
        for (account_products__c a:aps){
            s.add(a.Id);
        }
        OrganicCertController.updateCertSelected(s);
        Test.stopTest();
    }
    
    @isTest public static void testmethod3(){
        Test.startTest();
        List<account_products__c> aps = [SELECT ID FROM account_products__c];
        List<String> s  = new List<String>();
        for (account_products__c a:aps){
            s.add(a.Id);
        }
        OrganicCertController.updateCertUnSelected(s);
        Test.stopTest();
    }
    
    @isTest public static void testmethod4(){            
        Test.startTest();
        List<Certificate__c> certs = [SELECT ID FROM Certificate__c];
        for(Certificate__c cert : certs){
            OrganicCertController.getDocumentId(cert.id); 
        }            
        Test.stopTest();
    }
     
}