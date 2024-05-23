/* 
Created By: Aamir Maqsood
Created Date: 13-Mar-2020
Purpose: Metric Reports - Manipulation of the OpportunityStatusHistory table

Date Modified: 
Purpose: 

*/
trigger OpportunityTrg on Opportunity (after insert,after update) 
{

  if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate))
  { 
    if(checkRecursive.runOnce() || Test.isRunningTest())
    {
         
     //Declaring List of Opps to Pass to Helper Class 
     List<Opportunity> ListofOppFor_Stage_of_Work_Umbrella = new List<Opportunity>(); 
     List<Opportunity> ListofOppFor_Stage_of_Work_Other = new List<Opportunity>();
     Set<ID> SetofOppIDFor_Stage_of_Work_Umbrella = new Set<ID>();
     Set<ID> SetofOppIDFor_Stage_of_Work_Other = new Set<ID>();
     
     //Declaring String Constants
     String Stage_of_Work_Umbrella = 'Stage of Work Umbrella';
     String Stage_of_Work_Other = 'Stage of Work Other';
     
     //After Insert
     if(Trigger.isInsert)
     { 
       for(Opportunity opp: Trigger.new)
       {
        if(opp.Stage_of_Work_Umbrella__c != null)
        {
         ListofOppFor_Stage_of_Work_Umbrella.add(opp);
        }
        
        if(opp.Stage_of_Work_Other__c!= null)
        {
         ListofOppFor_Stage_of_Work_Other.add(opp);
        }
       }
       
       if(ListofOppFor_Stage_of_Work_Umbrella.size() >0)
       {
         OpportunityTrgHelper.insertOpportunityStatusHistory(ListofOppFor_Stage_of_Work_Umbrella,
                                                                      Stage_of_Work_Umbrella,
                                                                       null 
                                                                       );
       }
       
       if(ListofOppFor_Stage_of_Work_Other.size() >0)
       {
         OpportunityTrgHelper.insertOpportunityStatusHistory(ListofOppFor_Stage_of_Work_Other,
                                                                       Stage_of_Work_Other ,
                                                                       null 
                                                                       );
       }
       
     }
     //End of After Insert
     //After Update
     if(Trigger.isUpdate)
     {
       for(Opportunity opp: Trigger.new)
       {
        if(opp.Stage_of_Work_Umbrella__c != null && Trigger.oldMap.get(opp.Id).Stage_of_Work_Umbrella__c != opp.Stage_of_Work_Umbrella__c)
        {
          ListofOppFor_Stage_of_Work_Umbrella.add(opp);
        }
        
        if(opp.Stage_of_Work_Other__c!= null && Trigger.oldMap.get(opp.Id).Stage_of_Work_Other__c != opp.Stage_of_Work_Other__c)
        {
         ListofOppFor_Stage_of_Work_Other.add(opp);
        }  
        
        //For Expiration Dates

        if(opp.Expiration_Date_Umbrella__c!= null && Trigger.oldMap.get(opp.Id).Expiration_Date_Umbrella__c!= opp.Expiration_Date_Umbrella__c)
        {
         SetofOppIDFor_Stage_of_Work_Umbrella.add(opp.Id);
        }  
        
        if(opp.Expiration_Date_Other__c!= null && Trigger.oldMap.get(opp.Id).Expiration_Date_Other__c!= opp.Expiration_Date_Other__c)
        {
         SetofOppIDFor_Stage_of_Work_Other.add(opp.Id);
        }  
        
       }
       
       System.Debug('AM: ListofOppFor_Stage_of_Work_Umbrella : ' + ListofOppFor_Stage_of_Work_Umbrella);
       System.Debug('AM: ListofOppFor_Stage_of_Work_Other : ' + ListofOppFor_Stage_of_Work_Other);
     
       if(ListofOppFor_Stage_of_Work_Umbrella.size() >0)
       {
         OpportunityTrgHelper.insertOpportunityStatusHistory(ListofOppFor_Stage_of_Work_Umbrella,
                                                                            Stage_of_Work_Umbrella,
                                                                            Trigger.oldMap
                                                                       );
       }
       
       if(ListofOppFor_Stage_of_Work_Other.size() >0)
       {
         OpportunityTrgHelper.insertOpportunityStatusHistory(ListofOppFor_Stage_of_Work_Other,
                                                                            Stage_of_Work_Other ,
                                                                            Trigger.oldMap 
                                                                           );
       }
       
       //Start: For Expiration Dates
       if(SetofOppIDFor_Stage_of_Work_Umbrella.size() >0)
       {
         OpportunityTrgHelper.updateOpportunityStatusHistory_ExpirationDate(Stage_of_Work_Umbrella,SetofOppIDFor_Stage_of_Work_Umbrella);
       }
       if(SetofOppIDFor_Stage_of_Work_Other.size() >0)
       {
         OpportunityTrgHelper.updateOpportunityStatusHistory_ExpirationDate(Stage_of_Work_Other ,SetofOppIDFor_Stage_of_Work_Other);
       }
       
      
       //End: For Expiration Dates
       
     }
     //End of After Update 
  }
  }

}