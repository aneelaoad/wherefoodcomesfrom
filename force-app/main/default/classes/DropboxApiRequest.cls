public class DropboxApiRequest {
    //request methods
    public final static String METHOD_POST = 'POST';
    public final static String METHOD_GET = 'GET';
    public final static String METHOD_PUT = 'PUT';
    public final static String METHOD_DELETE = 'DELETE';
    
    public final DropboxApiConnection api; 
    //public final list<RequestHeader> headers;
    Map<String, String> headers = new Map<String, String>();
    
    public String url { get; set; }
    public final String method;
    
    public String body { get; set; }
    public Blob bodyAsBlob { get; set; }
    public long bodyLength { get; set; }
	
    public DropboxApiRequest(DropboxApiConnection api, String url, String method){
        this.api = api;
        this.url = url;
        this.method = method;
    }

    
    private HttpResponse trySend() {
        Http h = new Http();
        
        HttpRequest request = new HttpRequest();
        request.setMethod(this.method);
        request.setEndpoint(this.url);
       // request.setTimeout(this.timeout);
        if (this.api != null) {
      //      if (this.shouldAuthenticate) {
                request.setHeader(
                    'Authorization',
                    'Bearer ' + this.api.getAccessToken()
                );
            //}
            //request.setHeader('User-Agent', this.api.getUserAgent());
        }
        if (this.bodyAsBlob != null) {
            request.setBodyAsBlob(this.bodyAsBlob);
          //  this.addHeader(
          //      'Content-Length',
          //      String.valueof(request.getBodyAsBlob().size())
          //  );
        } else if (this.body != null) {
            request.setBody(this.body);
        }
       // for (RequestHeader header : this.headers) {
       //     request.setHeader(header.getKey(), header.getValue());
       // }
        System.debug('httprequest = ' + request);
        System.debug('request body = ' + request.getBody());
        HttpResponse response = h.send(request);
        System.debug('response body: ' + response.getBody());

        if (isResponseRedirect(response.getStatusCode())) {
          //  return this.handleRedirect(response);
        } else if (isResponseBadRequest(response.getStatusCode())) {
            throw new DropboxApiRequestException(
                'The API responded with a 400 : Bad Request'
            );
        } else if (isResponseNotFound(response.getStatusCode())) {
            throw new DropboxApiRequestException(
                'The API responded with a 404 : Not Found'
            );
        }

        return response;
    }
    
    public void setBody(){
        
    }
    
    public void setBodyAsBlob(){
        
    }
    
    public void setHeader(String key, string value){
        this.headers.put(key, value);
    }
    
    public string setBasicAuthentication(String clientId, String clientSecret){
        //convert client id and secret into header value
        Blob headerValue = Blob.valueOf(clientId + ':' + clientSecret);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue); 
        
        return authorizationHeader; //Basic Y3NqZTl5bxxxxxxxx32As23== 
    }
    
    private static Boolean isResponseRedirect(Integer responseCode) {
        return (responseCode == 301 || responseCode == 302);
    }
    
    private static Boolean isResponseBadRequest(Integer responseCode) {
        return (responseCode == 400);
    }

    private static Boolean isResponseNotFound(Integer responseCode) {
        return (responseCode == 404);
    }
    
    public class DropboxApiRequestException extends Exception {
    }
}