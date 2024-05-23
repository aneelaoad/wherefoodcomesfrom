public class GroupButtonsController {
    @AuraEnabled
    public static ID newShippingCertificate(String recordId){
        
        Id NewShippingCertficateRecordTypeId = Schema.SObjectType.Certificate__c.getRecordTypeInfosByName().get('Umbrella & Other Shipping').getRecordTypeId(); 
        
        String soqlQuery = 'SELECT  Id,Name, Opportunity__c,Programs_Claims__c,Customer_Type__c,Source_of_Origin_ID__c FROM  Group__c  WHERE ID = \'' + recordId +'\'' ;
        System.debug('soqlQuery '+soqlQuery);
        
        Group__c record = Database.query(soqlQuery);
        System.debug('record '+record);
        
        Certificate__c NewCert = new Certificate__c();
        
        newCert.RecordTypeId = NewShippingCertficateRecordTypeId;
        newCert.Opportunity_Name__c = record.Opportunity__c;
        System.debug('Record'+ record.Name);
        if((record.Name).length() >=68){
            record.Name=  record.Name.substring(0,68);
        }
        NewCert.Name = record.Name + ' Certificate';
        
        
        NewCert.Group__c = record.id;
        NewCert.Customer_Type_Label__c  = record.Customer_Type__c;
        NewCert.IsUmbrellaOROtherJS__c = true;
        NewCert.Source_of_Origin__c = record.Source_of_Origin_ID__c;
        string ProgramsClaims = record.Programs_Claims__c;
        
        if(ProgramsClaims !='' && ProgramsClaims !=null){
            system.debug('record.Programs_Claims__c: '+ProgramsClaims);
            NewCert.groupUmbrellaClaimsAll__c  = ProgramsClaims.replace(';','\n');
            
            system.debug('umbrellaProgramsAll__c: '+NewCert.umbrellaProgramsAll__c);
        }
        
        
        
        Database.insert(NewCert);
        system.debug(NewCert);
        return newCert.Id;
    }
    
}