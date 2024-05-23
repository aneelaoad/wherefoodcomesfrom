@isTest
private class PB_test_class {

    static testmethod void test_trigger(){
        Certificate__c c = new Certificate__c(Name = 'sha',Opportunity_Name__c = '0063600000Qf6LG');//beef

      //  acct.name = 'sha';
        insert c;

        
    }
}