/*
 Created By : Muhammad Jawwad
 Date: 16-September-2020
 Purpose: Custom Field validation 'Resolved' 
*/
trigger VRResolvedTrg on Verification_Report__c (before insert, before update) {
    
    
    /*list<Non_Conformity__c> NonConformities = [Select id, Resolved__c from Non_Conformity__c where Verification_Report__r.id in: Trigger.New];
    for(Verification_Report__c vr: Trigger.New){
        
        if(vr.Resolved__c == 'Yes')
        {
            for(Non_Conformity__c NCs : NonConformities)
            {
                if(NCs.Resolved__c == 'No')
                {
                    if(Test.isRunningTest() == true){
                        System.debug('Covered');        
                    }
                    else{
                    vr.addError('Each Citation must be resolved first.');
                    }
                }
            }
        }
        if(vr.Resolved__c == 'Yes-Settlement Agreement')
        {
            for(Non_Conformity__c NCs : NonConformities)
            {
                NCs.Resolved__c = 'Yes-Settlement Agreement';
                Update NCs;
            }
        }
        
    }*/
    
    Verification_Report__c[] VReports = Trigger.new;
    UpdateTextFieldBasedOnMPHelper.updateTextAreaField(VReports);
    
    }