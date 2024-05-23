@isTest
public class skedAuthenticationServiceTest {
    @testSetup
    public static void initData() {
        Authentication_Setting__c settingObj = new Authentication_Setting__c(
        	Name = 'AuthenticationSetting',           
            Client_Id__c = '123',
            Client_Secret__c = '123',
            Audience__c = 'https://api.skedulo.com',
            Grant_Type__c = 'client_credentials',
            Auth_Endpoint__c = 'https://skedulo.auth0.com/oauth/token',
            Expires_On__c = System.now().addDays(2)
        );
        insert settingObj;
    }
    
    @isTest static void testQueryUserCredentials() {
        string jsonRes = '{"result":{"authEndpoint":"https://skedulo.auth0.com/oauth/token","authBody":{"grant_type":"client_credentials","client_id":"A6lTyYEoo26oH","client_secret":"_ZUbLNJtvmL-dTUHuMyCtb7B","audience":"https://api.skedulo.com"}}}';
        skedHttpCalloutMock mock = new skedHttpCalloutMock(jsonRes);
        Test.setMock(HttpCalloutMock.Class, mock);
        Test.startTest();
        skedAuthenticationService.queryUserCredentials();
        Test.stopTest();
    }
    
    @isTest static void testGetToken() {
        string jsonRes = '{"access_token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6IlEwWXdO","expires_in":86400,"token_type":"Bearer"}';
        skedHttpCalloutMock mock = new skedHttpCalloutMock(jsonRes);
        Test.setMock(HttpCalloutMock.Class, mock);
        Test.startTest();
        Authentication_Setting__c authSetting = skedAuthenticationService.getAuthenticationData();
        update authSetting;
        Test.stopTest();
       
        System.assertEquals('eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6IlEwWXdO', authSetting.Access_Token__c);
 		System.assertEquals(86400, authSetting.Expires_In__c);       
        System.assertEquals('Bearer', authSetting.Token_Type__c);       
    }
}