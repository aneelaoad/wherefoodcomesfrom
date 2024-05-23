trigger PreventDuplicateProgramsOnOppty on Opportunity (before insert, before update) {
    Set<String> uniqueValuesO = new Set<String>();
    Set<String> uniqueValuesU = new Set<String>();

    for (Opportunity newOpportunity : Trigger.new) {
        if (newOpportunity.Programs_Claims_Other__c != null) {
            List<String> valuesO = newOpportunity.Programs_Claims_Other__c.split(';');
            List<String> deduplicatedValuesO = new List<String>();

            for (String valueO : valuesO) {
                if (!uniqueValuesO.contains(valueO)) {
                    deduplicatedValuesO.add(valueO);
                    uniqueValuesO.add(valueO);
                }
            }

            newOpportunity.Programs_Claims_Other__c = String.join(deduplicatedValuesO, ';');
        }

        if (newOpportunity.Programs_Claims_Umbrella__c != null) {
            List<String> valuesU = newOpportunity.Programs_Claims_Umbrella__c.split(';');
            List<String> deduplicatedValuesU = new List<String>();

            for (String valueU : valuesU) {
                if (!uniqueValuesU.contains(valueU)) {
                    deduplicatedValuesU.add(valueU);
                    uniqueValuesU.add(valueU);
                }
            }

            newOpportunity.Programs_Claims_Umbrella__c = String.join(deduplicatedValuesU, ';');
        }
    }
}