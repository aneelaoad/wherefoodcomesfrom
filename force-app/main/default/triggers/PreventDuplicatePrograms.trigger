trigger PreventDuplicatePrograms on Lead (before insert, before update, after delete) {
    Set<String> uniqueValues = new Set<String>();

    for (Lead newLead : Trigger.new) {
        if (newLead.Potential_Programs_Claims__c != null) {
            List<String> values = newLead.Potential_Programs_Claims__c.split(';');
            List<String> deduplicatedValues = new List<String>();

            for (String value : values) {
                if (!uniqueValues.contains(value)) {
                    deduplicatedValues.add(value);
                    uniqueValues.add(value);
                }
            }

            newLead.Potential_Programs_Claims__c = String.join(deduplicatedValues, ';');
        }
    }
}