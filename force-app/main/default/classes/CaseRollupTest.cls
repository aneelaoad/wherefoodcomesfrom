@isTest
private class CaseRollupTest {
	static Account acct;
	static Opportunity opp;
	static Case c;

	public static void setup() {
		acct = new Account(
			Name = 'Test Account'
		);
		insert acct;

		opp = new Opportunity(
			AccountId = acct.Id,
			Name = 'Test Opp',
			CloseDate = System.today(),
			StageName = 'Prospecting'
		);
		insert opp;

		c = new Case(
			Opportunity__c = opp.Id
		);
	}

	static testMethod void testNoCases() {
		setup();

		opp = loadOpp(opp.Id);

		System.assertEquals(0, opp.Num_of_Open_Cases__c);
	}

	static testMethod void testOpenCase() {
		setup();
		insert c;

		opp = loadOpp(opp.Id);

		System.assertEquals(1, opp.Num_of_Open_Cases__c);

		delete c;

		opp = loadOpp(opp.Id);

		System.assertEquals(0, opp.Num_of_Open_Cases__c);

		undelete c;

		opp = loadOpp(opp.Id);

		System.assertEquals(1, opp.Num_of_Open_Cases__c);

		c.Status = 'Closed';
		update c;

		opp = loadOpp(opp.Id);

		System.assertEquals(0, opp.Num_of_Open_Cases__c);
	}

	public static Opportunity loadOpp(Id oppId) {
		return [SELECT Id, Num_of_Open_Cases__c FROM Opportunity WHERE Id = :oppId];
	}
}