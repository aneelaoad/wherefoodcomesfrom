public class skedTestDataFactory {

    /*
    * Initializes a list of Account
    */
    public static List<Account> createAccounts(String basename, Integer count){
        List<Account> accountList = new List<Account>();
        for( Integer i=0; i< count; i++ ){
            Account account = new Account(   
                                            Name = 'Account ' + String.valueOf(i)
                                        ) ;
			accountList.add( account);
        }
        return accountList;
    }
    
    /*
    * Initializes a list of Account
    */
    public static List<Opportunity> createOpportunity(String basename, Id accountId, Integer count){
        List<Opportunity> oList = new List<Opportunity>();
        for( Integer i=0; i< count; i++ ){
            Opportunity opp = new Opportunity(   
                                            Name = basename + String.valueOf(i),
                							AccountId 	= accountId,
                							StageName	= 'Upgrade',
                							CloseDate	= System.today()
                                        ) ;
			oList.add( opp);
        }
        return oList;
    }
    
    /*
    * Initializes a list of Resource
    */
    public static List<sked__Resource__c> createResources(List<User> users){
       List<sked__Resource__c> rList = new List<sked__Resource__c>();
        for( User user : users){
            rList.add( new sked__Resource__c(     
                                        sked__User__c = user.Id,
                                        Name = user.Name
                                        ) );
        }
        return rList;
    }
    
    /*
    * Initializes a list of Region
    */
    public static List<sked__Region__c> createRegions(String basename, Integer count){
       List<sked__Region__c> regionList = new List<sked__Region__c>();
        for( Integer i=0; i< count; i++ ){
            String name = i==0? basename : (basename + String.valueOf(i));
            regionList.add( new sked__Region__c(     
                                        Name                    = name,
                                        sked__Timezone__c       = 'US/Pacific',
                                        sked__Country_Code__c   = 'US'
                                        ) );
        }
        return regionList;
    }
    
    /*
    * Initializes a list of Job
    */
    public static List<sked__Job__c> createJobs(Id accountId, Id regionId, Integer count){
       List<sked__Job__c> records = new List<sked__Job__c>();
        for( Integer i=0; i< count; i++ ){
            records.add( new sked__Job__c(     
                                        	sked__Account__c       = accountId,
                                        	sked__Region__c        = regionId,
                							sked__Duration__c		= 60
                                        ) );
        }
        return records;
    }
    
    /*
    * Initializes a list of Job
    */
    public static List<sked__Job_Allocation__c> createJobAllocations(Id jobId,Id resourceId, Integer count){
       List<sked__Job_Allocation__c> records = new List<sked__Job_Allocation__c>();
        for( Integer i=0; i< count; i++ ){
            records.add( new sked__Job_Allocation__c(     
                                        	sked__Job__c        = jobId,
                                        	sked__Resource__c   = resourceId
                                        ) );
        }
        return records;
    }
}