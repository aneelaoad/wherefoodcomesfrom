@isTest
private class skedCalendarViewController_Test {
	@testSetup static void setupData(){
		
		Account account = (Account)skedTestDataFactoryBase.createSObject('Account', true);

		Opportunity opp = (Opportunity)skedTestDataFactoryBase.createSObject('Opportunity', new Map<String, Object>{
				'AccountId' => account.Id,
				'CloseDate'	=> System.today()
			}, true);

		Contact contact = (Contact)skedTestDataFactoryBase.createSObject('Contact', new Map<String, Object>{
				'AccountId' => account.Id
			}, true);
		
		sked__Region__c region = (sked__Region__c)skedTestDataFactoryBase.createSObject('sked__Region__c', true);

		sked__Job__c job = (sked__Job__c)skedTestDataFactoryBase.createSObject('sked__Job__c', new Map<String, Object>{
				'sked__Contact__c' => contact.Id,
				'sked__Region__c'  => region.Id,
				'sked__Duration__c' => 120,
				'sked__Start__c' 	=> System.now().addHours(-1),
				'sked__Finish__c' 	=> System.now().addHours(1),
				'Opportunity__c' 	=> opp.Id,
				'sked__Address__c' 	=> '79 mclachlan fortitude valley Brisbane qld'
			}, true);
	}

	@isTest
	static void testController(){
		list<Account> accounts = [Select Id from Account];
		list<Contact> contacts = [Select Id, AccountId from Contact];
		list<Opportunity> opps = [Select Id, AccountId from Opportunity];
		System.assertEquals( accounts.size(), 1 );
		System.assertEquals( contacts.get(0).AccountId, accounts.get(0).Id );
		System.assertEquals( opps.get(0).AccountId, accounts.get(0).Id );

		Test.startTest();

		String startDate = System.now().addDays(-10).format('yyyy-MM-dd');
		String endDate = System.now().addDays(10).format('yyyy-MM-dd');
        
        String googleAPIKey = new skedCalendarViewController().googleAPIKey;

		skedModels.ActionResult jobResult = skedCalendarViewController.getJobs(startDate, endDate);
		System.assertEquals( jobResult.success, true );
		System.assertNotEquals( jobResult.data, null );

		skedModels.ActionResult oppResult = skedCalendarViewController.getOpportunities(startDate, endDate);
		System.assertEquals( jobResult.success, true );
		System.assertNotEquals( jobResult.data, null );

		skedModels.ConfigModel config = skedCalendarViewController.getConfigs();
		System.assertNotEquals( config, null );

		Test.stopTest();
	}
	
	@isTest
	static void test_skedBatchProcessor(){
		sked__Job__c job = [Select Id from sked__Job__c limit 1];

		Test.startTest();

		skedBatchProcessor batch = new skedBatchProcessor(String.valueOf(job.id), skedLocationServices.OBJ_JOB);
        Database.executeBatch(batch, 50);

		Test.stopTest();
	}
}