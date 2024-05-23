@istest
public class TestScheduleJobs {
    
    /*public class TestScheduler implements Database.Batchable<sObject> 
    {
    public Iterable<sObject> start(Database.BatchableContext bc) { return null; }
    public void execute(Database.BatchableContext BC, list<sObject>){}
    public void finish(Database.BatchableContext BC){}
    }*/

    
    @istest
    public static void testBatchJobsScheduler()
    {
        BatchJobsScheduler2 job = new BatchJobsScheduler2();
        job.ClassName = 'TagOrderStatusBatch';
        job.AfterHour = '4';
        job.AfterMins = '5';
        
        job.Schedule();
        job.execute(null);
        
        job.AfterHour = '';
        job.AfterMins = '';        
        job.Schedule();
        
        job.AfterHour = '5';
        job.AfterMins = '';        
        job.Schedule();
        
        job.AfterHour = '';
        job.AfterMins = '5';        
        job.Schedule();
        
        job.CronString = 'ddbb';      
        job.Schedule();
        
        
                
        job.ClassName = 'Test1123';
        job.Schedule();
    }
}