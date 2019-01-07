public class GoogleDriveIntegration_class
{
    private String key = '200460919925-6ou4s04vqumve5f1hnddi82s6hl5r324.apps.googleusercontent.com';
    private String secret = 'eV5TVBqT6NNpYiOAHQEAzOEZ';
    private String redirect_uri = 'https://neareststore-dev-ed--c.ap2.visual.force.com/apex/GoogleDriveIntegration_VFPage';
    private String code;
    private Object str;
    public GoogleDriveIntegration_class() 
    {
        
        str = '';
        code = '';
        code = ApexPages.currentPage().getParameters().get('code');
        //Get the access token once we have code
        if(code != '' && code != null)
        {
            AccessToken();
        }
    }
    public String GoogleDriveAuthUri()
    {
        String key1 = EncodingUtil.urlEncode(key,'UTF-8');
        String uri = EncodingUtil.urlEncode(redirect_uri,'UTF-8');
        String authuri = '';
        authuri = 'https://accounts.google.com/o/oauth2/auth?'+
        'client_id='+key1+
        '&response_type=code'+
        '&scope=https://spreadsheets.google.com/feeds'+
        '&redirect_uri='+uri+
        '&state=security_token%3D138r5719ru3e1%26url%3Dhttps://oa2cb.example.com/myHome&'+
        '&login_hint=jsmith@example.com&'+
        'access_type=offline';
        System.debug('authuri---'+authuri);
        return authuri;
    }
    public void AccessToken()
    {
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint('https://accounts.google.com/o/oauth2/token');
        req.setHeader('content-type', 'application/x-www-form-urlencoded');
        String messageBody = 'code='+code+'&client_id='+key+'&client_secret='+secret+'&redirect_uri='+redirect_uri+'&grant_type=authorization_code';
        req.setHeader('Content-length', String.valueOf(messageBody.length()));
        req.setBody(messageBody);
        req.setTimeout(60*1000);

        Http h = new Http();
        String resp;
        HttpResponse res = h.send(req);
        resp = res.getBody();
        if(resp != null && resp != '')
        {
            accessToken(resp);
        }   
    }
    public void accessToken(String resp)
    {
        Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(resp);
        if(jsonMap.size() > 0 && jsonMap != null  && jsonMap.containsKey('access_token'))
            str = jsonMap.get('access_token');

    }
    public void retrievingListOfSpreadsheets()
    {
        //SpreadsheetService service = new SpreadsheetService(); 
        //service.setAuthSubToken(str); 
        /*HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setHeader('GData-Version', '3.0');  
        req.setHeader('content-type', 'application/atom+xml'); 
        req.setEndpoint('https://spreadsheets.google.com/feeds/worksheets/key/private/basic');
        //String msgBody = 'scope=https://spreadsheets.google.com/feeds';
        String msgBody = 'code='+code+'&client_id='+key+'&client_secret='+secret+'&scope=https://spreadsheets.google.com/feeds&grant_type=authorization_code';
        req.setHeader('Content-length', String.valueOf(msgBody.length())); 
        req.setBody(msgBody);
        Http h = new Http();
        HttpResponse res = h.send(req);
        System.debug('-----'+res.getStatusCode()+'---response body--'+res.getBody()+'---full response---'+res);
        System.debug(res);*/
    }

}