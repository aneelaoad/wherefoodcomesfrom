public class skedDispatchServices {
    public static final String SKEDULO_END_POINT    = 'callout:Skedulo_API/notifications/';    
    
    @future(callout=true)
    public static void notifyResource(Id jobId, Id resourceId){
        sked__Job__c job = [SELECT Id, Name, sked__Duration__c, sked__Address__c, sked__Start__c, sked__TimeZone__c, sked__Account__c, sked__Account__r.Name
                            FROM sked__Job__c
                            WHERE Id = :jobId];
        Authentication_Setting__c authSetting = skedAuthenticationService.getAuthenticationData();
        notify_Phoenix('Notify', resourceId, generateSMS(job), authSetting.Access_Token__c);    
        update authSetting;
    }
    
    private static String generateSMS(sked__Job__c job) {
        String SMS = '';
        SMS_Template__c smsTemplate = SMS_Template__c.getOrgDefaults();
        SMS =  smsTemplate.Dispatch_SMS__c;
        SMS = SMS.replace('[JOBNAME]', job.Name);        
        SMS = SMS.replace('[JOBADDRESS]', job.sked__Address__c == NULL ? '' : job.sked__Address__c);
        SMS = SMS.replace('[ACCOUNT]', job.sked__Account__c == NULL ? '' : job.sked__Account__r.Name);
        SMS = SMS.replace('[JOBDURATION]', String.valueOf(job.sked__Duration__c) );
        
        return SMS;
    }
    
    public static void notify_Phoenix (string method, Id resourceId, String SMS, String token) { 
        ApiResponse result = new ApiResponse();
        NotificationRequest request = new NotificationRequest();
        
        request.resourceId = resourceId;
        request.message = SMS;
        String apiToken = token;
        if ( !String.isBlank(apiToken) ) {
            Http h = new Http();
            HttpResponse res;
            String jsonReq = JSON.serialize(request);
            String endPoint = SKEDULO_END_POINT + 'oneoff';
            if(method == 'Cancel') EndPoint = SKEDULO_END_POINT + 'notify_cancel';
            System.debug('endPoint=' + endPoint);
            HttpRequest req = new HttpRequest();
            req.setHeader('Content-Type', 'application/json'); 
            req.setHeader('apiToken', apiToken);
            req.setEndpoint(endPoint);
            req.setMethod('POST');
            req.setBody(jsonReq);
            String jsonResponse = '';
            
            try {
                res = h.send(req);
                jsonResponse = res.getBody();
                System.debug('#jsonResponse#' + jsonResponse );
                Map<string, object> deserializedResponse = (Map<string, object>)Json.deserializeUntyped(jsonResponse);
                Map<string, object> resultsObject = (Map<string, object>)deserializedResponse.get('results');
                System.debug('#jsonResponse#' + JSON.serialize(resultsObject) );            
            }
            catch (JSONException jsonEx) {
                result.success = FALSE;
                result.errorMessage = 'An error happens in Skedulo Server. Please contact administrator.';
                result.errorMessage += (' Json Response: ' + jsonResponse);
            }
            catch(Exception ex) {
                result.success = FALSE;
                result.errorMessage = ('Error: ' + ex.getMessage());
                result.errorMessage += (' Stack Trace: ' + ex.getStackTraceString());
            }
        }        
    }    
    
    public class NotificationRequest {
        public String jobId {get;set;}
        public String resourceId {get;set;}
        public String message {get;set;}
    }
    
    public class ApiResponse {
        public boolean success {get;set;}
        public string errorMessage {get;set;}
        public string errorCode {get;set;}
    }
}