/*Created by: Muhammad Jawwad
  Date: 22-Feb-2021 
  Purpose: Update Program and Claims Multipicklist
*/
trigger GroupTrigger on Group__c (Before Update) {

    if(Trigger.isBefore && (Trigger.isUpdate))
    {
       
        
        for(Group__c grp: trigger.new)
        {
          
            String val1 = grp.Gap_Programs_and_Claims__c;
            String val2 = grp.Other_Programs_and_Claims__c;
            String val3 = grp.Umbrella_Programs_and_Claims__c;
            String PAC = '';
            
            if(val1 != null && val1 != '')
            {
                PAC += val1+';';
            }
            
            if(val2 != null && val2 != '')
            {
                if(PAC.contains( 'China EV') && val2.contains('China EV'))
                {
                    PAC = PAC.substring(0, PAC.indexOf('China EV'));
                }
                
                PAC += val2+';';
            }
            
            if(val3 != null && val3 != '')
            {
                
                if(PAC.contains( 'China EV') && val3.contains('China EV'))
                {
                    PAC = PAC.substring(0, PAC.indexOf('China EV'));
                }
                
                PAC += val3+';';
                
            }
            
            if(PAC.contains('Source Verification') && PAC.contains('Age Verification') && PAC.contains('China EV') ==False)
            {
                PAC = PAC + 'China EV;';
            }
            
            grp.Programs_Claims__c = PAC;
            
        } 
       
        
    }
}