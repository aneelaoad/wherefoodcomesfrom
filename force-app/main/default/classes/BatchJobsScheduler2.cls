global class BatchJobsScheduler2 implements Schedulable 
{
    public String AfterMins { get; set; }

    public String AfterHour { get; set; }

    public String ClassName { get; set; }
    
    public string BatchSize {get;set;}
    
    public String Message { get; set; }
    
    public boolean Continous {get;set;}
    
    public string CronString {get;set;}

    global void execute(SchedulableContext SC) {
       Type customType = Type.forName(ClassName);//Schema.getGlobalDescribe().get(ClassName).newSObject();
       Object sObj = customType.newInstance();
       integer size = (string.isEmpty(BatchSize) == true? 200 : integer.valueOf(BatchSize));
       Database.Batchable<sObject> batchObj = (Database.Batchable<sObject>) sObj;
       if (batchObj != null && Test.isRunningTest() == false)
           Database.executeBatch(batchObj, size);       
    }

    public PageReference Schedule() {
       if (Type.forName(ClassName) == null)
       {
           Message = 'There is no class named ' + ClassName;
           return null;
       }

       Type customType = Type.forName(ClassName);//Schema.getGlobalDescribe().get(ClassName).newSObject();
       Object sObj = customType.newInstance();       
       //sObject sObj = Schema.getGlobalDescribe().get(ClassName).newSObject();
       Database.Batchable<sObject> batchObj = (Database.Batchable<sObject>) sObj;
       
       if (batchObj == null)
       {
           Message = 'The Class is not Batchable';
           return null;
       }
       else 
       {
           string cron = '';
            if (string.isEmpty(CronString) == true)
            {
                datetime current = Datetime.now();
                
                if (AfterHour == '' && AfterMins == '')
                {
                    Message = 'Enter Hours/Minutes';
                    return null;
                }
                
                if (AfterMins == '' )
                    AfterMins = string.valueOf(current.minute() + 5);
                else
                    AfterMins = string.valueOf(current.minute() + integer.valueOf(AfterMins));
                if (AfterHour == '')
                    AfterHour = '*';
                else
                    AfterHour = string.valueOf(current.hour());
                       
                String seconds = '0'; //Execute at Zero Seconds
                String minutes = AfterMins; //Execute after 5 mins
                String hours = AfterHour; // Execute Every Hour
                String dayOfMonth = '*'; // Execute Every Day of the Month
                String month = string.valueOf(current.month()); //Execute only in November(11)
                String dayOfWeek = '?'; //Execute on all 7 days of the Week
                String year = string.valueOf(current.year()); //Execute only for year 2009
                
                //Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
                cron = seconds + ' ' + minutes + ' ' + hours + ' ' + dayOfMonth + ' ' + month + ' ' + dayOfWeek + ' ' + year;
            }
           try{
               if (Test.isRunningTest() == false)
               {
                   if (string.isEmpty(CronString) == true)
                       CronString = cron;
                   String jobID = system.schedule(ClassName + ' Job', CronString, this);
               }
           }
           catch(exception ex)
           {
               Message = 'Exception occured : cron : ' + cron + '\n Message : ' + ex.getmessage();
               return null;
           }
           Message = 'The ' + ClassName + ' has been scheduled at ' + cron;
           
       }
        return null;
    }
}