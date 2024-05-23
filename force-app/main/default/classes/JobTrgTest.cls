/*
Developed By: Muhammad Jawwad
Date Created: 22-Dec-2020
*/
@istest
public class JobTrgTest {

     @istest
    public static void TestJobTrgTest(){
        
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
        
        sked__Region__c sr = new sked__Region__c();
        
        sr.Name = 'Test';
        sr.sked__Timezone__c ='America/Chicago';
        insert sr;
        
        sked__Job__c j = new sked__Job__c();
        
        j.sked__Region__c = sr.Id;
        j.sked__Duration__c= 1.1;
        j.CVS_Assigned_Users__c='Alexis Budde';
        j.CVS_Assigned1__c= u.id;
        insert j;
        
        j.CVS_Assigned_Users__c='Sameer Afsar';
        j.CVS_Assigned1__c =u1.id;
        update j;
        
        sked__Job__c j1 = new sked__Job__c();
        j1.sked__Region__c = sr.Id;
        j1.sked__Duration__c= 1.1;
        j1.CVS_Assigned_Users__c='Alexis Budde';
        j1.CVS_Assigned1__c= u.id;
        insert j1;
        
        j1.CVS_Assigned_Users__c='';
        j1.CVS_Assigned1__c =null;
        update j1;
    }
}