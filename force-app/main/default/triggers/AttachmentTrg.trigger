/*
Created By : Muhammad Jawwad
Created Date :11/11/2020
description : Rename Attachment Logic for major and minor NC VR's
*/

trigger AttachmentTrg on Attachment (after insert) {
    List<Attachment> toBeUpdatedAttachment = new List<Attachment>();
    
    Id MinorNCrecordTypeId                = Schema.SObjectType.Verification_Report__c.getRecordTypeInfosByName().get('WFCFO Minor NC Verification Report').getRecordTypeId();
    Id MajorNCrecordTypeId                = Schema.SObjectType.Verification_Report__c.getRecordTypeInfosByName().get('WFCFO Major NC Verification Report').getRecordTypeId();
    Id ICSMajorNCrecordTypeId             = Schema.SObjectType.Verification_Report__c.getRecordTypeInfosByName().get('ICS Major NC Verification Report').getRecordTypeId();
    Id SamplingrecordTypeId               = Schema.SObjectType.Verification_Report__c.getRecordTypeInfosByName().get('Sampling Verification Report').getRecordTypeId();
    Id UnannouncedInspectionsrecordTypeId = Schema.SObjectType.Verification_Report__c.getRecordTypeInfosByName().get('Unannounced Inspections').getRecordTypeId();
    Id SettlementAgreementrecordTypeId    = Schema.SObjectType.Verification_Report__c.getRecordTypeInfosByName().get('Settlement Agreement Verification Report').getRecordTypeId();
    Id WFCFOrganicrecordTypeId            = Schema.SObjectType.Certificate__c.getRecordTypeInfosByName().get('WFCF Organic').getRecordTypeId();
    Id ABeeOrganicrecordTypeId            = Schema.SObjectType.Certificate__c.getRecordTypeInfosByName().get('A Bee Organic').getRecordTypeId();
    Id ICSrecordTypeId                    = Schema.SObjectType.Certificate__c.getRecordTypeInfosByName().get('ICS').getRecordTypeId();
    Id ChainOfCustodyRecordTypeId         = Schema.SObjectType.Certificate__c.getRecordTypeInfosByName().get('Chain Of Custody').getRecordTypeId();
    
    for(Attachment objAttachment : [SELECT id,Name,ParentId,Parent.Name, Parent.RecordTypeid FROM Attachment WHERE Id IN:Trigger.new]){
        
        if(   objAttachment.Parent.RecordTypeid == MajorNCrecordTypeId 
           || objAttachment.Parent.RecordTypeid == WFCFOrganicrecordTypeId  
           || objAttachment.Parent.RecordTypeid == ABeeOrganicrecordTypeId 
           || objAttachment.Parent.RecordTypeid == ICSrecordTypeId
           || objAttachment.Parent.RecordTypeid == ICSMajorNCrecordTypeId
           || objAttachment.Parent.RecordTypeid == SamplingrecordTypeId
           || objAttachment.Parent.RecordTypeid == MinorNCrecordTypeId
           || objAttachment.Parent.RecordTypeid == UnannouncedInspectionsrecordTypeId
           || objAttachment.Parent.RecordTypeid == SettlementAgreementrecordTypeId
           || objAttachment.Parent.RecordTypeid == ChainOfCustodyRecordTypeId
          )
        { 
            if(objAttachment.Name.contains('Resolution'))
            {
                objAttachment.Name = objAttachment.Parent.Name +' – Resolution Notice.pdf';    
            }
            else if(objAttachment.Name.contains('Instructions'))
            {
                objAttachment.Name = objAttachment.Parent.Name +' – Instructions.pdf';
            }
            else if(objAttachment.Name.contains('Results'))
            {
                objAttachment.Name = objAttachment.Parent.Name +' – Results.pdf';
            }
            else if(objAttachment.Name.contains('Denial'))
            {
                objAttachment.Name = objAttachment.Parent.Name +' – Notice Of Denial.pdf';
            }
            else if(objAttachment.Name.contains('Proposed'))
            {
                objAttachment.Name = objAttachment.Parent.Name +' – Proposed Suspension Notice.pdf';
            }
            else if(objAttachment.Name.contains('Suspension'))
            {
                objAttachment.Name = objAttachment.Parent.Name +' – Suspension Notice.pdf';
            }
            else if(objAttachment.Name.contains('Closure'))
            {
                objAttachment.Name = objAttachment.Parent.Name +' – Settlement Agreement Closure.pdf';
            }
            else if(objAttachment.Name.contains('Settlement'))
            {
                objAttachment.Name = objAttachment.Parent.Name +' – Settlement Agreement.pdf';
            }
            else
            {
                objAttachment.Name = objAttachment.Parent.Name +'.pdf';
            }
            
            toBeUpdatedAttachment.add(objAttachment);
        }
    }    
    update toBeUpdatedAttachment;       
}