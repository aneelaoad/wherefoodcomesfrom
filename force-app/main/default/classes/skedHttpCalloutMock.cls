@isTest
public class skedHttpCalloutMock implements HttpcalloutMock{
	public string data;
    public skedHttpCalloutMock(String inputJson) {
        this.data = inputJson;
    }
    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        
        res.setHeader('Content-Type', 'application/json');
        res.setBody(this.data);
        res.setStatusCode(200);
        
        return res;
    }
}