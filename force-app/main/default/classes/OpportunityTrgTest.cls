/*
Developed By: Muhammad Jawwad
Date Created: 22-Dec-2020
*/
@isTest
public class OpportunityTrgTest {
    @istest
    public static void testOpptrg(){
        
        //Users
        
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
        
        //Test Data Creation
        Account a = new Account(Name='test');
        insert a;
        
        Opportunity o = new Opportunity();
        
        o.CloseDate=date.today()+1;
        o.Name='test';
        o.stagename='new';
        o.accountId = a.id;
        o.CVS_Assigned_Users__c = 'Alexis Budde';
        o.CVS_Assigned1__c = u.id;
        o.CVS_Assigned_Users_AG__c= 'Alexis Budde';
        o.CVS_Assigned_AmericanGrown1__c= u.id;
        o.ReviewerIfNotCVS_Users__c= 'Alexis Budde';
        o.Reviewer_if_not_CVS1__c= u.id;
        o.preReviewCheck__c='No';
        o.Stage_of_Work_Umbrella__c = 'pre-review';
        o.isCloneAmericanGrown__c =true;
        insert o;
        
        o.ReviewerIfNotCVS_Users__c = 'Sameer Afsar';
        o.Reviewer_if_not_CVS1__c = u1.id;
        o.CVS_Assigned_Users__c = 'Sameer Afsar';
        o.CVS_Assigned1__c = u1.id;
        o.CVS_Assigned_Users_AG__c= 'Sameer Afsar';
        o.CVS_Assigned_AmericanGrown1__c= u1.id;
        o.preReviewCheck__c = 'Yes';
        o.preReviewTimeStamp__c = System.Today();
        o.Stage_of_Work_American_Grown__c = NULL;
        o.Issue_date__c = NULL;
        o.isCloneAmericanGrown__c = FALSE;
        update o;
        
        Opportunity o1 = new Opportunity();
        
        o1.CloseDate=date.today()+1;
        o1.Name='test';
        o1.stagename='new';
        o1.accountId = a.id;
        o1.CVS_Assigned_Users__c = 'Alexis Budde';
        o1.CVS_Assigned1__c = u.id;
        o1.CVS_Assigned_Users_AG__c= 'Alexis Budde';
        o1.CVS_Assigned_AmericanGrown1__c= u.id;
        o1.ReviewerIfNotCVS_Users__c= 'Alexis Budde';
        o1.Reviewer_if_not_CVS1__c= u.id;
        o1.preReviewCheck__c='Yes';
        o1.Stage_of_Work_Umbrella__c = 'approval';
        insert o1;
        
        o1.CVS_Assigned_Users__c = '';
        o1.CVS_Assigned1__c = null;
        o1.CVS_Assigned_Users_AG__c= '';
        o1.CVS_Assigned_AmericanGrown1__c= null;
        o1.ReviewerIfNotCVS_Users__c= '';
        o1.Reviewer_if_not_CVS1__c= null;
        o1.approvalTimeStamp__c = System.Today();
        update o1;
        
    }
    
    @istest
    public static void testOpptrg1(){
        
        //Users
        
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
        
        //Test Data Creation
        Account a = new Account(Name='test');
        insert a;
        
        Opportunity o = new Opportunity();
        
        o.CloseDate=date.today()+1;
        o.Name='test';
        o.stagename='new';
        o.accountId = a.id;
        o.Initial_reviewer_user__c ='Jamie Abbott';
        o.Final_reviewer_user__c ='Jamie Abbott';    
        insert o;
        
        
        o.Initial_reviewer_user__c = 'Laura Fitzpatrick';
        o.Final_reviewer_user__c = 'Laura Fitzpatrick';
        update o;
        
        Opportunity o1 = new Opportunity();
        
        o1.CloseDate=date.today()+1;
        o1.Name='test';
        o1.stagename='new';
        o1.accountId = a.id;
        o1.Initial_reviewer_user__c ='Jamie Abbott';
        o1.Final_reviewer_user__c ='Jamie Abbott';    
        insert o1;
        
        o1.Initial_reviewer_user__c = null;
        o1.Final_reviewer_user__c = null;
        update o1;
        
    }
    
}