trigger PotentialRevenueConvertIntoLeadTrigger on Lead (before Update) {
    // Check if the lead is being converted and Potential Revenue is null
    for (Lead leadRecord : Trigger.new) {
        if (leadRecord.IsConverted && leadRecord.Potential_Revenue__c == null) {
            // Add an error message if Potential Revenue is required
            leadRecord.addError('Potential Revenue is required when converting a lead.');
        }
    }
}