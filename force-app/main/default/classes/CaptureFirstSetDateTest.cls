@isTest
private class CaptureFirstSetDateTest {
    static testMethod void testFirstSetDateCaptured() {
        // Create an Opportunity with no Reviewer First Set Date
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opportunity';
        opp.StageName = 'Prospecting';
        opp.CloseDate = Date.today() + 30;
        insert opp;
        
        // Update the Opportunity with a Reviewer who is not a CVS user
        opp.ReviewerIfNotCVS_Users__c = 'Kathryn Britton';
        update opp;
        
        // Verify that the Reviewer First Set Date was captured
        Opportunity updatedOpp = [SELECT Reviewer_First_Set_Date__c FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals(System.Today(), updatedOpp.Reviewer_First_Set_Date__c);
    }
    
    static testMethod void testFirstSetDateNotCaptured() {
        // Create an Opportunity with a Reviewer First Set Date already set
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opportunity';
        opp.StageName = 'Prospecting';
        opp.CloseDate = Date.today() + 30;
        opp.Reviewer_First_Set_Date__c = System.Today();
        insert opp;
        
        // Update the Opportunity with a Reviewer who is not a CVS user
        opp.ReviewerIfNotCVS_Users__c = 'Kathryn Britton';
        update opp;
        
        // Verify that the Reviewer First Set Date was not updated
        Opportunity updatedOpp = [SELECT Reviewer_First_Set_Date__c FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals(System.Today(), updatedOpp.Reviewer_First_Set_Date__c);
    }
    
    static testMethod void testFirstSetDateNotCapturedOnCVSUser() {
        // Create an Opportunity with no Reviewer First Set Date
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opportunity';
        opp.StageName = 'Prospecting';
        opp.CloseDate = Date.today() + 30;
        insert opp;
        
        // Update the Opportunity with a Reviewer who is a CVS user
        opp.ReviewerIfNotCVS_Users__c = 'Kathryn Britton';
        update opp;
        
        // Verify that the Reviewer First Set Date was not captured
        Opportunity updatedOpp = [SELECT Reviewer_First_Set_Date__c FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals(System.Today(), updatedOpp.Reviewer_First_Set_Date__c);
    }
}