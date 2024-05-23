/* 
Modified By: Aamir Maqsood
Modified Date: 26-June-2019
Modification: Converted the Process Builder named "Opp - Pre Review and Approval Time Stamp" to Trigger

Date Modified: 8-Mar-2020
Purpose: Populate the CVS Assigned User hidden Lookup field when a User Name is selected from the CVS Assigned Picklist field at UI

Modified By: Rizwan-Ali
Modified Date: 23-May-2020
Modification: Populate the Initial & Final reviewer User hidden Lookup field when a User Name is selected from the Initial & Final reviewer Picklist field at UI
Picklists: Initial_reviewer_user__c, Final_reviewer_user__c
Lookup: Initialreviewer__c, Finalreviewer__c
*/

trigger OpportunityBeforeInsertBeforeUpdate on Opportunity (before insert, before update) {
 
 if(Trigger.IsBefore && (Trigger.isInsert || Trigger.isUpdate))
 {
 
   //Create a set of User names to find the user in database
   SET<String> SetofUserNamesToClear =  new Set<String>();
   SET<String> SetofUserNames =  new Set<String>();
   
    Set<Id> oppIds = new Set<Id>();
    for(Opportunity opp : trigger.new) 
    {
        Opportunity old = trigger.isUpdate ? trigger.oldMap.get(opp.Id) : new Opportunity();
        
        if(trigger.isInsert || opp.Num_of_Open_Cases__c != old.Num_of_Open_Cases__c) {
            opp.Num_of_Open_Cases__c = 0;

            if(trigger.isUpdate) {
                oppIds.add(opp.Id);
            }
        }
        
        if(Trigger.isInsert && opp.CVS_Assigned_Users__c !=null && opp.CVS_Assigned_Users__c != '')
        {
            SetofUserNames.add(opp.CVS_Assigned_Users__c);
        }
        
        if(Trigger.isInsert && opp.CVS_Assigned_Users_AG__c !=null && opp.CVS_Assigned_Users_AG__c!= '')
        {
            SetofUserNames.add(opp.CVS_Assigned_Users_AG__c);
        }
        
        if(Trigger.isInsert && opp.ReviewerIfNotCVS_Users__c  !=null && opp.ReviewerIfNotCVS_Users__c  != '')
        {
            SetofUserNames.add(opp.ReviewerIfNotCVS_Users__c );
        }
        // Initial reviewer
        if(Trigger.isInsert && opp.Initial_reviewer_user__c  !=null && opp.Initial_reviewer_user__c  != '')
        {
            SetofUserNames.add(opp.Initial_reviewer_user__c );
        }
        //final reviewer
        if(Trigger.isInsert && opp.Final_reviewer_user__c  !=null && opp.Final_reviewer_user__c  != '')
        {
            SetofUserNames.add(opp.Final_reviewer_user__c );
        }
        
        if (Trigger.isUpdate && 
                  Trigger.oldMap.get(opp.ID).CVS_Assigned_Users__c != opp.CVS_Assigned_Users__c && 
                  opp.CVS_Assigned_Users__c != null &&
                  opp.CVS_Assigned_Users__c != ''
                 )
        {
           SetofUserNames.add(opp.CVS_Assigned_Users__c);
        }
        
        if (Trigger.isUpdate && 
                  Trigger.oldMap.get(opp.ID).CVS_Assigned_Users_AG__c!= opp.CVS_Assigned_Users_AG__c&& 
                  opp.CVS_Assigned_Users_AG__c!= null &&
                  opp.CVS_Assigned_Users_AG__c!= ''
                 )
        {
           SetofUserNames.add(opp.CVS_Assigned_Users_AG__c);
        }
        
        if (Trigger.isUpdate && 
                  Trigger.oldMap.get(opp.ID).ReviewerIfNotCVS_Users__c != opp.ReviewerIfNotCVS_Users__c && 
                  opp.ReviewerIfNotCVS_Users__c != null &&
                  opp.ReviewerIfNotCVS_Users__c != ''
                 )
        {
           SetofUserNames.add(opp.ReviewerIfNotCVS_Users__c );
        }
        // Initial reviewer
         if (Trigger.isUpdate && 
                  Trigger.oldMap.get(opp.ID).Initial_reviewer_user__c != opp.Initial_reviewer_user__c && 
                  opp.Initial_reviewer_user__c != null &&
                  opp.Initial_reviewer_user__c != ''
                 )
        {
           SetofUserNames.add(opp.Initial_reviewer_user__c );
        }
        // Final reviewer
         if (Trigger.isUpdate && 
                  Trigger.oldMap.get(opp.ID).Final_reviewer_user__c != opp.Final_reviewer_user__c && 
                  opp.Final_reviewer_user__c != null &&
                  opp.Final_reviewer_user__c != ''
                 )
        {
           SetofUserNames.add(opp.Final_reviewer_user__c );
        }
        
        if (Trigger.isUpdate)
        {
            if(Trigger.oldMap.get(opp.ID).CVS_Assigned_Users__c != opp.CVS_Assigned_Users__c && opp.CVS_Assigned_Users__c == null)
            {
              SetofUserNamesToClear.add(opp.CVS_Assigned_Users__c);
            }
            
            if(Trigger.oldMap.get(opp.ID).CVS_Assigned_Users_AG__c!= opp.CVS_Assigned_Users_AG__c && opp.CVS_Assigned_Users_AG__c == null)
            {
               SetofUserNamesToClear.add(opp.CVS_Assigned_Users_AG__c);
            }
        
            if(Trigger.oldMap.get(opp.ID).ReviewerIfNotCVS_Users__c != opp.ReviewerIfNotCVS_Users__c  && opp.ReviewerIfNotCVS_Users__c  == null) 
            {
               SetofUserNamesToClear.add(opp.ReviewerIfNotCVS_Users__c );
            }
            // Initial reviewer
             if(Trigger.oldMap.get(opp.ID).Initial_reviewer_user__c != opp.Initial_reviewer_user__c  && opp.Initial_reviewer_user__c  == null) 
            {
               SetofUserNamesToClear.add(opp.Initial_reviewer_user__c );
            }
            // Final reviewer
             if(Trigger.oldMap.get(opp.ID).Final_reviewer_user__c != opp.Final_reviewer_user__c  && opp.Final_reviewer_user__c  == null) 
            {
               SetofUserNamesToClear.add(opp.Final_reviewer_user__c );
            }
        }
        
        
        //START: Process Builder named "Opp - Pre Review and Approval Time Stamp"
        /*1. 
            PreReviewCheck__c != YES && StageofWork_Umbrella = 'Pre-Review'
            THEN
            PreReviewCheck__c = YES
            PreReviewTimeStamp = Today
        */
        if(opp.preReviewCheck__c != 'Yes' && opp.Stage_of_Work_Umbrella__c == 'pre-review')
        {
          opp.preReviewCheck__c = 'Yes';
          opp.preReviewTimeStamp__c = System.Today();
        }
        
        /*
           2.PreReviewCheck__c = YES && StageofWork_Umbrella = 'Approval'
           THEN ApprovalTimeStemp = Today.
        */
        if(opp.preReviewCheck__c == 'Yes' && opp.Stage_of_Work_Umbrella__c == 'approval')
        {
          opp.approvalTimeStamp__c = System.Today();
        }
        
       //END: Process Builder named "Opp - Pre Review and Approval Time Stamp"
       /*if(opp.isCloneAmericanGrown__c==TRUE)
        {
          
          opp.Stage_of_Work_American_Grown__c = NULL;
          opp.Issue_date__c = NULL;
          opp.isCloneAmericanGrown__c = FALSE;
        }  */ 
        
    }
    
    //START : CVS CODE
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
       for(Opportunity obj: Trigger.New) 
       { 
         if ( 
              (SetofInactiveUsersNames.contains(obj.CVS_Assigned_Users__c)) ||
              (SetofInactiveUsersNames.contains(obj.CVS_Assigned_Users_AG__c)) || 
              (SetofInactiveUsersNames.contains(obj.ReviewerIfNotCVS_Users__c ))||
              (SetofInactiveUsersNames.contains(obj.Initial_reviewer_user__c ))||
              (SetofInactiveUsersNames.contains(obj.Final_reviewer_user__c ))
            ) 
         {
           obj.addError(Label.InactiveUser);
         }
         
         if(!SetofInactiveUsersNames.contains(obj.CVS_Assigned_Users__c) && (MapofUserNameAndUserID != null))
         {
              if (MapofUserNameAndUserID.get(obj.CVS_Assigned_Users__c) != null)
              {
                 obj.CVS_Assigned1__c = MapofUserNameAndUserID.get(obj.CVS_Assigned_Users__c); 
              }
         }
         
         if(!SetofInactiveUsersNames.contains(obj.CVS_Assigned_Users_AG__c) && (MapofUserNameAndUserID != null))
         {
              if (MapofUserNameAndUserID.get(obj.CVS_Assigned_Users_AG__c) != null)
              {
                 obj.CVS_Assigned_AmericanGrown1__c = MapofUserNameAndUserID.get(obj.CVS_Assigned_Users_AG__c); 
              }
         }
         
         if(!SetofInactiveUsersNames.contains(obj.ReviewerIfNotCVS_Users__c ) && (MapofUserNameAndUserID != null))
         {
              if (MapofUserNameAndUserID.get(obj.ReviewerIfNotCVS_Users__c ) != null)
              {
                 obj.Reviewer_if_not_CVS1__c = MapofUserNameAndUserID.get(obj.ReviewerIfNotCVS_Users__c ); 
              }
         }
           // Initial reviewer
           if(!SetofInactiveUsersNames.contains(obj.Initial_reviewer_user__c) && (MapofUserNameAndUserID != null))
         {
              if (MapofUserNameAndUserID.get(obj.Initial_reviewer_user__c) != null)
              {
                 obj.Initialreviewer__c = MapofUserNameAndUserID.get(obj.Initial_reviewer_user__c); 
              }
         }
           // Final reviewer
           if(!SetofInactiveUsersNames.contains(obj.Final_reviewer_user__c) && (MapofUserNameAndUserID != null))
         {
              if (MapofUserNameAndUserID.get(obj.Final_reviewer_user__c) != null)
              {
                 obj.Finalreviewer__c = MapofUserNameAndUserID.get(obj.Final_reviewer_user__c); 
              }
         }
         
       } 
    }
    
    if(SetofUserNamesToClear.size() > 0)
    {
      for(Opportunity obj: Trigger.New) 
      { 
         if(SetofUserNamesToClear.contains(obj.CVS_Assigned_Users__c))
         {
            obj.CVS_Assigned1__c = null;   
         }
 
         if(SetofUserNamesToClear.contains(obj.CVS_Assigned_Users_AG__c))
         {
            obj.CVS_Assigned_AmericanGrown1__c = null;   
         }
 
         if(SetofUserNamesToClear.contains(obj.ReviewerIfNotCVS_Users__c ))
         {
            obj.Reviewer_if_not_CVS1__c = null;   
         }
          // Initial reviewer
           if(SetofUserNamesToClear.contains(obj.Initial_reviewer_user__c ))
         {
            obj.Initialreviewer__c = null;   
         }
          // Final reviewer
          if(SetofUserNamesToClear.contains(obj.Final_reviewer_user__c ))
         {
            obj.Finalreviewer__c = null;   
         }
 
      }
    }
    //END: CVS CODE
    //END Initial & Final CODE
  
    oppIds.remove(null);

    if(!oppIds.isEmpty()) {
        for(AggregateResult ar : [SELECT Opportunity__c oppId, COUNT(Id) cnt FROM Case WHERE Opportunity__c IN :oppIds AND IsClosed = false GROUP BY Opportunity__c]) {
            Opportunity opp = trigger.newMap.get((Id) ar.get('oppId'));
            opp.Num_of_Open_Cases__c = (Decimal) ar.get('cnt');
        }
    }
    
  }
}