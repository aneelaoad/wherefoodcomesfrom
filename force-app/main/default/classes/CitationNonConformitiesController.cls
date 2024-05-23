public class CitationNonConformitiesController {
    
    public List<Citation__c> citations {get;set;}
    string currentVRId {get;set;}
    Id ncRecordTypeId = null;
    
    public CitationNonConformitiesController(Apexpages.StandardController controller){
        ncRecordTypeId = Schema.SObjectType.Non_conformity__c.getRecordTypeInfosByName().get('Citation (Non-Conformities)').getRecordTypeId();
        
        
        
        currentVRId = controller.getId();
        citations = [select id,title__c from Citation__c Order By title__c ASC];
    }
    
    public List<SelectOption> getOptions() {
        
        List<SelectOption> dropDownOpt = new List<SelectOption>();
        
        dropDownOpt.add(new SelectOption('','-None-'));
        for(Citation__c val: citations){
            dropDownOpt.add(new SelectOption(val.id,val.title__c));
            
        }
        
        
        return dropDownOpt;
    } 
    
    
    public string description {get;set;}
    public string selectedOption {get;set;}
    Public string CitationName {get;set;}
    
    public void description(){
        
        Citation__c citation = [select id,title__c,Name,citation_description__c from Citation__c where id = :selectedOption limit 1];
        
        description = citation.citation_description__c;
        description = citation.citation_description__c;
        CitationName= citation.title__c;
    }
    
    public string descriptionOfFacts {get;set;}
    public string correctiveActionReceivedDetail {get;set;}
    public string InternalNotes {get;set;} 
    public string correctiveActionReveiwed {get;set;}
    public string resolved {get;set;}
    public date responseDate {get;set;}
    public date resolutionDate {get;set;}
    
    public PageReference saveNonConformity(){
        
        Non_Conformity__c nonConformity  = new Non_Conformity__c();
        nonConformity.Verification_Report__c = currentVRId;
        nonConformity.Citation_Description__c= description;
        nonConformity.Corrective_Action_Received_Details__c = correctiveActionReceivedDetail;
        nonConformity.Corrective_Action_Reviewed__c = correctiveActionReveiwed;
        nonConformity.Description_of_Facts__c = descriptionOfFacts;
        nonConformity.Internal_Notes__c = InternalNotes;
        nonConformity.Resolved__c = resolved;
        nonConformity.Resolution_Date__c  = resolutionDate;
        nonConformity.Response_Date__c = responseDate;
        nonConformity.Citation_Name_Picklist__c = CitationName;
        nonConformity.RecordTypeId = ncRecordTypeId;
        
        insert nonConformity;
        PageReference newPage = new PageReference('/' + currentVRId); // This will be the visualforce page or Url that we want to redirect to
        newPage.setRedirect(true);    
        return newPage;
        
    }
}