trigger VRProgramReminderTrg on Verification_Report__c (before insert, before update) {
    if(trigger.isUpdate && trigger.isBefore){
        
        Map<Id,Verification_Report__c> oMap = new Map<Id,Verification_Report__c>();
        
        oMap = trigger.oldMap;
        
        for(Verification_Report__c vr : Trigger.New) {
            Verification_Report__c oldVr = new Verification_Report__c();
            oldVr = oMap.get(vr.Id);
            if(oldVr.Program_Reminders__c != vr.Program_Reminders__c){
                if(vr.Program_Reminders__c == 'Ranch')
                {
                    vr.Program_Reminders_Notes__c = '• All operations evaluated for the Verified Natural Beef program will also be evaluated to the Veg-Fed claim. To be approved for Veg-Fed, program cattle cannot be exposed to whey, milk products, egg proteins, egg by-products, animal derived fats or fish-based products/oils post-weaning.'+'\n' 
                        +'• Program calves should only have ONE EID tag when leaving your operation. Program cattle should NEVER be double tagged with EIDs. If your vet plans to use 840 BANGs EID tags instead of metal clip tags, please submit the 840 BANGs EID numbers to IMI for allocation.'+'\n'+ 
                        +'• Note that physical ID and written records are required for each treated calf. Animals that receive antibiotics or are given non-compliant milk replacer could be considered treated animals. Treats may drop down to NHTC-SAV, so please turn EID #s into IMI for proper allocation before shipping.'+'\n'
                        +'• Reminder to keep updated documents on file for training, calving records, head count support, hormones, antibiotics and treatments, feed labels, feed letters (current within 2 years), evidence of onsite vet visits (required starting 2023), Leftover Tag Inventory Report and shipping documents.'+'\n';
                }
                if(vr.Program_Reminders__c == 'Backgrounder')
                {
                    vr.Program_Reminders_Notes__c = '• Records for outside cattle must be kept in lot files and should include ranch approval documents, receiving/processing report (which includes ear palpation, reading EID tags and animal health products administered during processing), treatment/disqualified animals records, tag look up report (from BeefPassport), feed information and all shipping documents.'+'\n' 
                        +'• Use the tag lookup in Beef Passport to request shipping documents. Once approved, please print and send copies of the completed Backgrounder Group Approval Shipping Certificate to the receiver and retain a copy with your records. Instructions may be found in the Beef Passport How to Guide located in the Resources tab on your Beef Passport Dashboard.'+'\n'+ 
                        +'• NHTC feed letters are required to be updated every 2 years.'+'\n'
                        +'• Starting in 2023, NHTC-approved locations with home-raised cattle will need to show proof an annual vet visit.'+'\n'
                        +'• Treated VNB animals can be downgraded to NHTC or removed from the programs. If you downgrade an animal, you must notify your CVS of the EID number.';
                }
                if(vr.Program_Reminders__c == 'Feedlot')
                {
                    vr.Program_Reminders_Notes__c = '• Records for outside cattle must be kept in lot files and should include ranch approval documents, receiving/processing report (which includes ear palpation, reading EID tags and animal health products administered during processing), treatment/disqualified animals records, tag look up report (from BeefPassport), feed information and all shipping documents.'+'\n' 
                        +'• Shipping documents must be acquired using the Right-to-Ship and Shipment Load process on BeefPassport. Please ensure any EID-visual ID cross-reference information, IMI and non-IMI group approval documents and other supporting documents are uploaded during the Right-to-Ship step.'+'\n'+ 
                        +'• NHTC feed letters will need to be updated every 2 years.'+'\n'
                        +'• Starting in 2023, NHTC-approved locations with home-raised cattle will need to show proof an annual vet visit.'+'\n'
                        +'• Treated VNB animals can be downgraded to NHTC or removed from the programs. If you downgrade an animal, you must notify your CVS of the EID number.';
                }
                if(vr.Program_Reminders__c == 'Salesbarn')
                {
                    vr.Program_Reminders_Notes__c = '• Records for outside cattle must be kept in lot files and should include ranch approval documents, receiving/processing report (which includes ear palpation, reading EID tags and any animal health products administered during processing), treatment/disqualified animals records, tag look up report (from BeefPassport), and all shipping documents.'+'\n' 
                        +'• When shipping cattle, send a  copy tag look up report, a copy of the original ranch documents,  a completed salebarn record (must use template in the manual).'+'\n'+ 
                        +'• NHTC feed letters will need to be updated every 2 years.';
                }
                if(vr.Program_Reminders__c == 'Calf Ranch')
                {
                    vr.Program_Reminders_Notes__c = '• For calves picked up from outside sources, the birth date must be based on the previous pick-up date at a minimum (e.g., daily route =1 day less than pick-up date, Monday pick-ups = 7 days less than the pick-up date) unless actual birth date information is reported by the source dairy.'+'\n' 
                        +'• Remember to use the new Beef Passport online certificate building system to create an official shipping certificate and tag manifest to enroll calves into your approved programs. Create your shipping documents as you ship program approved calves.'+'\n'+ 
                        +'• If you participate in the Vegetarian Fed and/or Saudi Arabia EV verification programs, carefully review your feed labels to ensure no animal by-products or fat (e.g., yellow grease, glycerin, collagen, etc.) are fed to weaned calves in the grow pens. Please report any feed changes that would impact your eligibility in the Vegetarian Fed and/or Saudi Arabia EV programs.'+'\n'
                        +'• NHTC Letters of Guarantee are valid for two years.';
                    
                }
                if(vr.Program_Reminders__c == 'Ranch - BeefCARE SAV')
                {
                    vr.Program_Reminders_Notes__c = '• Program calves should only have ONE EID tag when leaving your operation. Program cattle should NEVER be double tagged with EIDs. If your vet plans to use 840 BANGs EID tags instead of metal clip tags, please submit the 840 BANGs EID numbers to IMI for allocation.'+'\n' 
                        +'• Reminder to keep updated documents on file for training, calving records, head count support, hormones, Leftover Tag Inventory Report and shipping documents.'+'\n';
                    
                }
            }   
        }
    }
    
    
    if(trigger.isInsert && trigger.isBefore){
        for(Verification_Report__c vr : Trigger.New){
            if(vr.Program_Reminders__c == 'Ranch')
            {
                vr.Program_Reminders_Notes__c = '• All operations evaluated for the Verified Natural Beef program will also be evaluated to the Veg-Fed claim. To be approved for Veg-Fed, program cattle cannot be exposed to whey, milk products, egg proteins, egg by-products, animal derived fats or fish-based products/oils post-weaning.'+'\n' 
                    +'• Program calves should only have ONE EID tag when leaving your operation. Program cattle should NEVER be double tagged with EIDs. If your vet plans to use 840 BANGs EID tags instead of metal clip tags, please submit the 840 BANGs EID numbers to IMI for allocation.'+'\n'+ 
                    +'• Note that physical ID and written records are required for each treated calf. Animals that receive antibiotics or are given non-compliant milk replacer could be considered treated animals. Treats may drop down to NHTC-SAV, so please turn EID #s into IMI for proper allocation before shipping.'+'\n'
                    +'• Reminder to keep updated documents on file for training, calving records, head count support, hormones, antibiotics and treatments, feed labels, feed letters (current within 2 years), evidence of onsite vet visits (required starting 2023), Leftover Tag Inventory Report and shipping documents.'+'\n';
            }
            if(vr.Program_Reminders__c == 'Backgrounder')
            {
                vr.Program_Reminders_Notes__c = '• Records for outside cattle must be kept in lot files and should include ranch approval documents, receiving/processing report (which includes ear palpation, reading EID tags and animal health products administered during processing), treatment/disqualified animals records, tag look up report (from BeefPassport), feed information and all shipping documents.'+'\n' 
                    +'• Use the tag lookup in Beef Passport to request shipping documents. Once approved, please print and send copies of the completed Backgrounder Group Approval Shipping Certificate to the receiver and retain a copy with your records. Instructions may be found in the Beef Passport How to Guide located in the Resources tab on your Beef Passport Dashboard.'+'\n'+ 
                    +'• NHTC feed letters are required to be updated every 2 years.'+'\n'
                    +'• Starting in 2023, NHTC-approved locations with home-raised cattle will need to show proof an annual vet visit.'+'\n'
                    +'• Treated VNB animals can be downgraded to NHTC or removed from the programs. If you downgrade an animal, you must notify your CVS of the EID number.';
            }
            if(vr.Program_Reminders__c == 'Feedlot')
            {
                vr.Program_Reminders_Notes__c = '• Records for outside cattle must be kept in lot files and should include ranch approval documents, receiving/processing report (which includes ear palpation, reading EID tags and animal health products administered during processing), treatment/disqualified animals records, tag look up report (from BeefPassport), feed information and all shipping documents.'+'\n' 
                    +'• Shipping documents must be acquired using the Right-to-Ship and Shipment Load process on BeefPassport. Please ensure any EID-visual ID cross-reference information, IMI and non-IMI group approval documents and other supporting documents are uploaded during the Right-to-Ship step.'+'\n'+ 
                    +'• NHTC feed letters will need to be updated every 2 years.'+'\n'
                    +'• Starting in 2023, NHTC-approved locations with home-raised cattle will need to show proof an annual vet visit.'+'\n'
                    +'• Treated VNB animals can be downgraded to NHTC or removed from the programs. If you downgrade an animal, you must notify your CVS of the EID number.';
            }
            if(vr.Program_Reminders__c == 'Salesbarn')
            {
                vr.Program_Reminders_Notes__c = '• Records for outside cattle must be kept in lot files and should include ranch approval documents, receiving/processing report (which includes ear palpation, reading EID tags and any animal health products administered during processing), treatment/disqualified animals records, tag look up report (from BeefPassport), and all shipping documents.'+'\n' 
                    +'• When shipping cattle, send a  copy tag look up report, a copy of the original ranch documents,  a completed salebarn record (must use template in the manual).'+'\n'+ 
                    +'• NHTC feed letters will need to be updated every 2 years.';
            }
            if(vr.Program_Reminders__c == 'Calf Ranch')
            {
                vr.Program_Reminders_Notes__c = '• For calves picked up from outside sources, the birth date must be based on the previous pick-up date at a minimum (e.g., daily route =1 day less than pick-up date, Monday pick-ups = 7 days less than the pick-up date) unless actual birth date information is reported by the source dairy.'+'\n' 
                    +'• Remember to use the new Beef Passport online certificate building system to create an official shipping certificate and tag manifest to enroll calves into your approved programs. Create your shipping documents as you ship program approved calves.'+'\n'+ 
                    +'• If you participate in the Vegetarian Fed and/or Saudi Arabia EV verification programs, carefully review your feed labels to ensure no animal by-products or fat (e.g., yellow grease, glycerin, collagen, etc.) are fed to weaned calves in the grow pens. Please report any feed changes that would impact your eligibility in the Vegetarian Fed and/or Saudi Arabia EV programs.'+'\n'
                    +'• NHTC Letters of Guarantee are valid for two years.';
                
            }
            if(vr.Program_Reminders__c == 'Ranch - BeefCARE SAV')
            {
                vr.Program_Reminders_Notes__c = '• Program calves should only have ONE EID tag when leaving your operation. Program cattle should NEVER be double tagged with EIDs. If your vet plans to use 840 BANGs EID tags instead of metal clip tags, please submit the 840 BANGs EID numbers to IMI for allocation.'+'\n' 
                    +'• Reminder to keep updated documents on file for training, calving records, head count support, hormones, Leftover Tag Inventory Report and shipping documents.'+'\n';
                
            }
        }
    }
    
    
}