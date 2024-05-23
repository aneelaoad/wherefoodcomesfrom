({
    
    doInit: function(component) {
        
        var action = component.get("c.cloneOpportunityJS");
        action.setParams({
            "recordId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            let data = response.getReturnValue();
            //var fieldName  = component.get("CVS_Assigned__c");
            
            debugger
            console.log(data.CVS_Assigned__c);
            //console.log(fieldName);
            
            var createAcountContactEvent = $A.get("e.force:createRecord");
            var multiSiteOpp = "";
            if(data.Multi_Site_Operation_Umbrella__c== 'yes'){
                multiSiteOpp = "yes";
            }
            createAcountContactEvent.setParams({
                "entityApiName": "Opportunity",
                "recordTypeId": "01263000004DHVkAAO",
                "defaultFieldValues": {
                    "Name" : data.Name,
                    "Due_by_Date_Umbrella__c" : data.Expiration_Date_Umbrella__c,
                    "CloseDate" :data.earliestExpirationDate__c,
                    "CVS_Assigned_Users__c" : data.CVS_Assigned_Users__c,
                    "CVS_Assigned__c" : data.CVS_Assigned__c,
                    "AccountId" : data.AccountId,
                    "Division__c": data.Division__c,
                    "Customer_Type__c":data.Customer_Type__c,
                    "Marketing_Program__c":data.Marketing_Program__c,
                    "Video_Rep__c":data.Video_Rep__c,
                    "Animal_Count__c":data.Animal_Count__c,
                    "One_Time_Capacity__c":data.One_Time_Capacity__c,
                    "ReviewerIfNotCVS_Users__c": data.ReviewerIfNotCVS_Users__c,
                    "Reviewer_if_not_CVS__c": data.Reviewer_if_not_CVS__c,
                    "hasBeenCloned__c":"No",
                    "Verification_Type_Umbrella__c":data.Verification_Type_Umbrella__c,
                    "StageName" : "Renewal",
                    "Programs_Claims_Umbrella__c": data.Programs_Claims_Umbrella__c,
                    "Multi_Site_Operation_Umbrella__c": multiSiteOpp,
                    "Verification_Owner_Umbrella__c":data.Verification_Owner_Umbrella__c,
                    "Release_Form_on_File__c":data.Release_Form_on_File__c,
                    "Estimate_Ship_Date__c":data.Estimate_Ship_Date__c,
                    "Due_by_Date_Other__c":data.Expiration_Date_Other__c,
                    "Programs_Claims_Other__c":data.Programs_Claims_Other__c,
                    "Verification_Type_Other__c":data.Verification_Type_Other__c,
                    "Renewal_Schedule_Umbrella__c":data.Renewal_Schedule_Umbrella__c,
                    "Cloned_From_Id__c":data.Id
                }
            });
            createAcountContactEvent.fire();
        });
        
        $A.enqueueAction(action);
        
    },
})