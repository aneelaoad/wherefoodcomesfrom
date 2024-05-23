/*
Developed By: Muhammad Jawwad
Date Created: 22-Dec-2020
*/
@istest
public class VerificationReportTrgTest {

    @istest
    public static void TestVerificationReportTrgTest(){
        
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
        
        Verification_Report__c vr = new Verification_Report__c();
        vr.Name = 'Test Verification Report';
        vr.CVS_Assigned_Users__c='Alexis Budde';
        vr.CVS_Assigned1__c= u.id;
        insert vr;
        
        vr.CVS_Assigned_Users__c='Sameer Afsar';
        vr.CVS_Assigned1__c =u1.id;
        update vr;
        
        Verification_Report__c vr1 = new Verification_Report__c();
        vr1.Name = 'Test Verification Report1';
        
        vr1.CVS_Assigned_Users__c='Alexis Budde';
        vr1.CVS_Assigned1__c= u.id;
        insert vr1;
        
        vr1.CVS_Assigned_Users__c='';
        vr1.CVS_Assigned1__c =null;
        update vr1;
    }
}