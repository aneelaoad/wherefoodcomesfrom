({
    
    doInit: function(component) {
        
        var action = component.get("c.cloneOrganicOpportunity");
        action.setParams({
            "recordId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            let data = response.getReturnValue();
           
            
            
            
            var cloneOrganicOpportunityEvent = $A.get("e.force:createRecord");
            
            
            cloneOrganicOpportunityEvent.setParams({
                "entityApiName": "Opportunity",
                "recordTypeId":"0121R000001M7HjQAK",
                "defaultFieldValues": {
                    "Name" : data.Name,
                    "AccountId" : data.AccountId,
                    "Customer_Type__c":data.Customer_Type__c,
                    "Investigations__c": data.Investigations__c,
                    "Initial_reviewer_user__c": data.Initial_reviewer_user__c,
                    "Final_reviewer_user__c"  : data.Final_reviewer_user__c,
                    "CloseDate": data.X90_days_before_Anniversary__c,
                    "hasBeenCloned__c":"No",
                    "StageName" : "Renewal",
                    "isCloned__c" : true,
                    "Physical_Address_Liner_Text__c" : data.Physical_Address_Liner_Text__c,
                    "Due_by_Date__c" : data.Anniversary_date__c
                }
            });
            cloneOrganicOpportunityEvent.fire();
        });
        
        $A.enqueueAction(action);
        
    },
})