@isTest
public class TestREST {
    public static HttpCalloutMock mock = null;
    public static testMethod void testCallHttp() {
        callHttp();
    }
    
    public static void callHttp() {
        
        HttpRequest req = new HttpRequest();
        HttpResponse res = null;
        req.setEndpoint('http://www.google.ca');
        req.setMethod('GET');
        String resp;
        
        
        Http h = new Http();
        res = h.send(req);
        
        
        resp = res.getBody();
        System.debug(resp);
    }
}