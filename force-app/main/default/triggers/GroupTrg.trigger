/*
Author: Aamir Maqsood
Date Created: 12/11/2019
Purpose: When program and claims are updated at the group, update all related certificates
*/

trigger GroupTrg on Group__c (after update)
{

 if(Trigger.isAfter && Trigger.isUpdate)
 { 
   SET<ID> SetofGroupID = new Set<ID>();
   Map<ID,String> MapofGroupIDProgramClaims = new Map<ID,String>();
   for(Group__c objGroup: Trigger.New)
   {
      if( 
          (objGroup.Programs_Claims__c != null) && 
          (objGroup.Programs_Claims__c != Trigger.oldMap.get(objGroup.Id).Programs_Claims__c)
        )
      {
       SetofGroupID.add(objGroup.Id);
       MapofGroupIDProgramClaims.put(objGroup.Id, objGroup.Programs_Claims__c);
      }
      else if (objGroup.Programs_Claims__c == null)
      {
         SetofGroupID.add(objGroup.Id);
         MapofGroupIDProgramClaims.put(objGroup.Id, '');
      }
      
   }
   
   if(SetofGroupID.size()>0)//if any group where the program and claims is changed
   {
      List<Certificate__c> ListofCertificates = [SELECT ID,groupUmbrellaClaimsAll__c,Group__c  
                                                 FROM Certificate__c WHERE Group__c  IN: SetofGroupID];
                                                    
      
      if(ListofCertificates.size()>0)
      {
        
        for(Certificate__c c :ListofCertificates)
        {
            c.groupUmbrellaClaimsAll__c = MapofGroupIDProgramClaims.get(c.Group__c).replaceAll('[;]','\n');
        }
        
        
        Database.update(ListofCertificates,false);
        
      }
      
   }
   
   
   
 }

}