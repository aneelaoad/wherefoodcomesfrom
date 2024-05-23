public class skedAuthenticationService {
    public static final String SKEDULO_AUTH_END_POINT    = 'callout:Skedulo_API/auth/';
	public static void queryUserCredentials() {
        Http h = new Http();
        HttpResponse res;        
        String endPoint = SKEDULO_AUTH_END_POINT + 'api_user/client_credentials';
        System.debug('endPoint=' + endPoint);
        HttpRequest req = new HttpRequest();
        req.setHeader('Content-Type', 'application/json');
        req.setEndpoint(endPoint);
        req.setMethod('GET');
        
        String jsonResponse = '';
        try {
            res = h.send(req);
            jsonResponse = res.getBody();
            System.debug('#jsonResponse#' + jsonResponse );            
        }
        catch (JSONException ex) {
            System.debug('Error: ' + ex.getMessage());
            System.debug(' Stack Trace: ' + ex.getStackTraceString());
        }        
    }
    
    public static TokenResponse requestToken(Authentication_Setting__c authSetting) {
		TokenResponse response = new TokenResponse();        
        String body = 'client_id=' + EncodingUtil.urlEncode(authSetting.Client_Id__c, 'UTF-8')                    
            + '&client_secret=' + EncodingUtil.urlEncode(authSetting.Client_Secret__c, 'UTF-8')                    
            + '&audience=' + EncodingUtil.urlEncode(authSetting.Audience__c, 'UTF-8')
            + '&grant_type=' + EncodingUtil.urlEncode(authSetting.Grant_Type__c,'UTF-8');
        HttpRequest req = new HttpRequest();
        req.setEndpoint(authSetting.Auth_Endpoint__c);
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setHeader('Accept','application/json');
        req.setHeader('Accept-Language','en_US');
        req.setMethod('POST');
        req.setBody(body);
        try {
            string jsonResult = '';
            Http h = new Http();
            HttpResponse res = h.send(req);
            jsonResult = res.getBody();   
            system.debug('#response#' + res.getBody());
            response = (TokenResponse)JSON.deserialize(jsonResult, TokenResponse.Class);
            
            authSetting.Access_Token__c = response.access_token;
            authSetting.Token_Type__c = response.token_type;
            authSetting.Expires_In__c = response.expires_in;
            authSetting.Expires_On__c = System.now().addMinutes(Integer.valueOf(response.expires_in/60));                        
        }
        catch (Exception ex) {
            response.success = false;
            response.errorMessage = ('Error: ' + ex.getMessage());
            response.errorMessage += (' Stack Trace: ' + ex.getStackTraceString());
        }
        return response;
    }   
    
    public static Authentication_Setting__c getAuthenticationData() {    
        Authentication_Setting__c authSetting = [SELECT Name, Token_Type__c, Expires_In__c, Access_Token__c,
                                                 Client_Id__c, Client_Secret__c, Audience__c, Grant_Type__c,
                                                 Auth_Endpoint__c, Expires_On__c
                                                 FROM Authentication_Setting__c
                                                 WHERE Name = 'AuthenticationSetting'];
        
        if ( !String.isBlank(authSetting.Access_Token__c)  && authSetting.Expires_On__c < system.now().addMinutes(-2)  
            || String.isBlank(authSetting.Access_Token__c) )
        {
            TokenResponse result = requestToken(authSetting); 
            System.debug('resutl==' + result);            
        } 
        
        return authSetting;        
    }
    
    public class TokenResponse {
        public String access_token {get;set;}
        public Decimal expires_in {get;set;}
        public String token_type {get;set;}
        public String errorMessage {get;set;}
        public boolean success {get;set;}
    }
}