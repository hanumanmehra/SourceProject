public with sharing class BoxiNtegrationController {
	/*
    Name        : BoxDriveController
    Auther      : Hanuman Mehra
    Date        : 10th May 2016
    Description : Integration with box.com
*/
	//Public data member
    public Blob file {get; set;}
    public String fileId {get; set;}
	public String dwnldUrl {get; set;}
    public String fileType {get; set;}
    public String fileName {get; set;}
	public List<BoxDriveWrapper> boxWrapperList {get; set;}

	//Private data member
    String id = '';
    String url = '';
    String code = '';
    String name = '';
    String accessToken = '';
    Set<BoxDriveWrapper> boxWrapperSet = new Set<BoxDriveWrapper>();
 
	//Private data member Fatched from url
	String client_Key = 'ices3msqk0r3ht1a0b79y8f3zc8bk3j2';
	String client_secret = 'NPgaNhjOrXlywq3PHbcS2X12wuu6Ljmi';
	String redirect_uri = 'https://c.ap1.visual.force.com/apex/BoxDrive';

	//Constructor
    public BoxiNtegrationController()  
    {  
    	//Initialize
        file = null;
        fileType = '';
        fileName = '';
        dwnldUrl = '';
        boxWrapperSet = new Set<BoxDriveWrapper>();
        boxWrapperList = new List<BoxDriveWrapper>();
        
        code = ApexPages.currentPage().getParameters().get('code'); 
        //Get the access token once we have code  
        if(code != '' && code != null)  
        	AccessToken();
    }  

	//method of PageReference type to get authenticating
    public PageReference DriveAuth()  
    {
        //Authenticating
        PageReference pgRef = new PageReference(BoxDriveAuthUri(client_Key, redirect_uri));
        return pgRef;  
    }
      
    //method to get Authenticating uri
    public String BoxDriveAuthUri(String client_Key, String redirect_uri)  
    {  
        //Encode string into the application/x-www-form-urlencoded format using a specific encoding scheme 
        String key = EncodingUtil.urlEncode(client_Key, 'UTF-8');
        String uri = EncodingUtil.urlEncode(redirect_uri, 'UTF-8');
        
        //Authenticating uri
        String authuri = 'https://account.box.com/api/oauth2/authorize?response_type=code&client_id=' + key + '&redirect_uri=' + uri + '&state=security_token%3DKnhMJatFipTAnM0nHlZA';
        return authuri;  
    }  
      
    //Method to get access token 
    public void AccessToken()  
    {  
        //Getting access token from google  
        Http h = new Http();
        HttpRequest req = new HttpRequest(); 
        String messageBody = 'grant_type=authorization_code&code=' + code + '&client_id=' + client_key + '&client_secret=' + client_secret;
        
        //set methods into req to get accesstoken
        req.setMethod('POST');
        req.setTimeout(60*1000); 
        req.setBody(messageBody); 
        req.setEndpoint('https://api.box.com/oauth2/token'); 
        req.setHeader('Content-length', String.valueOf(messageBody.length()));  
  
        HttpResponse res = h.send(req);
        String resp = res.getBody();
        
        //Accessing token in string format
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
    	/*//First approach
        if(file != null)
        {
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            
            String boundary = 'Vaishnav';
            String footer = '\r\n--' + boundary + '--';
            String header = '\r\n--' + boundary + '\r\n';
            
            //base64 encoded body
            String encodedFile = EncodingUtil.base64Encode(file);
            String body = header + 'Content-Disposition: form-data; name="filename"; filename="' + fileName + '"\r\nContent-Type:' + fileType + '\r\n\r\n' + encodedFile + '\r\n' + 
            			  header + 'Content-Disposition: form-data; name="folder_id"\r\n\r\n0' + footer;
            
            //set methods into req to upload file
			req.setBody(body);  
			req.setMethod('POST');     
            req.setTimeout(60*1000);
	 		req.setHeader('Content-Encoding', 'base64'); 
	 		req.setHeader('Authorization', 'Bearer ' + accessToken);
	  		req.setHeader('Content-Length', String.valueof(body.length()));
            req.setEndpoint('https://upload.box.com/api/2.0/files/content?parent_id=0'); 
            req.setHeader('Content-Type', 'multipart/form-data; boundary="' + boundary + '"');
            
            HttpResponse res = h.send(req);
            
            //Fill blank 
            file = null;
            filetype='';
            filename=''; 
        }*/
        //Second approach
        if(file != null)
        {
        	Http h = new Http();
        	Blob bodyBlob = null;
        	HttpRequest req = new HttpRequest();
        	
        	String boundary = '----------------------------741e90d31eff';
	      	String header = '--' + boundary + '\nContent-Disposition: form-data; name="file"; filename="' + fileName + '";\nContent-Type: application/octet-stream';
	      	String footer = '--' + boundary + '--';          
	      	String headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header + '\r\n\r\n'));
	      	String bodyEncoded = EncodingUtil.base64Encode(file);
			String last4Bytes = bodyEncoded.substring(bodyEncoded.length()-4, bodyEncoded.length());
			
		  	while(headerEncoded.endsWith('='))
			{
			   	header += ' ';
			   	headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header + '\r\n\r\n'));
			}
 
      		if(last4Bytes.endsWith('==')) 
			{
			    last4Bytes = last4Bytes.substring(0,2) + '0K';
			    bodyEncoded = bodyEncoded.substring(0, bodyEncoded.length()-4) + last4Bytes;
			    String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
			    bodyBlob = EncodingUtil.base64Decode(headerEncoded + bodyEncoded + footerEncoded);
			}
      		else if(last4Bytes.endsWith('='))
      		{
       			last4Bytes = last4Bytes.substring(0,3) + 'N';
        		bodyEncoded = bodyEncoded.substring(0, bodyEncoded.length()-4) + last4Bytes;
        		footer = '\n' + footer;
        		String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
        		bodyBlob = EncodingUtil.base64Decode(headerEncoded + bodyEncoded + footerEncoded);      
      		}
      		else 
			{
			    // Prepend the CR LF to the footer
			    footer = '\r\n' + footer;
			    String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
			    bodyBlob = EncodingUtil.base64Decode(headerEncoded + bodyEncoded + footerEncoded);  
			}
 
      		req.setMethod('POST');
      		req.setTimeout(120000);
      		req.setBodyAsBlob(bodyBlob);
 			req.setHeader('Authorization', 'Bearer ' + accessToken);
 			req.setHeader('Content-Type', 'multipart/form-data; boundary=' + boundary);
			req.setHeader('Content-Length', String.valueof(req.getBodyAsBlob().size()));
			req.setEndpoint('https://upload.box.com/api/2.0/files/content?parent_id=0');
			
      		HTTPResponse res = h.send(req);
      		 
      		//Fill blank 
            file = null;
            filetype='';
            filename='';
        }
    }
    
    //Method to get all files
    public void allFiles()
    {
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        Set<String> setOfNames = new Set<String>();
        
        //Set methods into req to get all files
        req.setMethod('GET');
        req.setTimeout(60 * 1000);
        req.setHeader('Authorization', 'Bearer ' + accessToken);
        req.setEndpoint('https://api.box.com/2.0/folders/0');
        HttpResponse res = h.send(req);
        String resp = res.getBody();
        
        //replace variable name
       	JsonWrapper jsp = JsonWrapper.parse(resp.replace('"limit"','"limit1"').replace('"by"','"by1"'));
       	//create json wrapper list
        List<JsonWrapper.cls_entries> entries = jsp.item_collection.entries;
        
        //Add name and id in wrapper list
        for(JsonWrapper.cls_entries entry : entries)
        { 
        	BoxDriveWrapper tempWrapper = new BoxDriveWrapper();
        	if(entry.id != fileId)
        	{
	            tempWrapper.file_Name = entry.name;
	            tempWrapper.file_Id = entry.id;
	            boxWrapperSet.add(tempWrapper); 
        	}    
        }
        
        //Add set into wrapper list
        boxWrapperList = new List<BoxDriveWrapper>();
        boxWrapperList.addAll(boxWrapperSet);
		boxWrapperSet = new Set<BoxDriveWrapper>();
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
            req.setEndpoint('https://api.box.com/2.0/files/' + fileId);
            
            //get response
            HttpResponse res = h.send(req);
	    	allFiles();
        }
    }
    
    //Method to download file
    public void DownloadFile()
    {
    	if(fileId != null)
    	{
		 	Http h = new Http();
	        HttpRequest req = new HttpRequest();
	        
	        //set request method
	        req.setMethod('GET');
	        req.setHeader('Authorization', 'Bearer ' + accessToken);
	        req.setEndpoint('https://api.box.com/2.0/files/' + fileId + '/content');
	        
	        HttpResponse res = h.send(req);
	        
	        //get download url
	        dwnldUrl = res.getHeader('Location');
    	}
    }
    
    //Wrapper class
    public class BoxDriveWrapper
    {
    	//Public data members
    	public String file_Id {get; set;}
    	public String file_Name {get; set;}
    }

}