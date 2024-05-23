public class OpportunityButtonsConversion {
    
    //Create new Umbrella Certificate
    @AuraEnabled
    public static ID newUmberellaCertficate(String recordId){
        
        Id NewUmberellaCertficateRecordTypeId = Schema.SObjectType.Certificate__c.getRecordTypeInfosByName().get('Umbrella & Other').getRecordTypeId(); 
        
        String soqlQuery = 'SELECT  Id  , Name,Programs_Claims_Umbrella__c FROM  opportunity  WHERE ID = \'' + recordId +'\'' ;
        System.debug('soqlQuery '+soqlQuery);
        
        Opportunity record = Database.query(soqlQuery);
        System.debug('record '+record);
        
        Certificate__c NewCert = new Certificate__c();
        NewCert.Opportunity_Name__c = Record.Id;
        NewCert.Name = record.Name + ' Certificate';
        
        if((NewCert.Name).length() >=68){
            NewCert.Name=  NewCert.Name.substring(0,68);
        }
        
        NewCert.Scope_of_Work__c = 'Umbrella';
        NewCert.IsUmbrellaOROtherJS__c = true;
        
        string ProgramsClaimsUmbrella = record.Programs_Claims_Umbrella__c;
        
        if(ProgramsClaimsUmbrella !='' && ProgramsClaimsUmbrella !=null){
            system.debug('record.Programs_Claims_Umbrella__c: '+ProgramsClaimsUmbrella);
            NewCert.umbrellaProgramsAll__c = ProgramsClaimsUmbrella.replace(';','\n');
            
            system.debug('umbrellaProgramsAll__c: '+NewCert.umbrellaProgramsAll__c);
        }
        
        newCert.RecordTypeId = NewUmberellaCertficateRecordTypeId;
        
        Database.insert(NewCert);
        system.debug(NewCert);
        return newCert.Id;
    }
    
    //Create new Other Certificate
    @AuraEnabled
    public static ID newOtherCertficate(String recordId){
        
        Id NewOtherCertficateRecordTypeId = Schema.SObjectType.Certificate__c.getRecordTypeInfosByName().get('Umbrella & Other').getRecordTypeId(); 
        
        String soqlQuery = 'SELECT  Id  , Name,Programs_Claims_Other__c FROM  opportunity  WHERE ID = \'' + recordId +'\'' ;
        System.debug('soqlQuery '+soqlQuery);
        
        Opportunity record = Database.query(soqlQuery);
        System.debug('record '+record);
        
        Certificate__c NewCert = new Certificate__c();
        NewCert.Opportunity_Name__c = Record.Id;
        NewCert.Name = record.Name + ' Certificate';
        
        if((NewCert.Name).length() >=68){
            NewCert.Name=  NewCert.Name.substring(0,68);
        }
        
        NewCert.Scope_of_Work__c = 'Other';
        NewCert.IsUmbrellaOROtherJS__c = true;
        string ProgramsClaimsOther = record.Programs_Claims_Other__c;
        
        if(ProgramsClaimsOther !='' && ProgramsClaimsOther !=null){
            NewCert.OtherProgramsAll__c = ProgramsClaimsOther.replace(';','\n');
        } 
        
        if(record.Programs_Claims_Other__c  !='' && record.Programs_Claims_Other__c  !=null){
            NewCert.OtherProgramsAll__c  = record.Programs_Claims_Other__c.replace(';', '\n');
        }
        
        newCert.RecordTypeId = NewOtherCertficateRecordTypeId;
        
        Database.insert(NewCert);
        system.debug(NewCert);
        return newCert.Id;
    }
    
    //Create new Group
    @AuraEnabled
    public static ID newGroup(String recordId){
        
        String soqlQuery = 'SELECT  Id  , Name,primaryContactID__c,Customer_Type__c,Estimate_Ship_Date__c,Programs_Claims_GAP__c,Programs_Claims_Other__c,Programs_Claims_Umbrella__c,Ranch_Brand_s__c FROM  opportunity  WHERE ID = \'' + recordId +'\'' ;
        System.debug('soqlQuery '+soqlQuery);
        
        Opportunity record = Database.query(soqlQuery);
        System.debug('record '+record);
        
        if((record.Name).length() >=74){
            record.Name=  record.Name.substring(0,74);
        }
        
        Group__c NewGroupobj = new Group__c();
        NewGroupobj.Name = record.Name + ' Group';
        NewGroupobj.Contact__c  = record.primaryContactID__c;
        NewGroupobj.Customer_Type__c = record.Customer_Type__c;
        NewGroupobj.Source_of_Origin_ID__c = record.Ranch_Brand_s__c;
        newGroupobj.Opportunity__c = recordId;
        
        if(record.Estimate_Ship_Date__c == null){
            //do nothing
        }
        else{
            NewGroupobj.Estimate_Ship_Date__c=  record.Estimate_Ship_Date__c;
        }
        
        String val1 = record.Programs_Claims_GAP__c;
        String val2 = record.Programs_Claims_Other__c;
        String val3 = record.Programs_Claims_Umbrella__c;
        
        String PAC = '';
        
        if(val1 != null && val1 != ''){
            PAC += val1+';';
        }
        
        if(val2 != null && val2 != ''){
            if(PAC.contains( 'China EV') && val2.contains('China EV')){
                
                PAC = PAC.substring(0, PAC.indexOf('China EV'));
                system.debug(PAC);
                
            }
            PAC += val2+';';
            
            
        }
        
        if(val3 != null && val3 != ''){
            
            if(PAC.contains( 'China EV') && val3.contains('China EV'))
            {
                
                PAC = PAC.substring(0, PAC.indexOf('China EV'));
                system.debug(PAC);
                
            }
            PAC += val3+';';
            
        }
        system.debug(PAC);
        
        if(PAC.contains('Source Verification') && PAC.contains('Age Verification') && PAC.contains('China EV') ==False){
            //PAC = PAC + 'China EV;';
        }
        
        NewGroupobj.Programs_Claims__c = PAC;
        
        Database.insert(NewGroupobj);
        system.debug(NewGroupobj);
        return NewGroupobj.Id;
    }
    
    //Create new American Grown Opportunity
    @AuraEnabled
    public static Opportunity cloneAmericanGrown(String recordId){
        
        Id AmericanGrownRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('American Grown').getRecordTypeId();
        
        String soqlQuery = 'SELECT  Id  , Name,Issue_date__c,CloseDate,earliestExpirationDate__c,isCloneAmericanGrown__c,RecordTypeId,AccountId,Other_Products_to_Verify__c,Notes_Umbrella__c,Stage_of_Work_American_Grown__c,CVS_Assigned_Users_AG__c FROM  opportunity  WHERE ID = \'' + recordId +'\'' ;
        System.debug('soqlQuery '+soqlQuery);
        
        Opportunity record = Database.query(soqlQuery);
        record.isCloneAmericanGrown__c = true;
        update record;
        
        return Record;
    }
    
    //Create new Opportunity
    @AuraEnabled
    public static Opportunity cloneOpportunityJS(String recordId){
        
        string ste = 'Name,Account.Id,Division__c,Customer_Type__c,Marketing_Program__c,Animal_Count__c,'+
            'One_Time_Capacity__c,Opportunity.earliestExpirationDate__c,Probability,CVS_Assigned_Users__c,CVS_Assigned__c,'+
            'ReviewerIfNotCVS_Users__c,Reviewer_if_not_CVS__c,Due_by_Date_GAP__c,Due_by_Date_Other__c,Due_by_Date_Umbrella__c,'+
            'Expiration_Date_Other__c,Expiration_Date_Umbrella__c,Verification_Type_Umbrella__c,Programs_Claims_GAP__c,'+
            'Programs_Claims_Umbrella__c,Expiration_Date_GAP__c,Multi_Site_Operation_Umbrella__c,Verification_Owner_Umbrella__c,'+
            'Release_Form_on_File__c,Estimate_Ship_Date__c,Programs_Claims_Other__c,Verification_Type_Other__c,Renewal_Schedule_Umbrella__c,Video_Rep__c';
        
        String soqlQuery = 'SELECT ' + ste +' FROM Opportunity WHERE ID = \'' + recordId +'\'' ;
        System.debug('soqlQuery'+soqlQuery);
        
        Opportunity record = Database.query(soqlQuery);
        record.hasBeenCloned__c = 'Yes';
        update record;
        System.debug('Record: '+Record);
        return Record;
    }
    
    //Create new Organic Opportunity
    @AuraEnabled
    public static Opportunity cloneOrganicOpportunity(String recordId){
        
        string ste = 'Name,Account.Id,Customer_Type__c,Initial_reviewer_user__c,X90_days_before_Anniversary__c,Physical_Address_Liner_Text__c,Final_reviewer_user__c,Anniversary_date__c';
        
        String soqlQuery = 'SELECT ' + ste +' FROM Opportunity WHERE ID = \'' + recordId +'\'' ;
        System.debug('soqlQuery'+soqlQuery);
        
        Opportunity record = Database.query(soqlQuery);
        record.hasBeenCloned__c = 'Yes';
        update record;
        return Record;
    }
    
    //Notify CVS file upload
    @AuraEnabled
    public static ID notifyCVSFileUpload(String recordId){
        
        opportunity opp = new opportunity(id = recordId);
        
        opp.notify_CVS_File_Upload__c = 'YES';
        update opp;
        return opp.id;
        
    }
    
    //Create new Tag Order
    @AuraEnabled
    public static string createTagOrder(String recordId){
        
        Opportunity opp = [SELECT ID,Name FROM Opportunity WHERE ID = :recordId LIMIT 1];
        List<Group__c> records =[select Name, Id FROM Group__c where Opportunity__c =:recordId Limit 3];
        string gid1 = null;
        string gid2 = null;
        string gid3 = null;
        string gnam1 = null;
        string gnam2 = null;
        string gnam3 = null;
        
        for (integer i=0; i < records.size(); i++) {
            Group__c record = records[i];
            if (i==0)
            {
                gid1 = record.Id;
                gnam1 = record.Name;
            }
            if (i==1)
            {
                gid2 = record.Id;
                gnam2 = record.Name;
            }
            if (i==2)
            {
                gid3 = record.Id;
                gnam3 = record.Name;
            }
        }
        
        string pageUrl = 'https://fs27.formsite.com/cgsanc01/form13/fill';
        string paramaters1 = '?id2='+ opp.id +'&id12='+ opp.Name + '&id13=' + gid1 + '&id15=' + gid2 + '&id17=' + gid3;
        string parameters2 = '&id14=' + gnam1 + '&id16=' + gnam2 + '&id18=' + gnam3 + '&';
        
        string link = pageUrl + paramaters1 + parameters2;
        return link;
        
    }
    
}