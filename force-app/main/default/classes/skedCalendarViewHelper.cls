public class skedCalendarViewHelper extends skedModels{

	/*
	*
	*/
	public static ConfigModel getConfigs(){
		ConfigModel configs = new ConfigModel();
		//get job status
		Set<String> excludedJobStatuses = stringToSet( skedConfigs.EXCLUDED_JOB_STATUSES );
		for(Item status : getPicklistValue(sked__Job__c.sked__Job_Status__c)){
			if(!excludedJobStatuses.contains(status.name)) configs.lstJobStatus.add(status);
		}
		//Get Opportunity divisions
		configs.lstOppDivisions = getPicklistValue(Opportunity.Division__c);
		//Get Opportunity Stage
		Set<String> excludedOppStatuses = stringToSet( skedConfigs.EXCLUDED_OPPORTUNITY_STATUSES );
		for(Item status : getPicklistValue(Opportunity.StageName)){
			if(!excludedOppStatuses.contains(status.name)) configs.lstOppStatus.add(status);
		}
		//Get regions
		for(sked__Region__c region : [SELECT Id, Name FROM sked__Region__c ORDER BY Name]){
			configs.lstRegions.add( new Item(region.Id, region.Name) );
		}
		//Get Physical States
		String state;
		for(AggregateResult ar : [Select BillingState from Account GROUP BY BillingState order by BillingState asc]){
			if(ar.get('BillingState') != null) {
				state 	= String.valueOf(ar.get('BillingState'));
				if( !String.isBlank(state) ) configs.lstStates.add( state );
			}
		}

		return configs;
	}

	/*
	*
	*/
	public static ActionResult getJobs(String startDate, String endDate){

		Date sDate = toDate( startDate );
		Date eDate = toDate( endDate );

		DateTime startTime 	= DateTime.newInstance( sDate, Time.newInstance(0, 0, 0, 0));
		DateTime endTime 	= DateTime.newInstance( eDate, Time.newInstance(0, 0, 0, 0));

		ActionResult result = new ActionResult();
		list<JobModel> jobModels = new list<JobModel>();
		Set<String> excludedJobStatuses = stringToSet( skedConfigs.EXCLUDED_JOB_STATUSES );
		for(sked__Job__c job : [SELECT Id, Name, sked__Type__c, sked__Job_Status__c, sked__Description__c, sked__Duration__c, sked__Start__c, sked__Finish__c, sked__Region__r.sked__Timezone__c,
									sked__Address__c, sked__Account__r.GeoLocation__Latitude__s, sked__Account__r.GeoLocation__Longitude__s, sked__Account__r.Id, sked__Account__r.Name, sked__Account__r.BillingState,
									sked__Region__r.Id, sked__Region__r.Name, sked__GeoLocation__Latitude__s, sked__GeoLocation__Longitude__s
								FROM sked__Job__c
								WHERE sked__Job_Status__c NOT IN :excludedJobStatuses
									AND sked__Start__c <= :endTime and sked__Finish__c >= :startTime
								]){
			jobModels.add( new JobModel(job) );
		}
		result.data = jobModels;
		return result;
	}

	/*
	*
	*/
	public static ActionResult getOpportunities(String startDate, String endDate){
		Date sDate = toDate( startDate );
		Date eDate = toDate( endDate );

		ActionResult result = new ActionResult();
		list<OppModel> oppModels = new list<OppModel>();

		Set<String> excludedOppStatuses = stringToSet( skedConfigs.EXCLUDED_OPPORTUNITY_STATUSES );
		for(Opportunity opp : [SELECT Id, Name, StageName, CloseDate, Claims__c, Physical_Address__c, Physical_State__c, Account.Id, Account.Name, Account.GeoLocation__Latitude__s, Account.GeoLocation__Longitude__s, Account.BillingState, Division__c, Region__c, Type
								FROM Opportunity
								WHERE StageName NOT IN :excludedOppStatuses
								AND CloseDate >=:sDate AND CloseDate <= :eDate
								]){

			oppModels.add( new OppModel(opp) );
		}
		result.data = oppModels;
		return result;
	}

	/*
	*
	*/
	public static Date toDate(String ds){
        list<String> dString = ds.split('-');
        return Date.newInstance(Integer.valueOf(dString[0]), Integer.valueOf(dString[1]), Integer.valueOf(dString[2]));
    }

    /*
	*
	*/
	public static Set<String> stringToSet(String s){
		Set<String> result = new Set<String>();
		if(String.isBlank(s)) return result;
		
		for(String subString : s.split(',')){
			result.add( subString.trim() );
		}
		return result;
	}

    /*
    *
    */
    public static list<Item> getPicklistValue(sObjectField field){
    	Schema.DescribeFieldResult fieldResult = field.getDescribe();
    	list<Item> result = new list<Item>();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

       for( Schema.PicklistEntry f : ple){
          if(f.isActive()) result.add( new Item(f.getValue(), f.getLabel()) );
       }
       return result;
    }
}