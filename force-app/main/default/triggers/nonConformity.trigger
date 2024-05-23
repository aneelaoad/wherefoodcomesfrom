/*
Modified by:Rizwan Ali
Modification Date: 23/9/2019
Purpose: To send NC Due email notification when it's due
 */

trigger nonConformity on Verification_Report__c (before update) {
    
    Set<Id> lstId = new Set<Id>();
    List<Verification_Report__c> reportsToUpdate = new List<Verification_Report__c>();
    Set<Id> SetofNCDueIDs = new Set<Id>();
    
    //If corrective action required date is within 7 days, add to reports to update
    for(Verification_Report__c vr: Trigger.new){
        if(vr.Send_NC_Notice__c == true){  
            lstId.add(vr.Id);  
            reportsToUpdate.add(vr);
        }
        
          if(vr.Send_NC_Due_Notice__c == true){  
            SetofNCDueIDs.add(vr.Id);  
            reportsToUpdate.add(vr);
        }        
    } 
    
    if(lstId.size() > 0 || SetofNCDueIDs.size() > 0){
        //Get list of all non conformities related to the reports that caused this trigger (we need to do it this way to bulkify the code)
        List<Non_Conformity__c> lstnc = [Select Id, NC_Description__c, NC_Identified_Standard_Number__c, Note__c, Verification_Report__c 
                                         FROM Non_Conformity__c 
                                         WHERE (Verification_Report__c IN :lstId OR Verification_Report__c IN :SetofNCDueIDs)
                                         AND (NC_Clearance__c = 'No' OR NC_Clearance__c = null)];
        
        //Map all conformaties to their appropriate report 
        Map<ID, List<Non_Conformity__c>> verReportToNonCons = new Map<ID, List<Non_Conformity__c>>();
        for(Non_Conformity__c nonC : lstNc){
            if(verReportToNonCons.get(nonC.Verification_Report__c) == null){
                List<Non_Conformity__c> newList = new List<Non_Conformity__c>();
                newList.add(nonC);
                verReportToNonCons.put(nonC.Verification_Report__c, newList);
            } else {
                List<Non_Conformity__c> oldList = verReportToNonCons.get(nonC.Verification_Report__c);
                oldList.add(nonC);
                verReportToNonCons.put(nonC.Verification_Report__c, oldList);
            }
        }
        
        //Loop through and Update report fields
        for(Verification_Report__c report : reportsToUpdate){
            List<Non_Conformity__c> nonCons = verReportToNonCons.get(report.Id);
            
            if(nonCons != null){
            if(nonCons.size() > 0){
            
            
               //report.Send_NC_Notice__c = true; 
               if (SetofNCDueIDs.contains(report.Id)) 
               {
               //SetofNCDueIDs 
                //report.Send_NC_Due_Notice__c= true;
               } 
               else
               { 
                 //lstId
                 //report.Send_NC_Notice__c = true; 
               }
               
                Integer i = 1;
                for(Non_Conformity__c nonCon : nonCons){                
                    if(i==1){
                        report.ncDescription1__c = nonCon.NC_Description__c;
                        report.ncIdentified1__c = nonCon.NC_Identified_Standard_Number__c;
                        report.correctiveAction1__c = nonCon.Note__c;
                    } else if(i==2){
                        report.ncDescription2__c = nonCon.NC_Description__c;
                        report.ncIdentified2__c = nonCon.NC_Identified_Standard_Number__c;
                        report.correctiveAction2__c = nonCon.Note__c;
                    } else if(i==3){
                        report.ncDescription3__c = nonCon.NC_Description__c;
                        report.ncIdentified3__c = nonCon.NC_Identified_Standard_Number__c;
                        report.correctiveAction3__c = nonCon.Note__c;
                    } else if(i==4){
                        report.ncDescription4__c = nonCon.NC_Description__c;
                        report.ncIdentified4__c = nonCon.NC_Identified_Standard_Number__c;
                        report.correctiveAction4__c = nonCon.Note__c;
                    } else if(i==5){
                        report.ncDescription5__c = nonCon.NC_Description__c;
                        report.ncIdentified5__c = nonCon.NC_Identified_Standard_Number__c;
                        report.correctiveAction5__c = nonCon.Note__c;
                    } else if(i==6){
                        report.ncDescription6__c = nonCon.NC_Description__c;
                        report.ncIdentified6__c = nonCon.NC_Identified_Standard_Number__c;
                        report.correctiveAction6__c = nonCon.Note__c;
                    } else if(i==7){
                        report.ncDescription7__c = nonCon.NC_Description__c;
                        report.ncIdentified7__c = nonCon.NC_Identified_Standard_Number__c;
                        report.correctiveAction7__c = nonCon.Note__c;
                    } else if(i==8){
                        report.ncDescription8__c = nonCon.NC_Description__c;
                        report.ncIdentified8__c = nonCon.NC_Identified_Standard_Number__c;
                        report.correctiveAction8__c = nonCon.Note__c;
                    } else if(i==9){
                        report.ncDescription9__c = nonCon.NC_Description__c;
                        report.ncIdentified9__c = nonCon.NC_Identified_Standard_Number__c;
                        report.correctiveAction9__c = nonCon.Note__c;
                    } else if(i==10){
                        report.ncDescription10__c = nonCon.NC_Description__c;
                        report.ncIdentified10__c = nonCon.NC_Identified_Standard_Number__c;
                        report.correctiveAction10__c = nonCon.Note__c;
                    }
                    
                    i++;
                }
            }
          }   
        }    
        
    }
    
}