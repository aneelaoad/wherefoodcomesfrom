global virtual class skedModels {

	public static String DATE_FORMAT 	= 'yyyy-MM-dd\'T\'HH:mm:ss.SSSZ';

	global class JobModel{
		public String jobId;
		public String jobName;
		public String jobType;
		public String jobStatus;
		public String jobDescription;
		public Integer jobDuration;
		public String jobDateString;
		public String jobStartLabel;
		public String jobFinishLabel;
		public String jobStart;
		public String jobFinish;
		public String timezone;
		public String jobAddress;
		public decimal jobLatitude;
		public decimal jobLongitude;
		public String accountId;
		public String accountName;
		public String regionId;
		public String regionName;
		public String physicalState;

		public JobModel(sked__Job__c job){
			this.jobId 			= job.Id;
			this.jobName 		= job.Name;
			this.jobType 		= fs(job.sked__Type__c);
			this.jobStatus 		= fs(job.sked__Job_Status__c);
			this.jobDescription = fs(job.sked__Description__c);
			this.jobDuration 	= Integer.valueOf(job.sked__Duration__c);
			this.jobStart 		= job.sked__Start__c.format( DATE_FORMAT );
			this.jobFinish 		= job.sked__Finish__c.format( DATE_FORMAT );
			this.timezone 		= fs(job.sked__Region__r.sked__Timezone__c);
			this.jobAddress 	= fs(job.sked__Address__c).replaceAll('<br>', ' ');
			this.jobLatitude 	= job.sked__Account__r.GeoLocation__Latitude__s;
			this.jobLongitude 	= job.sked__Account__r.GeoLocation__Longitude__s;
			this.accountId 		= fs(job.sked__Account__r.Id);
			this.accountName 	= fs(job.sked__Account__r.Name);
			this.regionId 		= fs(job.sked__Region__r.Id);
			this.regionName 	= fs(job.sked__Region__r.Name);
			this.physicalState 	= job.sked__Account__r.BillingState;
		}

		public JobModel parse(String json){
			return (JobModel) System.JSON.deserialize(json, JobModel.class);
		}
	}

	global class OppModel{
		public String opportunityId;
		public String opportunityName;
		public String accountId;
		public String accountName;
		public String opportunityType;
		public String opportunityStatus;
		public String opportunityClaims;
		public String opportunityAddress;
		public decimal opportunityLatitude;
		public decimal opportunityLongitude;
		public String divisionId;
		public String divisionName;
		public String regionId;
		public String regionName;
		public String neededByDate;
		public String physicalState;

		public OppModel(Opportunity opp){
			this.opportunityId 			= opp.Id;
			this.opportunityName 		= fs(opp.Name);
			this.opportunityType 		= fs(opp.Type);
			this.opportunityStatus 		= fs(opp.StageName);
			this.opportunityClaims 		= fs(opp.Claims__c);
			this.opportunityAddress 	= fs(opp.Physical_Address__c).replaceAll('<br>', ' ');
			this.accountId 				= opp.Account.Id;
			this.accountName 			= opp.Account.Name;
			this.opportunityLatitude 	= opp.Account.GeoLocation__Latitude__s;
			this.opportunityLongitude 	= opp.Account.GeoLocation__Longitude__s;
			this.divisionId 			= fs(opp.Division__c);
			this.divisionName 			= fs(opp.Division__c);
			this.neededByDate 			= opp.CloseDate == null? '' : DateTime.newInstance(opp.CloseDate, Time.newInstance(0,0,0,0)).format('yyyy-MM-dd');//opp.Tag_Needed_by_Date_Other__c.format();
			this.physicalState 			= opp.Physical_State__c;
		}

		public OppModel parse(String json){
			return (OppModel) System.JSON.deserialize(json, OppModel.class);
		}
	}

	global static String fs(String s){
		if(String.isBlank(s)) return '';
		return s;
	}

	global class ActionResult{
		public boolean success;
		public String errorMessage;
		public Object data;

		public ActionResult(){
			this.success 	= true;
		}
	}

	global class ConfigModel{
        public list<Item> lstJobStatus{get;set;}
        public list<Item> lstOppDivisions{get;set;}
        public list<Item> lstOppStatus{get;set;}
        public list<Item> lstRegions{get;set;}
        public list<String> lstStates{get;set;}
        public String opportunityCardColor;
        public String jobCardColor;

        public ConfigModel(){
            lstJobStatus		= new list<Item>();
            lstOppDivisions		= new list<Item>();
            lstOppStatus		= new list<Item>();
            lstRegions			= new list<Item>();
            lstStates			= new list<String>();
            this.opportunityCardColor 	= skedConfigs.OPPORTUNITY_CARD_COLOR;
            this.jobCardColor 			= skedConfigs.JOB_CARD_COLOR;
        }
    }

    global class Item{
    	public String id;
    	public String name;

    	public Item(String i, String n){
    		this.id 		= i;
    		this.name		= n;
    	}
    }

    public class skedException extends Exception {

	}
}