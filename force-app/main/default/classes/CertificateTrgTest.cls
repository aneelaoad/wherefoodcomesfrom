@isTest
public class CertificateTrgTest {
   static testMethod  void CertificateTrgs() {
       
     String AmericanGrownAccountRecordTypeID = [SELECT Id from RecordType WHERE sObjectType='Account' 
                                        AND Name = 'American Grown'].Id;
     String AmericanGrownoppOpportunityRecordTypeID = [SELECT Id from RecordType WHERE sObjectType='Opportunity' 
                                        AND Name = 'American Grown'].Id;
     String AmericanGrownCertificateRecordTypeID = [SELECT Id from RecordType WHERE sObjectType='Certificate__c' 
                                        AND Name = 'American Grown'].Id;
     
     
     Account acct = new Account(Name='Test Account',
                               RecordTypeId = AmericanGrownAccountRecordTypeID);     
     insert acct;
      
     Opportunity opp = new Opportunity(Name=acct.Name + ' Opportunity',
                                       StageName='Prospecting',
                                       CloseDate=System.today().addMonths(1),
                                       AccountId=acct.Id,
                                       RecordTypeId = AmericanGrownoppOpportunityRecordTypeID);
     insert opp;
       
       List<Feeder_Farm__c> ListofFeederFarm = new  list<Feeder_Farm__c>();
       integer i =1;
       for(i=1 ; i<=40 ; i++){
           ListofFeederFarm.add(
           
               new Feeder_Farm__c(Name='Test Feeder Farm' +i,
                                             Physical_Address__c='Test Address',
                                             Other_Species__c='Sheep, Goat', 
                                             Account__c=acct.Id)
           );
       }
       insert ListofFeederFarm;
       
       Certificate__c cert = new Certificate__c(Name='Test Feeder Farm', 
                                                Opportunity_Name__c = opp.Id,
                                               RecordTypeId = AmericanGrownCertificateRecordTypeID); 
      insert cert;
      

  }
}