public class mycustfeedbkExtension2 {    
    public mycustfeedbkExtension2(ApexPages.StandardController controller) {
        
    }
    
    public string nam {get;set;}
    public string acct {get;set;}
    public string cont {get;set;}
    public string serv {get;set;}
    public string comm {get;set;}
    public string cond {get;set;}
    public string over {get;set;}
    public string feed {get;set;}
    public string AccountInput {get;set;}
    
    public Pagereference doInsert(){
        Customer_Feedback__c objcfb = new Customer_Feedback__c();
        //Account a = [SELECT Id, Name FROM Account WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
        List<Account> accounts = [SELECT Id, Name FROM Account WHERE Name = :AccountInput];
        Account a = accounts[0];
        acct = a.id;
        
        Date dat = System.today();  
        integer yr = dat.year();
        integer mo = dat.month();
        integer da = dat.day();
        nam = a.Name + ' ' + mo + ' ' + da + ' ' + yr;
        objcfb.Name=nam;
        objcfb.Follow_Up_Needed__c=cont;
        objcfb.Feedback_Postcard_Received__c='Submitted Online';
        objcfb.Quality_of_Service_Received__c=serv;
        objcfb.Frequency_of_Communication_with_Customer__c=comm;
        objcfb.Timeliness_in_Conducting_Verification__c=cond;
        objcfb.Overall_Experience__c=over;
        objcfb.Feedback_Details__c=feed;
        objcfb.Account__c=acct;
        insert objcfb;
        
        
        pagereference ref = new pagereference('/apex/ThankYou?feedb='+feed+'&acct='+a.Name+'&cont='+cont+'&serv='+serv+'&comm='+comm+'&cond='+cond+'&over='+over+'&feed='+feed);
        
        return ref.setredirect(true);
        
    }
    
    
    
}