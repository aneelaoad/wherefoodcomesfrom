({
    
    doInit: function(component) {
        
        var action = component.get("c.cloneAmericanGrown");
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
            createAcountContactEvent.setParams({
                "entityApiName": "Opportunity",
                "recordTypeId": "01236000000o29fAAA",
                "defaultFieldValues": {
                    "Name" : data.Name,
                    "Other_Products_to_Verify__c": data.Other_Products_to_Verify__c,
                    "AccountId" :data.AccountId,
                    "Notes_Umbrella__c":data.Notes_Umbrella__c,
                    "Stage_of_Work_American_Grown__c":data.Stage_of_Work_American_Grown__c,
                    "StageName":"Renewal",
                    "CloseDate":data.earliestExpirationDate__c,
                    "isCloneAmericanGrown__c":false,
                    "CVS_Assigned_Users_AG__c":data.CVS_Assigned_Users_AG__c
                    
                    
                }
            });
            createAcountContactEvent.fire();
        });
        
        $A.enqueueAction(action);
        
    },
})