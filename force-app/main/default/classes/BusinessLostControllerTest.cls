@istest
public class BusinessLostControllerTest {

       
    @istest
    public static void testBusinessLost()
    {
        //opp 1
        Opportunity testOpp = new Opportunity(Name='test', stageName='New', CloseDate = Date.Today());
        
        testOpp.Business_Lost_Reason__c = 'Lost Buyer';
        testOpp.Opportunity_Status__c = 'Delisted - business lost';
        testOpp.Send_Exit_Interview_Form__c = False;
        
        insert testOpp;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(testOpp);
        BusinessLostController  obj = new BusinessLostController(sc);
        
        obj.currentRecordId = testOpp.Id;
        obj.getBusinessLostReasonPickListValues();
        obj.updateOpp();
        obj.setOther();
        obj.setAll();
        
        //opp 2
        Opportunity testOpp2 = new Opportunity(Name='test', stageName='New', CloseDate = Date.Today());
        
        testOpp2.Business_Lost_Reason__c = 'Other';
        testOpp2.Opportunity_Status__c = 'Delisted - business lost';
        testOpp2.Send_Exit_Interview_Form__c = True;
        
        insert testOpp2;
        
        sc = new ApexPages.StandardController(testOpp2);
        obj = new BusinessLostController(sc);
        
        obj.currentRecordId = testOpp.Id;
        obj.getBusinessLostReasonPickListValues();
        obj.updateOpp();
        obj.setOther();
        obj.setAll();
       
    }
}