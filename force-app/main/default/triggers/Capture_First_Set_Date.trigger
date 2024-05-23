trigger Capture_First_Set_Date on Opportunity (before update) {
    for (Opportunity record : Trigger.new) {
        if (record.ReviewerIfNotCVS_Users__c != null && Trigger.oldMap.get(record.Id).ReviewerIfNotCVS_Users__c == null) {
            record.Reviewer_First_Set_Date__c = System.Today();
        }
    }
}