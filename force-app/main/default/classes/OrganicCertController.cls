public with sharing class OrganicCertController {

    

    @AuraEnabled    
    public static List<account_products__c> getCert(String currentRecordId) {        
        string accountId = [select id,AccountID__c  from Certificate__c where id = :currentRecordId limit 1 ].AccountID__c;
        return [SELECT id,Product__c,Customer_Type__c,Product_status__c,Standard__c,ID_Mark__c ,is_Selected__c, CreatedDate from account_products__c WHERE Account__c =: accountId ORDER BY ID_Mark__c DESC];
    }

    @AuraEnabled
    public static String updateCertSelected(List<String> certToUpdate){
      try{
        //then update selected records;
        System.debug('updateCertSelected'+certToUpdate);
        List<account_products__c> selectAccountProducts = [SELECT id,Product__c,Customer_Type__c,Product_status__c,Standard__c,ID_Mark__c ,is_Selected__c, CreatedDate  from account_products__c WHERE ID IN:certToUpdate ];
        System.debug('selectAccountProducts:\n'+selectAccountProducts);
        List<account_products__c> toUpdate = new List<account_products__c>();
        for(account_products__c ap:  selectAccountProducts){
            ap.is_Selected__c = TRUE;
            toUpdate.add(ap);            
        }
        System.debug('toUpdate\n'+toUpdate);
        update toUpdate;
        return 'true';
      }catch(Exception e){
          return e.getmessage();
      }
    }


    @AuraEnabled
    public static String updateCertUnSelected(List<String> certToUpdate){
      try{
        //Update unselected records 
        System.debug('updateCertUnSelected'+certToUpdate);
        List<account_products__c> unselectAccountProducts = [SELECT id,Product__c,Customer_Type__c,Product_status__c,Standard__c,ID_Mark__c ,is_Selected__c, CreatedDate  from account_products__c WHERE ID NOT IN:certToUpdate];
        List<account_products__c> toUpdate = new List<account_products__c>();
        for(account_products__c ap:  unselectAccountProducts){
            ap.is_Selected__c = FALSE;
            toUpdate.add(ap);
        }
        update toUpdate;      
        return 'true';
      }catch(Exception e){
          return e.getmessage();
      }
    }
    

    @AuraEnabled
    public static string getDocumentId(String currentRecordId){
        Certificate__c c = [SELECT Id, RecordTypeId FROM Certificate__c WHERE Id =: currentRecordId];
        String currentRecordTypeId = c.RecordTypeId;
       if(currentRecordTypeId == Schema.SObjectType.certificate__c.getRecordTypeInfosByName().get('A Bee Organic').getRecordTypeId()){  
           System.debug('A Bee Organic');          
            return 'a2L1R000002rEwkUAE';
        }
        else if(currentRecordTypeId == Schema.SObjectType.certificate__c.getRecordTypeInfosByName().get('WFCF Organic').getRecordTypeId()){
            System.debug('WFCF Organic');    
            return 'a2L630000010qDqEAI';
        }
        else if(currentRecordTypeId == Schema.SObjectType.certificate__c.getRecordTypeInfosByName().get('ICS').getRecordTypeId()){
            System.debug('ICS');    
            return 'a2L1R000002DgX0UAK';
        }
        system.debug('Nothing');
        return '';
    }
}