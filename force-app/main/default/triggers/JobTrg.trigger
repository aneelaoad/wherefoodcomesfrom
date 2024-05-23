/*
Developed By: Aamir Maqsood
Date Created: 10-Mar-2020
Purpose: Populate the CVS Assigned User hidden Lookup field when a User Name is selected from the CVS Assigned Picklist field at UI
*/
trigger JobTrg on sked__Job__c  (before insert, before update) 
{
  if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate) )
  {
   
   //Create a set of User names to find the user in database
   SET<String> SetofUserNamesToClear =  new Set<String>();
   SET<String> SetofUserNames =  new Set<String>();
   
   //Populate the SetofUserNames
   for(sked__Job__c  obj : Trigger.New)
   { 
     if(Trigger.isInsert && obj.CVS_Assigned_Users__c !=null && obj.CVS_Assigned_Users__c != '')
     {
        SetofUserNames.add(obj.CVS_Assigned_Users__c);
     }
     else if (Trigger.isUpdate && 
              Trigger.oldMap.get(obj.ID).CVS_Assigned_Users__c != obj.CVS_Assigned_Users__c && 
              obj.CVS_Assigned_Users__c != null &&
              obj.CVS_Assigned_Users__c != ''
             )
     {
       SetofUserNames.add(obj.CVS_Assigned_Users__c);
     }
     else if (Trigger.isUpdate && 
              Trigger.oldMap.get(obj.ID).CVS_Assigned_Users__c != obj.CVS_Assigned_Users__c 
             )
     {
       SetofUserNamesToClear.add(obj.CVS_Assigned_Users__c);
     }
     
   }
   
   //Query the Users using the SetofUserNames 
   if(SetofUserNames.size()>0)
   {
   
       List<User> ListofUsers = [SELECT Id, 
                                        Name, 
                                        isActive 
                                 FROM User WHERE Name IN: SetofUserNames 
                                ];
       
       
       //Process the ListofUsers and create a Map 
       Set<String> SetofInactiveUsersNames = new Set<String>(); 
       Map<String,ID> MapofUserNameAndUserID = new Map<String,ID>();
       for(User u : ListofUsers )
       {
         if(u.isActive)
         {
            if(MapofUserNameAndUserID!=null)
            {
              if(MapofUserNameAndUserID.get(u.Name) != null)
              {
               //do nothing, already added
              }
              else
              {
                MapofUserNameAndUserID.put(u.Name,u.ID);
              }
            }
            else
            {
              MapofUserNameAndUserID.put(u.Name,u.ID);
            }
            
         }
         else
         {
            SetofInactiveUsersNames.add(u.Name);
         }
       }
       
       //final step: populate the cvs user lookup
       for(sked__Job__c  obj: Trigger.New) 
       { 
         if(SetofInactiveUsersNames.contains(obj.CVS_Assigned_Users__c))
         {
           obj.addError(Label.InactiveUser);
         }
         else if(!SetofInactiveUsersNames.contains(obj.CVS_Assigned_Users__c))
         {
             if(MapofUserNameAndUserID != null)
             {
              if (MapofUserNameAndUserID.get(obj.CVS_Assigned_Users__c) != null)
              {
                 obj.CVS_Assigned1__c = MapofUserNameAndUserID.get(obj.CVS_Assigned_Users__c); 
              }
             }
         }
       } 
      }
    
    if(SetofUserNamesToClear.size() > 0)
    {
      for(sked__Job__c  obj: Trigger.New) 
      { 
         if(SetofUserNamesToClear.contains(obj.CVS_Assigned_Users__c))
         {
            obj.CVS_Assigned1__c = null;   
         }
 
      }
    }
 
    }
 }