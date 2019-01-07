public with sharing class GoogleDriveIntegration 
{
    
    /*
    Name        : GoogleDriveController
    Auther      : Hanuman Mehra
    Date        : 6th june 2016
    Description : Integration with google drive
    */
    
   //Public data member
     public Blob file {get; set;}
     public String fileId {get; set;}
     public String fileType {get; set;}
     public String fileName {get; set;}
     public List<GoogleDriveWrapper> driveWrapperList {get; set;}  
     
     //Private data member Fatched from url
     String id = '';
     String url = '';
     String code = '';
     String title = '';
     String accessToken = '';
     Set<GoogleDriveWrapper> driveWrapperSet = new Set<GoogleDriveWrapper>();
     
     String secret = 'PiqgoBLePT3ju4DZh1B33-Or';
     String redirect_uri = 'https://inovationsoft-dev-ed--c.ap2.visual.force.com/apex/GoogleDriveIntegeration';
     String clientkey = '744139574154-4eial9p8c4urrr1uebcium4ve1375rup.apps.googleusercontent.com';
     
     
    //Constructor
    public GoogleDriveIntegration()  
    {  
        //Initialize
        file = null;
        fileType = '';
        fileName = '';
        driveWrapperSet = new Set<GoogleDriveWrapper>();
        driveWrapperList = new List<GoogleDriveWrapper>();
        
        code = ApexPages.currentPage().getParameters().get('code'); 
        System.debug('code1 ::'+code); 
        //Get the access token once we have code  
        if(code != '' && code != null)
        {  
            System.debug('code'+code); 
            AccessToken();
        }
    }  
      
    //method of PageReference type to get authenticating
    public PageReference DriveAuth()  
    {  
        //Authenticating
        PageReference pgRef = new PageReference(GoogleDriveAuthUri (clientKey, redirect_uri)) ; 
         System.debug('pgRef'+pgRef); 
        return pgRef;  
    }  
      
    //method to get Authenticating uri
    public String GoogleDriveAuthUri(String clientKey, String redirect_uri)  
    {  
        System.debug('clientKey:::'+clientKey +'redirect_uri ::'+redirect_uri);
        //Encode string into the application/x-www-form-urlencoded format using a specific encoding scheme 
        String key = EncodingUtil.urlEncode(clientKey, 'UTF-8');
        String uri = EncodingUtil.urlEncode(redirect_uri, 'UTF-8');
        
        //Authenticating uri
        String authuri = 'https://accounts.google.com/o/oauth2/auth?client_id=' + key + '&response_type=code&scope=https://www.googleapis.com/auth/drive&redirect_uri=' + uri + 
            '&state=security_token%3D138r5719ru3e1%26url%3Dhttps://oa2cb.example.com/myHome&login_hint=hanuman@briskminds.com&access_type=offline';  
        System.debug('authuri'+authuri);
        
        return authuri;  
    }  
      
    //Method to get access token 
  public void AccessToken()  
  {  
        //Getting access token from google  
        Http h = new Http();
        HttpRequest req = new HttpRequest(); 
        String messageBody = 'code=' + code + '&client_id=' + clientkey + '&client_secret=' + secret + '&redirect_uri=' + redirect_uri + '&grant_type=authorization_code';
        
        //set methods into req to get accesstoken
        req.setMethod('POST');
        req.setTimeout(60*1000); 
        req.setBody(messageBody); 
        req.setEndpoint('https://accounts.google.com/o/oauth2/token'); 
        req.setHeader('content-type', 'application/x-www-form-urlencoded');  
        req.setHeader('Content-length', String.valueOf(messageBody.length()));  
        System.debug('req'+req);
  
        HttpResponse res = h.send(req);
        String resp = res.getBody();
        
        System.debug('resp'+resp);
        //Accessing token in accesstoken in string format
        JSONParser parser = JSON.createParser(resp);
        while(parser.nextToken() != null)
        {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME))
            {
                String fieldName = parser.getText();
                parser.nextToken();
                if(fieldName == 'access_token')
                    accessToken = parser.getText();
            }
        }
    }  
    
    //Method to uploadFile
    public void uploadFile()
    {
        if(file != null)
        {
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            
            String boundary = 'Vaishnav';
            String delimiter = '\r\n--' + boundary + '\r\n';
            String closeDelimiter = '\r\n--' + boundary + '--';   
            
            //Converts a Blob to an unencoded String representing its normal form
            String encodedFile = EncodingUtil.base64Encode(file);
            String body = delimiter + 'Content-Type: application/json\r\n\r\n{ "title" : "' + filename + '", "mimeType" : "' + filetype + '" }' + delimiter +
                        'Content-Type: ' + filetype + '\r\nContent-Transfer-Encoding: base64\r\n\r\n' + encodedFile + closeDelimiter;
            
            //set methods into req to upload file
            req.setHeader('Authorization', 'Bearer ' + accessToken);
            req.setHeader('Content-length', String.valueOf(body.length()));
            req.setHeader('Content-Type', 'multipart/mixed; boundary="' + boundary + '"');
            req.setEndpoint('https://www.googleapis.com/upload/drive/v2/files?uploadType=multipart');  
            
            req.setBody(body);       
            req.setMethod('POST');
            req.setTimeout(60*1000);
            System.debug('req'+req);
            HttpResponse res = h.send(req);
            System.debug('res'+res);
            //Fill blank 
            file = null;
            filetype='';
            filename=''; 
        }      
    }

    //Method to get all files
    public void allFiles()
    {
        driveWrapperList = New List<GoogleDriveWrapper>();
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        //Set methods into req to get all files
        req.setMethod('GET');
        req.setTimeout(60 * 1000);
        req.setHeader('Authorization', 'Bearer ' + accessToken);
        req.setEndpoint('https://www.googleapis.com/drive/v2/files');
        
        HttpResponse res = h.send(req);
        String resp = res.getBody();
        
        Set<String> setOfIds = new Set<String>();
        
        //Accessing token in accesstoken in string format
        JSONParser parser = JSON.createParser(resp);
        while(parser.nextToken() != null)
        {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME))
            {
                if(parser.getText() == 'title')
                {
                    parser.nextToken();
                    title = parser.getText();
                }
                if(parser.getText() == 'id')
                {
                    parser.nextToken();
                    id = parser.getText();
                }
                if(parser.getText() == 'webContentLink')
                {
                    parser.nextToken();
                    url = parser.getText();
                }
                if(!setOfIds.contains(id))
                {
                    //Instance of wrapper class
                    driveWrapperList =  new List<GoogleDriveWrapper>();
                    GoogleDriveWrapper tempWrapper = new GoogleDriveWrapper();
                    tempWrapper.fileTitle = title;
                    tempWrapper.fileId = id;
                    tempWrapper.fileUrl = url;
                    driveWrapperSet.add(tempWrapper);
                    setOfIds.add(id);
                }
            }
        }
        //Add set into wrapper list
        driveWrapperList.addAll(driveWrapperSet);
    }
    
    //Method to delete file
    public void deleteFile()
    {
        if(fileId != null)
        {
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            
            //set methods into req to delete
            req.setMethod('DELETE');
            req.setHeader('Authorization', 'Bearer ' + accessToken);
            req.setEndpoint('https://www.googleapis.com/drive/v2/files/' + fileId); 
            HttpResponse res = h.send(req);
            System.debug('res'+res);
            System.debug('ResBody'+res.getBody());
        }
    }
    
    //Wrapper class
    public class GoogleDriveWrapper
    {
        //Public data members
        public String fileId {get; set;}
        public String fileUrl {get; set;}
        public String fileTitle {get; set;}
    }
}