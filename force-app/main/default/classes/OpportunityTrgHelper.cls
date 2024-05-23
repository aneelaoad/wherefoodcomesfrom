/*
Developed By: Aamir Maqsood
Date Created: 13-Mar-2020
Purpose: Helper class to OpportunityTrg trigger.
*/
public class OpportunityTrgHelper 
{
  //Declaring String Constants
  Static String Stage_of_Work_Umbrella = 'Stage of Work Umbrella';
  Static String Stage_of_Work_Other = 'Stage of Work Other';
     
     
 /* public static List<String> get_ListofValues(String PicklistName){
       
       List<String> pickListValuesList= new List<String>();
       Schema.DescribeFieldResult fieldResult;
       
        if(PicklistName == Stage_of_Work_Umbrella )
        {
           fieldResult = Opportunity.Stage_of_Work_Umbrella__c.getDescribe();
        }
        
        if(PicklistName == Stage_of_Work_Other )
        {
           fieldResult = Opportunity.Stage_of_Work_Other__c.getDescribe();
        }
        
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        }     
        return pickListValuesList;
   } */

  /*public static String get_FirstValue(String PicklistName){
    
       String result ='';
       List<String> ListofValues = get_ListofValues(PicklistName);
       if(ListofValues != null && ListofValues.size()>0)
       {
          result = ListofValues [0];
       }
       return result;
   }
      
   public static String get_LastValue(String PicklistName){
    
       String result ='';
       List<String> ListofValues = get_ListofValues(PicklistName);
       if(ListofValues != null && ListofValues.size()>0)
       {
          result = ListofValues [ListofValues.size()-1];
       }
       return result;
   }*/
   
    
   //create new opportunity status history records
   public static void insertOpportunityStatusHistory(List<Opportunity> ListofOpportunity, 
                                                               String StatusPickListName,
                                                               Map<ID,Opportunity> oldMap
                                                               )
   {
      
      Set<ID> SetofOppId = new Set<ID>();
      Set<String> SetofStatusFrom = new Set<String>();
      List<Opportunity_Status_History__c> ListofOSH = new  List<Opportunity_Status_History__c>();
      Map<ID,String> MapofOppIDStatus = new Map<ID,String>(); 
      
      
      SET<String> SetofLastStatuses = new Set<String>();
      SetofLastStatuses.add('approval');
      SetofLastStatuses.add('delisted - conformance reasons');
      SetofLastStatuses.add('delisted - business lost');
      
      
      
      for(Opportunity opp: ListofOpportunity)
      {
        Boolean LastStatus = False;
        String  Status = null; //New Status
        String oldStatus = null; // old status
       /* String  LastStatusValue = get_LastValue(StatusPickListName);
        String  FirstStatusValue = get_FirstValue(StatusPickListName);*/
      
      
      //if(StatusPickListName == Stage_of_Work_Umbrella  && opp.Stage_of_Work_Umbrella__c == LastStatusValue )
      if(StatusPickListName == Stage_of_Work_Umbrella  && SetofLastStatuses.contains(opp.Stage_of_Work_Umbrella__c) )
      {
           LastStatus  = true;
      }
        
      //if(StatusPickListName == Stage_of_Work_Other  && opp.Stage_of_Work_Other__c== LastStatusValue )
      if(StatusPickListName == Stage_of_Work_Other  && SetofLastStatuses.contains(opp.Stage_of_Work_Other__c))    
      {
           LastStatus  = true;
      }
        
       if(StatusPickListName == Stage_of_Work_Umbrella )
        {
           Status = opp.Stage_of_Work_Umbrella__c;
        }
        if(StatusPickListName == Stage_of_Work_Other )
        {
           Status = opp.Stage_of_Work_Other__c;
        }
        
        if(oldMap!=null)//in case of update
        {
          if(StatusPickListName == Stage_of_Work_Umbrella)
          {
            oldStatus = oldMap.get(opp.Id).Stage_of_Work_Umbrella__c;
          }
          if(StatusPickListName == Stage_of_Work_Other )
          {
            oldStatus = oldMap.get(opp.Id).Stage_of_Work_Other__c;
          }
        }
      
      
      if(oldStatus != null && oldStatus !='')
      {
        SetofOppId.add(opp.Id);
        SetofStatusFrom.add(oldStatus);
        MapofOppIDStatus.put(opp.Id,Status);
      }
      
      if(!LastStatus)
      {
       ListofOSH.add( new Opportunity_Status_History__c
                           (
                            Opportunity__c = opp.Id,
                            Status__c = StatusPickListName,
                            Status_From__c = Status,
                            Start_Date__c = System.Now(), 
                            User__c = UserInfo.getUserId()
                           )
                     );
      }
      //System.Debug('AM: Opportunity__c : ' + pp.Id);
      //System.Debug('AM: Status: ' + Status);
      }
      
      
      System.Debug('AM: StatusPickListName: ' + StatusPickListName);
      System.Debug('AM: ListofOSH: ' + ListofOSH);
     
      if(ListofOSH.size()>0)
      {
        insert ListofOSH;
      }
      
            //START: DELAY FOR 15 SECONDS 
              /*
            Integer DelayinMiliSeconds = Integer.valueof(Hakkasan_Email_Administrators__c.getInstance('BatchContactMobileUpdate').DelayInMiliSecond__c);
            Long startTime = DateTime.now().getTime();
            Long finishTime = DateTime.now().getTime();
            while ((finishTime - startTime) < DelayinMiliSeconds) //1000 means 1 SEC
            {
                finishTime = DateTime.now().getTime();
            }*/
            //END: DELAY FOR 15 SECONDS 
            
      Set<ID> setofOSH_ID = new Set<ID>();
      for(Opportunity_Status_History__c osh :ListofOSH)
      {
        setofOSH_ID.add(osh.ID);
      }
      System.Debug('AM: setofOSH_ID: ' + setofOSH_ID);
      
      //calling the method to update the end dates in the records
      /*if(setofOSH_ID!=null &&SetofOppId != null && SetofStatusFrom != null && 
         setofOSH_ID.size() > 0 && SetofOppId.size() > 0 && SetofStatusFrom.size() > 0)*/
       if(SetofOppId != null && SetofStatusFrom != null && 
          SetofOppId.size() > 0 && SetofStatusFrom.size() > 0)
      {
        updateOpportunityStatusHistory(
                                        StatusPickListName,
                                        SetofOppId,
                                        setofOSH_ID,
                                        SetofStatusFrom,
                                        MapofOppIDStatus
                                      );
      }
   }
   
   //update Opportunity Status History 
   public static void updateOpportunityStatusHistory(
                                      String StatusPickListName,
                                      Set<ID> SetofOppId,
                                      Set<ID> setofOSH_ID,
                                      Set<String> SetofStatusFrom,
                                      Map<ID,String> MapofOppIDStatus
                                     )
   {
      
      //Search and Update the End Dates for first status
      
      List<Opportunity_Status_History__c> ListofOSH = new List<Opportunity_Status_History__c>();
      
      if (setofOSH_ID!=null)
      {
                ListofOSH =  [SELECT Id,
                                                          Status__c,
                                                          End_Date__c,
                                                          Opportunity__c,
                                                          Status_From__c,
                                                          Status_To__c
                                                       FROM Opportunity_Status_History__c   
                                                       WHERE   Opportunity__c IN : SetofOppId
                                                       AND Status__c =: StatusPickListName 
                                                       AND Status_From__c IN: SetofStatusFrom
                                                       AND End_Date__c = null
                                                       AND ID NOT IN : setofOSH_ID
                                                       ];
                                                       
     }
     else
     {
                  ListofOSH =  [SELECT Id,
                                                          Status__c,
                                                          End_Date__c,
                                                          Opportunity__c,
                                                          Status_From__c,
                                                          Status_To__c
                                                       FROM Opportunity_Status_History__c   
                                                       WHERE   Opportunity__c IN : SetofOppId
                                                       AND Status__c =: StatusPickListName 
                                                       AND Status_From__c IN: SetofStatusFrom
                                                       AND Status_To__c = null
                                                       AND End_Date__c = null
                                                       ];
     
     
     }  
     if(ListofOSH.size()>0)
     {
         for(Opportunity_Status_History__c osh : ListofOSH)
         {
           if(MapofOppIDStatus!=null)
           {
             if(MapofOppIDStatus.get(osh.Opportunity__c)!= null)
             {
              osh.Status_To__c = MapofOppIDStatus.get(osh.Opportunity__c);
             }
           }
           
           osh.End_Date__c = System.Now();
         }   
     
          
        update ListofOSH;
     }     
     
   }
  
  
   ////
   /*
     
      DateTime ExpirationDate = null;
      if(Status=='pre-review')
      {
       ExpirationDate = System.Now();
      }
      Expiration_Date_Saved__c = ExpirationDate ,
                            
    
   */
   //update Opportunity Status History 
   public static void updateOpportunityStatusHistory_ExpirationDate(
                                      String StatusPickListName,
                                      Set<ID> SetofOppId
                                      )
   {
    
    List<Opportunity_Status_History__c> ListofOSH =  [SELECT Id,
                                                             Expiration_Date_Saved__c 
                                                       FROM Opportunity_Status_History__c   
                                                       WHERE   Opportunity__c IN : SetofOppId
                                                       AND Status__c =: StatusPickListName 
                                                       AND Status_From__c = 'pre-review'
                                                       ];
    
    
   
     if(ListofOSH.size()>0)
     {
         for(Opportunity_Status_History__c osh : ListofOSH)
         {
            osh.Expiration_Date_Saved__c = System.Now(); 
         }
     
         update ListofOSH;
     }    
   
   }
   ////                                                 
      
   
}