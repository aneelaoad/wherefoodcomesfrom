public class BusinessLostController {
    
    public String  currentRecordId    				{get;set;}
    public String  businessLostReason 				{get;set;}
    public String  businessLostReasonOther 			{get;set;}
    public String  businessLostReasonAdditionalInfo {get;set;}
    public boolean otherSelected 					{get;set;}
    public boolean allSelected 					    {get;set;}
    public boolean SendExitInterviewForm 			{get;set;}
    
    Opportunity opp =new Opportunity();
    
    public BusinessLostController(ApexPages.StandardController c){ 
        
        System.debug( UserInfo.getUiTheme());
        //Current Account ID on which product are to upload 
       
        currentRecordId  = c.getId();//ApexPages.CurrentPage().getparameters().get('id');
        
        system.debug(currentRecordId);
        opp = [SELECT ID,Business_Lost_Reason__c,Business_Lost_Reason_Other__c,Business_Lost_Reason_Additional_Info__c,Send_Exit_Interview_Form__c from Opportunity where id = :currentRecordId LIMIT 1];
        SendExitInterviewForm =opp.Send_Exit_Interview_Form__c;
        system.debug(opp);
        
        businessLostReason =opp.Business_Lost_Reason__c;
        
        
        try{
            businessLostReasonOther           = opp.Business_Lost_Reason_Other__c;
            businessLostReasonAdditionalInfo  = opp.Business_Lost_Reason_Additional_Info__c;	
            
            if(businessLostReason == 'Other'){
                otherSelected = true;
               
            }
            
            else{
                otherSelected = false;
            }
            
            
            if(   businessLostReason == 'Adverse Actions'
               || businessLostReason == 'Non-Responsive' 
               || businessLostReason == 'Price Concerns' 
               || businessLostReason == 'Market Concerns' 
               || businessLostReason == 'Lost Buyer' 
               || businessLostReason == 'Switched Verifiers' 
               || businessLostReason == 'Dissatisfied with Service'
               || businessLostReason == 'Unpaid Fees'){
                  allSelected = true;
                  
               }
            else{
                  allSelected = false;
                
            }
            
        }
        catch(Exception ex){
            
        }
        
    }
    
    public List<SelectOption>  getBusinessLostReasonPickListValues(){
        
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('None','--None--'));
        Schema.DescribeFieldResult fieldResult = opportunity.Business_Lost_Reason__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry p : ple)
            options.add(new SelectOption(p.getValue(), p.getValue())); 
        return options;
    }
    
    
    
    public PageReference updateOpp(){
        
        Opportunity opp = new Opportunity();     
        opp.Id = currentRecordId;
        
        opp.Send_Exit_Interview_Form__c = SendExitInterviewForm;
        opp.Business_Lost_Reason__c = businessLostReason;
        system.debug(businessLostReason);
        if(businessLostReason == 'Other'){ 
            opp.Business_Lost_Reason_Other__c = businessLostReasonOther;
        }
        else {
            opp.Business_Lost_Reason_Other__c = '';
        }
        
        if(   businessLostReason == 'Adverse Actions'
           || businessLostReason == 'Non-Responsive' 
           || businessLostReason == 'Price Concerns' 
           || businessLostReason == 'Market Concerns' 
           || businessLostReason == 'Lost Buyer' 
           || businessLostReason == 'Switched Verifiers' 
           || businessLostReason == 'Dissatisfied with Service'
           || businessLostReason == 'Unpaid Fees'){ 
               opp.Business_Lost_Reason_Additional_Info__c = businessLostReasonAdditionalInfo;
           }
        else {
            opp.Business_Lost_Reason_Additional_Info__c = '';
        }
        
        
        
        update opp;
        
        
        ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Record Uodated Successfully.Thank you!'));
     //   IF(UserInfo.getUiTheme() == 'Theme4d'){
    ////        PageReference pg = new PageReference('/'+currentRecordId);
    //        pg.setRedirect(true);
    //        return pg;
    //    }
       
        return null;
    }
    public void setOther(){
        
        if(businessLostReason == 'Other'){
            otherSelected = true;
            
        }
        else{
            otherSelected = false;
            
        }
        
    }
    public void setAll(){
        
        businessLostReasonOther           = '';
        businessLostReasonAdditionalInfo  = '';	
        
        if(   businessLostReason == 'Adverse Actions'
           || businessLostReason == 'Non-Responsive' 
           || businessLostReason == 'Price Concerns' 
           || businessLostReason == 'Market Concerns' 
           || businessLostReason == 'Lost Buyer' 
           || businessLostReason == 'Switched Verifiers' 
           || businessLostReason == 'Dissatisfied with Service'
           || businessLostReason == 'Unpaid Fees'){
               allSelected = true;
               
           }
        else{
               allSelected = false;
            
        }
        if(businessLostReason == 'Other'){
            otherSelected = true;
            
        }
        else{
            otherSelected = false;
            
        }
        
    }
}