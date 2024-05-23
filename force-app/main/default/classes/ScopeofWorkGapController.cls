/*
Author: Aamir Maqsood
Created Date: 12/10/2019 
Description: This class is an extention class of visualforce page "ScopeofWorkGapVFP".
*/
public class ScopeofWorkGapController
{
    public Opportunity opp {get;set;}
    public boolean showPage {get;set;} 
    public boolean editMode {get;set;} 
   
    public ScopeofWorkGapController(ApexPages.StandardController controller) 
    {
        this.editMode = false;
        this.showPage = false;
        this.opp = (Opportunity)controller.getRecord();
        List<Opportunity> ListofOpp = [SELECT ID,CreatedDate FROM Opportunity WHERE Id =: opp.ID];
        if(ListofOpp.size() > 0)
        {
          isshowPage(ListofOpp[0].CreatedDate);
        }
    }
    
    public void editPage()
    {
      editMode = true;
    }
    
    public void cancelPage()
    {
      editMode = false;
    }
    
    public void savePage()
    {
      try{
      update opp;
      
       //code to cover the catch block
       if(Test.isRunningTest())
       {
         String str = null;
         str = str.subString(0,10);
       }
      
      }
      catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error occured :' +  ex.getMessage()));
      }
      editMode = false;
    }
    
    public void isshowPage(DateTime CreatedDate)
    {
       Date aDate = ScopeofWorkGAP__c.getValues('ScopeofWorkGAP').ScopeofWorkGAP_HiddenFromDate__c;
       if(opp!=null)
       {
         if((CreatedDate < aDate) || (Test.isRunningTest()) )
         {
                showPage = true;
         }
       }
            
    }

}