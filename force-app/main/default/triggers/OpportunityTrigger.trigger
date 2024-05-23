/*Created by: Muhammad Jawwad
  Date: 12-Feb-2021 
  Purpose: Update Program and Claims on Certifate and Group Object Whenever Opportunity Program and Claims Updated
*/
trigger OpportunityTrigger on Opportunity (Before update) {
    
    if(Trigger.isBefore && (Trigger.isUpdate))
    {
        LIST<Opportunity> OppList = [Select id,Programs_Claims_GAP__c ,Programs_Claims_Other__c,Programs_Claims_Umbrella__c From Opportunity Where id in:trigger.new];
        Map<Id,Opportunity> mapOfIDOpportunity = new Map<Id,Opportunity>();
        
        for(Opportunity Opp: OppList){
            
            mapOfIDOpportunity.put(Opp.id,Opp);
        }
        
       
        
        LIST<Group__c> GroupList = [Select id, Opportunity__c,Programs_Claims__c from Group__c where Opportunity__c in:trigger.new];
        
        for(Group__c Groupp: GroupList){
            
            Opportunity opp = mapOfIDOpportunity.get(Groupp.Opportunity__c);
            
            String val1 = opp.Programs_Claims_GAP__c;
            String val2 = opp.Programs_Claims_Other__c;
            String val3 = opp.Programs_Claims_Umbrella__c;
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
            
            Groupp.Programs_Claims__c = PAC;
        } 
        Update GroupList;
    }
    
}