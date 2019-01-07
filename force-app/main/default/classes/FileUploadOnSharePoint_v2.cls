Public with sharing Class FileUploadOnSharePoint_v2{
    public  Transient Blob file {get; set;}
    public String fileType {get; set;}
    public String fileName {get; set;}
    public Integer fileSize{get;set;}
    public String selectedFolderId;
    
    public FileUploadOnSharePoint_v2(ApexPages.standardController controller){
        selectedFolderId = controller.getRecord().id;   
    }
    
    public Void uploadFile(){
        try{
            if(Schema.sObjectType.Folder__c.isAccessible() && Schema.sObjectType.Folder__c.fields.name.isAccessible()  && Schema.sObjectType.Folder__c.fields.Folder_Path__c.isAccessible() && Schema.sObjectType.Folder__c.fields.sObject_Record_ID__c.isAccessible()){
                list<Folder__c> folderList =  [Select id,Name,Folder_Path__c, sObject_Record_ID__c   from Folder__c where id =:selectedFolderId limit 1];
                if(folderList  != null && folderList.size() > 0){
                     if(file != null){
                         if(fileName != null && fileName.length() <80){
                            String fileTypeIgnoreCase =(fileName.substringAfter('.')).toLowerCase(); 
                            //System.debug('fileTypeIgnoreCase'+fileTypeIgnoreCase );
                            if(fileTypeIgnoreCase =='exe' || fileTypeIgnoreCase =='html' || fileTypeIgnoreCase =='htt' || fileTypeIgnoreCase =='mht'|| fileTypeIgnoreCase =='svg'|| fileTypeIgnoreCase =='swf' || fileTypeIgnoreCase =='thtml'|| fileTypeIgnoreCase =='xhtml') {
                                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'You cannot upload  this type of file'));
                            }
                            else{
                                Boolean sameFileName = false;
                                if(File__c.sObjectType.getDescribe().isAccessible() && Schema.sObjectType.File__c.fields.name.isAccessible() && Schema.sObjectType.File__c.fields.File_Type__c.isAccessible() && Schema.sObjectType.File__c.fields.Folder__c.isAccessible()){
                                    for(File__c  fil :[Select Id,Name,File_Type__c,Folder__c  From File__c Where Folder__c =:selectedFolderId]){
                                        if((fil.id != null && fil.Name != null && fil.File_Type__c != null) && (fil.Name+'.'+fil.File_Type__c).equalsIgnoreCase(fileName)){
                                            SameFileName =True;
                                        }   
                                    }
                                }
                                if(!sameFileName){
                                    uploadFileonSharepoint(file,fileName,fileType,fileSize,folderList[0].id,folderList[0].sObject_Record_ID__c ,folderList[0].Folder_Path__c);
                                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'File Uploaded successfully,Please refresh page after some time '));
                                }
                                else{
                                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'File Uploaded  unsuccessfully.This Name file already exist,please rename file.'));
                                }
                            }
                        }
                        else{
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'File Name length should be less than 80 '));
                        }
                    }
                    else{
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Please select file'));
                    }
                }
            }
        }
        catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,+e.getmessage()));
        }
    }
    
    //callout of file on sharepoint method
    @future(callout=true)
     public Static void uploadFileonSharepoint(Blob file,String fileName,String fileType,Integer fileSize,String selectedFolderId,String SobjectId,String folderPath){
        if(file != null ) {
            List<SharePonit_File_Upload_Url__c> listOfUrlOfSPFileUpload =[Select Id,Name,  SP_Uploaded_File_Rename_EndPoint__c,SP_File_Upload_EndPoint__c From SharePonit_File_Upload_Url__c order by createdDate DESC limit 1 ];
            if(listOfUrlOfSPFileUpload  != null && listOfUrlOfSPFileUpload.size() > 0){ 
                Http h = new Http();
                HttpRequest req = new HttpRequest();
                
                String reqEndPoint =listOfUrlOfSPFileUpload[0].SP_File_Upload_EndPoint__c;
                //String reqEndPoint ='https://www.technomileconnect.com/RESTUploadFileSecure/WCFUploader.svc/StreamFile/';
                req.setEndpoint(reqEndPoint);  
                req.setBodyAsBlob(file);    
                req.setMethod('POST');
                req.setTimeout(120*1000);
                System.debug('req'+req);
                
                HttpResponse res = h.send(req);
                String resp =  res.getbody();
                System.debug('resp '+resp);
                
                if(resp.contains('{{{')){
                    file =null;
                    String st = resp.substringBetween('{{{','}}}');
                    system.debug('responce$$$$$$'+st);
                    
                    string encodedfolderPath = EncodingUtil.urlEncode(folderPath,'UTF-8' );
                    string encodedfileName = EncodingUtil.urlEncode(fileName,'UTF-8');
                    
                    String endpointOfReturn =listOfUrlOfSPFileUpload[0].SP_Uploaded_File_Rename_EndPoint__c+'?oldFilepath=' + st + '&newFilename=' +encodedfileName 
                        + '&folderPath='+encodedfolderPath + '&accountID='+SobjectId+ '&contentSize=' +fileSize + '&folderID='+selectedFolderId;
                    
                    //String endpointOfReturn ='https://www.technomileconnect.com/RESTUploadFileSecure/WCFUploader.svc/SP_UploadFile'+'?oldFilepath=' + st + '&newFilename=' +encodedfileName 
                    //    + '&folderPath='+encodedfolderPath + '&accountID='+SobjectId+ '&contentSize=' +fileSize + '&folderID='+selectedFolderId;
                    
                    Http h2 = new Http();
                    HttpRequest req2 = new HttpRequest();
                    req2.setHeader('Content-Length', '512'); 
                    //req2.setHeader('Content-Type', 'multipart/mixed');
                    //req2.setHeader('Content-Disposition', 'form-data' );
                    req2.setEndpoint(endpointOfReturn);      
                    req2.setMethod('POST');
                    req2.setTimeout(120*1000);
                    
                    HttpResponse res2 = h2.send(req2);
                    String resp2 =  res2.getbody();
                    System.debug('resp2 '+resp2 ); 
                    
                    if(resp2 != null && resp2.contains('>')){
                        String urlOfFileUploadedOnSharePoint= resp2 .substringBetween('>','<');
                             
                        id idsOfSobject =  id.valueof(SobjectId);
                        String sObjName = idsOfSobject.getSObjectType().getDescribe().getName();
                            
                        //create file in salesforce
                        if(urlOfFileUploadedOnSharePoint != null && sObjName != null  &&(Schema.sObjectType.File__c.isAccessible() && Schema.sObjectType.File__c.fields.name.isAccessible() && Schema.sObjectType.File__c.fields.File_Type__c.isAccessible() && Schema.sObjectType.File__c.fields.URL__c.isAccessible() && Schema.sObjectType.File__c.fields.File_Path__c.isAccessible() &&  Schema.sObjectType.File__c.fields.File_Size__c.isAccessible() &&  Schema.sObjectType.File__c.fields.Folder__c.isAccessible() &&  Schema.sObjectType.File__c.fields.File_Source__c.isAccessible())){
                            try{
                                Set<String> setOfFilesNameOfSelFolder = new Set<String>();
                                for(File__c  fil :[Select Id,Name,File_Type__c,URL__c,File_Path__c,Folder__c  From File__c Where Folder__c =:selectedFolderId]){
                                    if(fil.id != null &&fil.Name != null && fil.File_Type__c != null)
                                    setOfFilesNameOfSelFolder.add(fil.Name+'.'+fil.File_Type__c );
                                }
                                if(File__c.sObjectType.getDescribe().isCreateable() && Schema.sObjectType.File__c.fields.name.isCreateable() && Schema.sObjectType.File__c.fields.File_Type__c.isCreateable() && Schema.sObjectType.File__c.fields.URL__c.isCreateable() && Schema.sObjectType.File__c.fields.File_Path__c.isCreateable() &&  Schema.sObjectType.File__c.fields.File_Size__c.isCreateable() &&  Schema.sObjectType.File__c.fields.Folder__c.isCreateable() &&  Schema.sObjectType.File__c.fields.File_Source__c.isCreateable()){
                                    File__c   files = new File__c  ();
                                    if(setOfFilesNameOfSelFolder != null && !setOfFilesNameOfSelFolder.contains(fileName)){
                                        files.Name = fileName.substringBefore('.'); 
                                        files.URL__c = urlOfFileUploadedOnSharePoint != null ?urlOfFileUploadedOnSharePoint:'';  
                                        files.File_Size__c =  fileSize ;
                                        files.Folder__c =selectedFolderId;
                                        files.File_Type__c = fileName.substringAfter('.');
                                        files.File_Source__c='Inline' ;
                                    }
                                    if(files != null  &&  Folder__c.sObjectType.getDescribe().isCreateable()){
                                        insert files;
                                    }
                                    //System.debug('file record inserted after upload file '+files);
                                }
                            }   
                            catch(Exception e){
                                System.debug('Error Message on file upload :::::::::'+e.getmessage()+'Line Number::'+e.getLineNumber());
                            }
                        }
                    }
                    filetype='';
                    filename='';  
                }
            }   
        }    
    }            
}