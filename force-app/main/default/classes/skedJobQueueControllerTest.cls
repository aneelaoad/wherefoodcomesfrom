@isTest
private class skedJobQueueControllerTest {
	
    private static Map<String, list<sObject>> objectMap = new Map<String,list<sObject>>();
    
    @testSetup static void setupTestData() {
        SMS_Template__c setting  = new SMS_Template__c();
        setting.Dispatch_SMS__c = 'New [JOBNAME]. [JOBADDRESS]. For [ACCOUNT], [JOBDURATION] minutes';
        insert setting;
        
        Authentication_Setting__c settingObj = new Authentication_Setting__c(
        	Name = 'AuthenticationSetting',
            Token_Type__c = 'Bearer',
            Expires_In__c = 86400,
            Access_Token__c = '5za2VkdWxvLmNvbS91c2VybmFtZSI6ImNzYW5',
            Client_Id__c = '123',
            Client_Secret__c = '123',
            Audience__c = 'https://api.skedulo.com',
            Grant_Type__c = 'client_credentials',
            Auth_Endpoint__c = 'https://skedulo.auth0.com/oauth/token',
            Expires_On__c = System.now().addDays(2)
        );
        insert settingObj;

        Account account = (Account)skedTestDataFactoryBase.createSObject('Account', true);

        Opportunity opp = (Opportunity)skedTestDataFactoryBase.createSObject('Opportunity', new Map<String, Object>{
                'AccountId' => account.Id,
                'CloseDate' => System.today()
            }, true);
        /*
        List<User> users = skedTestDataFactory.createUser( 'Test', null, 1);
        insert users;
        */
        list<User> users = [Select Id, Name from User where id=:UserInfo.getUserId()];                
        
        sked__Region__c region = (sked__Region__c)skedTestDataFactoryBase.createSObject('sked__Region__c', true);

        sked__Resource__c resource = (sked__Resource__c)skedTestDataFactoryBase.createSObject('sked__Resource__c', new Map<String, Object>{
                'sked__User__c' => UserInfo.getUserId(),
                'sked__Primary_Region__c' => region.Id
            }, true);
        
        sked__Job__c job = (sked__Job__c)skedTestDataFactoryBase.createSObject('sked__Job__c', new Map<String, Object>{
                'sked__Account__c'  => account.Id,
                'sked__Region__c'   => region.Id,
                'sked__Duration__c' => 120,
                'Opportunity__c'    => opp.Id,
                'GAP_Programs_and_Claims__c' => 'GAP Step 1',
                'Other_Programs_and__c'         => '100% Vegetarian Fed',
                'Umbrella_Programs_and_Claims__c'   => '100% Vegetarian Fed',
                'sked__Address__c'  => '79 mclachlan fortitude valley Brisbane qld'
            }, true);
        
         sked__Job_Allocation__c jobAllocation = (sked__Job_Allocation__c)skedTestDataFactoryBase.createSObject('sked__Job_Allocation__c', new Map<String, Object>{
                'sked__Job__c'      => job.Id,
                'sked__Resource__c' => resource.Id,
                'sked__Status__c'   => 'Pending Dispatch'
            }, true);
    }
    
	@isTest
    private static void testController(){
        skedJobQueueController controller = new skedJobQueueController();
        skedJobQueueController.getJobs();
        controller.getStartEndTime();
        Id jobId = [Select Id from sked__Job__c limit 1].Id;
        skedJobQueueController.scheduleJob(jobId, 'Mon,1/1/2020', '8:30', '9:30');
    }

	@isTest
    private static void test_skedJobTrigger(){
        sked__Job__c job = [Select Id from sked__Job__c limit 1];
        job.Reschedule_Date__c = System.now();
        job.Reschedule_Duration_Mins__c = 1;
        update job;
    }    
}