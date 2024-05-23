@isTest
private class VR_test_class {

    static testmethod void test_trigger(){
        Verification_Report__c vr = new Verification_Report__c(Name = 'sha',Active_Record__c = 'No',Opportunity__c = '006360000097LpT');//beef

      //  acct.name = 'sha';
        insert vr;

        
    }
}