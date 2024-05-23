/*
Developed By: Muhammad Jawwad
Date Created: 22-Dec-2020
*/
@isTest
public class CustomerFeedbackTrgTest {
    
    @istest
    public static void TestCustomerFeedbackTrg(){
        
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'Alexis Budde',
            Email = 'me@sales.com',
            Username = 'me@sales.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            isActive = true);
        
        insert u;
        
        User u1 = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'Sameer Afsar',
            Email = 'me@sales.com',
            Username = 'me@sales1.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            isActive = true);
        
        insert u1;
        
        Customer_Feedback__c cf = new Customer_Feedback__c();
        cf.Name = 'Test Customer Feedback';
        cf.CVS_Assigned_Users__c='Alexis Budde';
        cf.CVS_Assigned1__c= u.id;
        insert cf;
        
        cf.CVS_Assigned_Users__c='Sameer Afsar';
        cf.CVS_Assigned1__c =u1.id;
        update cf;
        
        Customer_Feedback__c cf1 = new Customer_Feedback__c();
        cf1.Name = 'Test Customer Feedback1';
        
        cf1.CVS_Assigned_Users__c='Alexis Budde';
        cf1.CVS_Assigned1__c= u.id;
        insert cf1;
        
        cf1.CVS_Assigned_Users__c='';
        cf1.CVS_Assigned1__c =null;
        update cf1;
    }
    
}