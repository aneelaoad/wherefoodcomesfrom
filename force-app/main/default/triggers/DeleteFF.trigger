trigger DeleteFF on Feeder_farm__c(after insert) {
    Set<Id> lstId = new Set<Id>();
    
    for(Feeder_Farm__c ff: Trigger.new){
        if(String.isBlank(ff.Legal_Name_of_Feeder_Farm__c)){
            lstId.add(ff.id);
        }  
        
    } 
    List<Feeder_Farm__c> existFFList = [Select Id from Feeder_Farm__c where ID in :lstId];
    delete existFFList;
    
}