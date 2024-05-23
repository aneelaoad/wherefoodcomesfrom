trigger AccountProductTrigger on Account_Products__c (after insert) {
    /*
    if(trigger.isAfter & Trigger.isInsert)
    {
        return;
        
        Set <String> cutomerType = new Set <String>();
        Map<id, Set<string>> accountCustTypeMap = new Map<id, Set<string>>();
        
        for(Account_Products__c apItem: Trigger.new)
        {
            if(apItem.Customer_Type__c != null)
            {
                if(accountCustTypeMap.containsKey(apItem.Account__c))
                {
                    Set <String> cutomerTypeTemp = accountCustTypeMap.get(apItem.Account__c);
                    cutomerTypeTemp.add(apItem.Customer_Type__c);
                    
                    accountCustTypeMap.put(apItem.Account__c, cutomerTypeTemp);
                }
                else
                {
                    Set<String> cutomerTypeTemp = new Set <String>();
                    cutomerTypeTemp.add(apItem.Customer_Type__c);
                    
                    accountCustTypeMap.put(apItem.Account__c, cutomerTypeTemp);
                }
            }
        }
        
        List<Id> accountIdList = new List<Id>();
        for (Id accID : accountCustTypeMap.keySet())
        {
            accountIdList.add(accID);
        }
        
        
        
        if(accountIdList != null && accountIdList.size() > 0)
        {
            List<Account_Products__c> accountProductList = new List<Account_Products__c>([SELECT ID, Customer_Type__c FROM Account_Products__c WHERE Account__c IN: accountIdList]);
            // Comment: contiue from here.
            //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            
            List<Account> accountList = new List<Account>([SELECT ID, Customer_Type_CS__c FROM Account WHERE ID IN: accountIdList]);
            
            for(Account accItem : accountList)
            {
                Set<String> cutomerTypeTemp = accountCustTypeMap.get(accItem.Id);
                String cs = String.join(cutomerTypeTemp, ', ');
                
                accItem.Customer_Type_CS__c = cs;
            }
            
            UPDATE accountList;
                
        }
            
    }
*/
}