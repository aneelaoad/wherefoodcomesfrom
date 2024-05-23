trigger CaseAfterInsertAfterUpdateAfterDeleteAfterUndelete on Case (after insert, after update, after delete, after undelete) {
	Set<Id> parentIds = new Set<Id>();

	for(Case c : trigger.isDelete ? trigger.old : trigger.new) {
		Case old = trigger.isUpdate ? trigger.oldMap.get(c.Id) : new Case();

		if((!trigger.isUpdate && !c.IsClosed) || c.IsClosed != old.IsClosed) {
			parentIds.add(c.Opportunity__c);
		}
	}

	parentIds.remove(null);

	if(!parentIds.isEmpty()) {
		List<Opportunity> opps = [SELECT Id, Num_of_Open_Cases__c FROM Opportunity WHERE Id IN :parentIds];

		for(Opportunity opp : opps) {
			opp.Num_of_Open_Cases__c = 99999;
		}

		update opps;
	}
}