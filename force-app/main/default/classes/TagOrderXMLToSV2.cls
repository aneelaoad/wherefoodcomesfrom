public class TagOrderXMLToSV2 {
    
    // private variables
    private Id TagOrderId {get;set;}
    private Tag_Order__c TagOrder {get;set;}
    
    public TagOrderXMLToSV2(ApexPages.StandardController pController){ 
        TagOrderId = pController.getId();
        TagOrder = (Tag_oRder__c)pController.getRecord();
    }
    
    public PageReference sendXMLFromTagOrderToSV2(){
        List<ContentDocumentLink> attachLinks = [Select Id, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :TagOrderId];
        Boolean manifestExists = false;
        String response;
        
        if(attachLinks.size() > 0){
            Set<ID> docIds = new Set<ID>();
            for(ContentDocumentLink l : attachLinks){
                docIds.add(l.ContentDocumentId);
            }
            
            List<ContentVersion> cvs = [Select Id, Title, VersionData FROM ContentVersion WHERE ContentDocumentId IN :docIds Order by CreatedDate Desc];
            
            if(cvs.size() > 0){
                for(ContentVersion cv : cvs){
                    if(cv.Title.endsWith('Manifest Created')){
                        manifestExists = true;                        
                        Blob xml = EncodingUtil.base64decode(EncodingUtil.base64Encode(cv.VersionData));                        
                        response = sendXMLToXV2(xml);
                        break;
                    }
                }
            }
        }
        
        if(!manifestExists){
             ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.WARNING, 'There are no Tag Manifests available on this order.'));            
            return null;
        }
        
        if(response != null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.WARNING, response));
            return null;
        }
        
        PageReference returnPage = new ApexPages.StandardController(tagOrder).view(); 
        return returnpage;
    }
    
    @future (callout=true)
    public static void sendXMLToXV2(String xml){
         sendXMLToXV2(Blob.valueOf(xml));
     }
    
     public static String sendXMLToXV2(blob xmlBlob, SV2_API__mdt apiDetails)
     {
        try{ 
           
            String xml =EncodingUtil.urlDecode(xmlBlob.toString(), 'UTF-8');
            
            HttpRequest req = new HttpRequest(); 
            if(test.isRunningTest()){
                req.setEndpoint('http://fakeErrorResponse');
            } else {
                req.setEndpoint(apiDetails.Base_URL__c);
            }
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            
            String body = '';
            body += 'xml=' + xml;
            body += '&user=' + apiDetails.UserName__c;
            body += '&pass=' + apiDetails.Password__c;
            /*req.setHeader('xml', xml);
            req.setHeader('user', 'sfapi836dcg74');
            req.setHeader('pass', 'cjd8$sjfd[omsn65');*/
            
            req.setHeader('Content-Length', String.valueOf(body.length()));
            
            req.setBody(body);
            
            Http http = new Http();
            
            system.debug('request: ' + req.getBody());
            
            HTTPResponse res = http.send(req);
            
            string results;
            
            results = res.getBody();
            
            
            system.debug('send to sv2 response: ' + results);
            return results;
            
            
        } catch (exception e){
            system.debug('*** XML Exception: ' + e.getMessage() + ' ' + e.getStackTraceString());   
            return ('*** XML Exception: ' + e.getMessage() + ' ' + e.getStackTraceString());
        }
           
   }
        
    
    public static String sendXMLToXV2(blob xmlBlob){
        List<SV2_API__mdt> apiDetails = [Select UserName__c, Base_URL__c, Password__c FROM SV2_API__mdt WHERE Label = 'Default']; 
        
        if(apiDetails.size() == 0){
            return 'Error: Please make sure to fill out SV2 API details under Setup > Customer Metadata Types';
        }
        
        return sendXMLToXV2(xmlBlob, apiDetails[0]);
        
    }
}