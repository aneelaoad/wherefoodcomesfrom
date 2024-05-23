/*Created by: Muhammad Jawwad
  Date: 19-Feb-2021 
  Purpose: Update Program and Claims Multipicklist
*/
trigger CertificateTrigger on Certificate__c ( Before Update) {
    
    if(Trigger.isBefore && (Trigger.isUpdate))
    {
        
        for(Certificate__c cert: trigger.new)
        {
            String pickValuesUmbrella = '';
            String pickValuesOther = '';
            
            if(!String.isBlank(cert.Umbrella_Program_and_Claims__c))
            {
                List<String> pickValues = cert.Umbrella_Program_and_Claims__c.split(';');
                
                for(String str : pickValues){
                    
                    pickValuesUmbrella +=str + '\n ';
                    
                    
                }
            }
            if(!String.isBlank(cert.Other_Program_and_Claims__c))
            {
                List<String> pickValues = cert.Other_Program_and_Claims__c.split(';');
                for(String str : pickValues){
                    
                    pickValuesOther +=str + '\n ';
                    
                    
                }
            }
            cert.umbrellaProgramsAll__c = pickValuesUmbrella;
            cert.OtherProgramsAll__c = pickValuesOther;
            
            
        }
        
    }
    
}