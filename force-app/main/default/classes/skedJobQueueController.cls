public class skedJobQueueController{
    
    public String startTime{get;set;}
    public String endTime{get;set;}
    
    public skedJobQueueController(){ 
        startTime   = '08:00';
        endTime     = '09:00';
    }
    
    public static list<sked__Job__c> queryJobs(){
        list<sked__Job_Allocation__c> jaList = [Select Id, sked__Job__c from sked__Job_Allocation__c where sked__job__r.sked__Start__c=null and sked__Resource__r.sked__User__c=:UserInfo.getUserId()];
		Set<Id> jobIDs = new Set<Id>();
        for(sked__Job_Allocation__c ja : jaList){
            jobIDs.add( ja.sked__Job__c );
        }
        list<sked__Job__c> jobs = [Select Id, Name, sked__Duration__c, sked__Description__c, CVS_Assigned_Users__c , sked__Address__c, Umbrella_Programs_and_Claims__c , GAP_Programs_and_Claims__c ,
                                       Other_Programs_and__c,sked__Contact__r.Name, sked__Contact__r.Phone, sked__Contact__r.MobilePhone, sked__Contact__r.Email,
                                        sked__Account__r.Name, sked__Account__r.BillingAddress, sked__Account__r.ShippingAddress, sked__Account__r.Phone,
                                   	(Select Id, sked__Start_Before__c  from sked__Job_Time_Constraints__r) 
                                   from sked__Job__c  where Id IN :jobIDs];
    	return jobs;
    }

	/*
	* 
	*/
    @RemoteAction
    public static String getJobs(){
		list<JAWrapper> wrappers = new list<JAWrapper>();
		for( sObject job :  queryJobs()){
			wrappers.add( new JAWrapper((sked__Job__c)(job)) );
		}
        return JSON.serialize(wrappers);
    }
    
    /*
    * If Appointment is scheduled, Job Status is updated to 'Ready' and Job Allocation Status is updated to 'Confirmed'. 
    */
    @RemoteAction
    public static String scheduleJob(String jobId, String startDate, String startTime, String endTime){
		String result = 'success';
        try{
			if( String.isBlank(jobId) || String.isBlank(startDate) || String.isBlank(startTime) || String.isBlank(endTime) )
				return 'invalid data';
        
			list<sked__Job__c> jobs = [Select Id, sked__Job_Status__c, sked__Start__c, sked__Finish__c 
                                       from sked__Job__c where Id = :jobId];
			if( jobs.isEmpty() ) return 'no job found';
			//Format Date time
			list<String> startDateList = startDate.subStringAfter(',').trim().split('/');//m/d/yy
			list<String> startTimeList = startTime.trim().split(':');
			list<String> endTimeList   = endTime.trim().split(':');
        
			sked__Job__c job         = jobs.get(0);
			job.sked__Job_Status__c     = 'Ready';
			job.sked__Start__c        = initDateTime( startDateList, startTimeList );
			job.sked__Finish__c        = initDateTime( startDateList, endTimeList );
			job.sked__Duration__c     = job.sked__Finish__c.getTime()/1000/60 - job.sked__Start__c.getTime()/1000/60;
        
			update job;
        
			list<sked__Job_Allocation__c> jaToUpdate = [Select Id, sked__Status__c, sked__Job__c from sked__Job_Allocation__c where sked__Job__c = :job.Id];
        
			for(sked__Job_Allocation__c ja : jaToUpdate){
				ja.sked__Status__c = 'Confirmed';
			}
			update jaToUpdate;

	    }catch(Exception ex){
			result = 'ERROR: ' + ex.getMessage();
	    }
        return result;
    }
    
    /*
    * Initialize a date time from strings date & time
    */
    public static DateTime initDateTime(list<String> dateList, list<String> timeList){
        return DateTime.newInstance( 
            Integer.valueOf( datelist.get(2) ),//year
            Integer.valueOf( datelist.get(0) ),//month
            Integer.valueOf( datelist.get(1) ),//day
            Integer.valueOf( timeList.get(0) ),//hour
            Integer.valueOf( timeList.get(1) ),//minute
            0  //second
        );
    }
    
    /*
    * Initialize Start/End time list
    */
    public list<SelectOption> getStartEndTime(){
        list<SelectOption> result = new list<SelectOption>();
        
        Set<String> HOURS = new Set<String>{
            '00','01','02','03','04','05','06','07','08','09','10','11','12','13','14','15','16','17','18','19','20','21','22','23'
        };
        Set<String> MINS = new Set<String>{
            '00','15','30','45'
        };
            
        String value;
        String label;
        
        for(String h : HOURS){
            for(String m : MINS){
                value = h + ':' + m;
                if(Integer.valueOf(h) < 12){
                    if(Integer.valueOf(h)==0) label = '12:' + m + ' am';
                    else label = value +  ' am';
                }else  if(Integer.valueOf(h) == 12){
                    label = value +  ' pm';
                }else{
                    String hour = String.valueOf(Integer.valueOf(h)-12);
                    if(hour.length()==1) hour = '0' + hour;
                    label = hour + ':' + m +  ' pm';
                }
                result.add( new SelectOption( value, label ) );
            }
        }
        result.add( new SelectOption('24:00','12:00 am'));
        return result;
    }

	public class JAWrapper{
		public String   mustStartBefore{get;set;}
        public String description{get;set;}
        public boolean isViolated{get;set;}
        public String 	jobId{get;set;}
        public String   jobName{get;set;}
        public list<details> jobDetails{get;set;} 
        public list<details>   contactDetails{get;set;}
        public list<details>   accountDetails{get;set;}

		public JAWrapper(sked__Job__c job){
			jobId		= job.Id;	
            jobName		= job.Name;
            description = job.sked__Description__c;
            isViolated	= false;
            if(!job.sked__Job_Time_Constraints__r.isEmpty()){
                DateTime dt = job.sked__Job_Time_Constraints__r.get(0).sked__Start_Before__c;
                if(dt!=null){
                    mustStartBefore	= fs(dt);
                    if(dt < System.now()) isViolated = true;
                }
            }
            jobDetails  = new list<details>{
                new details('Job Number', job.Name),
                new details('Must Start Before Date', mustStartBefore),
                new details('CVS Assigned', job.CVS_Assigned_Users__c ),
                new details('Address', job.sked__Address__c ),
                new details('GAP Programs and Claims', job.GAP_Programs_and_Claims__c  ),
                new details('Umbrella Programs and Claims', job.Umbrella_Programs_and_Claims__c  ),
                new details('Other Programs and Claims', job.Other_Programs_and__c  )
            };
            
            //Contact details
            contactDetails	= new list<details>{
                new details('Contact Name', job.sked__Contact__r.Name),
                new details('Phone', job.sked__Contact__r.Phone),
                new details('Mobile Phone', job.sked__Contact__r.MobilePhone ),
                new details('Email', job.sked__Contact__r.Email )
            };
            //Account details
            accountDetails	= new list<details>{
                new details('Account Name', job.sked__Account__r.Name),
                new details('Billing Address', fs(job.sked__Account__r.BillingAddress)),
                new details('Shipping Address', fs(job.sked__Account__r.ShippingAddress )),
                new details('Email', job.sked__Account__r.Phone )
            };
		}
        
         /*
        * Format Object to String
        */
        public String fs(Object o){
            if(o==null) return '';
            else if(o instanceof Date) return ((Date)o).format();
            else if(o instanceof DateTime) return ((DateTime)o).format('MM/dd/yyyy KK:mm a');
            else if(o instanceof Address){
                Address a = (Address)o;
                return (fs(a.getStreet ()) + (a.getCity()==null?'': ', ' + fs(a.getCity())) + (a.getState()==null?'': ', ' + fs(a.getState())) + (a.getPostalCode()==null?'': ', ' + fs(a.getPostalCode())) + (a.getCountry()==null?'': ', ' + fs(a.getCountry())));
            }
            return String.valueOf(o);
        }
	}
    
    public class details{
        public String value{get;set;}
        public String label{get;set;}
        public details(String l, String v){
            this.label    = l;
            this.value    = v;
        }
    }

}