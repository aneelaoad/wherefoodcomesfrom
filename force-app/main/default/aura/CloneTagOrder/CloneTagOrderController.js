({
   
    //Confirm 
    handleConfirm : function(component, event, helper) {
        //Find lightning flow from component
        var flow = component.find("TagOrderFlow");
        //Put input variable values
        var inputVariables = [
            {
                name : "tagOrderID",
                type : "String",
                value : component.get("v.recordId")
            }
        ];
        //Reference flow's Unique Name
        flow.startFlow("Clone_Tag_Order", inputVariables);
    },
     
    //Close the quick action
    handleClose : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
     
    //Flow Status Change
    statusChange : function (component, event, helper) {
        //Check Flow Status
        if (event.getParam('status') === "FINISHED_SCREEN" || event.getParam('status') === "FINISHED") {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Success!",
                message: "Prescription was cloned Successfully!",
                type: "success"
                });
            toastEvent.fire();
            $A.get("e.force:closeQuickAction").fire();
            $A.get('e.force:refreshView').fire();
            var urlEvent = $A.get("e.force:navigateToURL");
             urlEvent.setParams({
                      "url": "/lightning/o/Tag_Order__c/list?filterName=Recent"
                       });
             urlEvent.fire();

   
        } else if (event.getParam('status') === "ERROR") {
            component.set("v.hasError", true);
        }
    }
})