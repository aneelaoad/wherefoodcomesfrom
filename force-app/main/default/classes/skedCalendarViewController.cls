global class skedCalendarViewController extends skedModels {

    public String googleAPIKey{
        get{
            return skedConfigs.GOOGLE_API_KEY;
        }
    }
	/*
	*
	*/
	@RemoteAction
	global static ConfigModel getConfigs(){
		return skedCalendarViewHelper.getConfigs();
	}

	/*
	*
	*/
	@RemoteAction
	global static ActionResult getJobs(String startDate, String endDate){
		return skedCalendarViewHelper.getJobs(startDate, endDate);
	}

	/*
	*
	*/
	@RemoteAction
	global static ActionResult getOpportunities(String startDate, String endDate){
		return skedCalendarViewHelper.getOpportunities(startDate, endDate);
	}
}