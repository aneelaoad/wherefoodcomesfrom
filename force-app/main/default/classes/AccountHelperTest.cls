/*
Developed By: Muhammad Jawwad
Date Created: 22-Dec-2020
*/
@isTest
public class AccountHelperTest {
    @istest
    public static void TestAccHelper(){
        
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
        
        
        
        //Account
        Account a = new Account();
        a.Name='Test';
        a.CVS_Assigned_Users__c='Alexis Budde';
        a.CVS_Assigned1__c= u.id;
        insert a;
        
        a.CVS_Assigned_Users__c='Sameer Afsar';
        a.CVS_Assigned1__c =u1.id;
        update a;
        
       
        
        Account a1 = new Account();
        a1.Name='Test1';
        a1.CVS_Assigned_Users__c='Alexis Budde';
        a1.CVS_Assigned1__c= u.id;
        insert a1;
        
        a1.CVS_Assigned_Users__c='';
        a1.CVS_Assigned1__c =null;
        update a1;
    }
        @istest
    public static void TestAccHelper1(){
        User u2 = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'Jamie Abbott',
            Email = 'me@sales.com',
            Username = 'me@sales2.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            isActive = true);
        
        insert u2;
        
        User u3 = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'Laura Fitzpatrick',
            Email = 'me@sales.com',
            Username = 'me@sales3.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            isActive = true);
        
        insert u3;
        
        Account a2 = new Account();
        a2.Name='Test2';
        a2.Initial_reviewer_user__c = 'Jamie Abbott';
        a2.Initialreviewer__c = u2.id;
        insert a2;
        
        a2.Initial_reviewer_user__c = 'Laura Fitzpatrick';
        a2.Initialreviewer__c = u3.id;
        update a2;
        
       
        
        Account a3 = new Account();
        a3.Name='Test3';
        a3.Initial_reviewer_user__c = 'Jamie Abbott';
        a3.Initialreviewer__c = u2.id;
        insert a3;
        
        a3.Initial_reviewer_user__c = '';
        a3.Initialreviewer__c = null;
        update a3;
        
        
    }
  
}