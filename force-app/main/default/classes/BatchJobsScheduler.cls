global class BatchJobsScheduler implements Schedulable 
{
    public String AfterMins { get; set; }

    public String AfterHour { get; set; }

    public String ClassName { get; set; }
    
    public String Message { get; set; }

    global void execute(SchedulableContext SC) {
       Type customType = Type.forName(ClassName);//Schema.getGlobalDescribe().get(ClassName).newSObject();
       Object sObj = customType.newInstance();
       Database.Batchable<sObject> batchObj = (Database.Batchable<sObject>) sObj;
       if (batchObj != null && Test.isRunningTest() == false)
           Database.executeBatch(batchObj);       
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
           //schedule itself
           string cron = '0 '+ (AfterMins == '' ? '0' : '0/' + AfterMins) + ' ' + (AfterHour == '' ? '0' : '0/'+AfterHour) + ' 1/1 * ? *';
           if (Test.isRunningTest() == false)
               String jobID = system.schedule(ClassName + ' Job', cron, this);
           Message = 'The ' + ClassName + ' has been scheduled at ' + cron;
       }
        return null;
    }
}