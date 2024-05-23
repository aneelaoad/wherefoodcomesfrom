public class NonConformityController {
    public List<Non_Conformity__c> nonConformities { get; set; }

    public NonConformityController() {
        nonConformities = new List<Non_Conformity__c>();
        List<Id> lstId = new List<Id>(); // Replace with the actual list of IDs
        Set<Id> setOfNCDueIDs = new Set<Id>(); // Replace with the actual Set of IDs
        
        nonConformities = [
            SELECT Id, NC_Description__c, NC_Identified_Standard_Number__c, Note__c, Verification_Report__c
            FROM Non_Conformity__c
            WHERE (Verification_Report__c IN :lstId OR Verification_Report__c IN :setOfNCDueIDs)
            AND (NC_Clearance__c = 'No' OR NC_Clearance__c = null)
        ];
    }
}