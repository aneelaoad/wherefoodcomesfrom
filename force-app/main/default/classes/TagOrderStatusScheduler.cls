global class TagOrderStatusScheduler implements Schedulable {
   global void execute(SchedulableContext SC) {
      //Get list of orders that haven't been shipped
      //List<Tag_Order__c> orders  = TagOrderStatusHelper.getPendingOrders();
  	 	//Make call to get order status for each order
  	 	TagOrderStatusHelper.startBatchToGetOrders();
   }
}


/**********************
 * Run this in Execute Anon Window to start scheduled Apex Class: 
 
 	TagOrderStatusScheduler qcs = new TagOrderStatusScheduler();
    String schedule = '0 0 * * * ?';
    String jobID = system.schedule('Tag Order Sync Job', schedule, qcs);
*******************/