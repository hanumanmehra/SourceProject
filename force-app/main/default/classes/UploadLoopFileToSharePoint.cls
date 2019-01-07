public with sharing class UploadLoopFileToSharePoint
{
    public static void uploadChatterFile(set<id> cvIdSet, list<String> fileNameList, map<id, id> contentVersionParentIdMap)
    {
        Map<String, String> prefixSObjectTypeMap = new Map<String, String>();
        prefixSObjectTypeMap = getPrefixSObjectTypeMap();
        Folder__c rootfld = new Folder__c();
        Folder__c Chatterfld = new Folder__c();
        if(contentVersionParentIdMap.values().size() > 0)
        {
            list<id> ParentIdlist = contentVersionParentIdMap.values();
            for(id pid : ParentIdList)
            {
                rootfld = checkAndCreateRootFolder(pid, prefixSObjectTypeMap.get(String.valueOf(pid).substring(0,3)));
                Chatterfld = checkAndCreateChatterFilesFolder(rootfld.id, prefixSObjectTypeMap.get(String.valueOf(pid).substring(0,3)), pid);
            }
        }
            if(!Test.isRunningTest())
            uploadFileToSharePoint(rootfld.id, Chatterfld.id , cvIdSet, fileNameList, contentVersionParentIdMap );
    }
    @Future(callout=true)
    public Static void uploadFileToSharePoint(id rootfldId, id ChatterfldId , set<id> cvIdSet, list<String> fileNameList, map<id, id> contentVersionParentIdMap )
    {
        if((Schema.sObjectType.Folder__c.isAccessible() && Schema.sObjectType.contentVersion.isAccessible()  && Schema.sObjectType.File__c.isAccessible())){
            if(Schema.sObjectType.Folder__c.fields.name.isAccessible() && Schema.sObjectType.Folder__c.fields.Folder_Path__c.isAccessible() && Schema.sObjectType.Folder__c.fields.Parent_Folder__c.isAccessible() && Schema.sObjectType.Folder__c.fields.Root_Name__c.isAccessible() &&  Schema.sObjectType.Folder__c.fields.sObject_Record_ID__c.isAccessible() &&  Schema.sObjectType.Folder__c.fields.sObject_Type__c.isAccessible()){
                list<Folder__c> folderList = [SELECT id, Name, Folder_Path__c, Parent_Folder__c, Root_Name__c, sObject_Record_ID__c, sObject_Type__c FROM folder__c WHERE id =: rootfldId OR id =: ChatterfldId];
                Folder__c rootfld = new Folder__c();
                Folder__c Chatterfld  = new Folder__c();
                
                if(folderList.size() > 0)
                {
                    for(folder__c fld : folderList)
                    {
                        if(fld.Parent_Folder__c != null)
                        {
                            Chatterfld = fld;
                        }
                        else
                        {
                            rootfld = fld;
                        }
                    }
                }
           
                if(cvIdSet.size() > 0)
                {
                    if(Schema.sObjectType.contentVersion.fields.title.isAccessible() && Schema.sObjectType.contentVersion.fields.FileType.isAccessible() && Schema.sObjectType.contentVersion.fields.VersionData.isAccessible() && Schema.sObjectType.contentVersion.fields.ContentSize.isAccessible() && Schema.sObjectType.contentVersion.fields.FileExtension.isAccessible() ){
                        list<contentVersion> contentVersionList = new list<contentVersion>();
                        contentVersionList  = [SELECT id, title, FileType, ContentSize, VersionData, FileExtension FROM contentVersion WHERE id IN: cvIdSet Limit 10000];
                        list<contentVersion> contentVersionUploadList = new list<contentVersion>();
                        
                        if(contentVersionList.size() > 0)
                        {
                            for(contentVersion cv : contentVersionList)
                            {
                                for(String fileName : fileNameList)
                                {
                                    String contentFileName =cv.title.toLowerCase();
                                    if(contentFileName.contains(fileName.toLowerCase()))
                                    {
                                        contentVersionUploadList.add(cv);
                                    }
                                }
                            }
                        }    
                    
                        if(contentVersionUploadList.size() > 0)
                        {
                            List<SharePonit_File_Upload_Url__c> listOfUrlOfSPFileUpload =[Select Id,Name,  SP_Uploaded_File_Rename_EndPoint__c,SP_File_Upload_EndPoint__c From SharePonit_File_Upload_Url__c order by createdDate DESC limit 1 ];
                            if(listOfUrlOfSPFileUpload  != null && listOfUrlOfSPFileUpload.size() > 0){
                        
                            for(contentVersion cv : contentVersionUploadList)
                            {
                            
                                Blob file;
                                String fileName, fileType, fileSize; 
                               
                                fileName = cv.title+'.'+cv.FileExtension;
                                if(fileName.length() >80){
                                    String fileName_80 =cv.title.substring(0,80-((cv.FileExtension.length())+1));
                                    System.debug('fileName_80:::'+fileName_80);
                                    fileName =fileName_80+'.'+cv.FileExtension;
                                    System.debug('fileName :::'+fileName);
                                }
                                file = cv.VersionData;
                                fileType = cv.FileType;
                                fileSize = String.valueOf(cv.ContentSize);
                            
                                Http h = new Http();
                                HttpRequest req = new HttpRequest();
                                String reqEndPoint =listOfUrlOfSPFileUpload[0].SP_File_Upload_EndPoint__c ;
                                // String reqEndPoint = 'http://54.226.92.191/RESTUploadFile/WCFUploader.svc/StreamFile/';
                                req.setEndpoint(reqEndPoint);  
                                req.setBodyAsBlob(cv.VersionData);       
                                req.setMethod('POST');
                                req.setTimeout(120*1000);
                                HttpResponse res = h.send(req);
                                String resp =  res.getbody();
                                System.debug('resp '+resp);
                            
                                if(resp.contains('{{{')){
                                    String st = resp.substringBetween('{{{','}}}');
                                    system.debug('responce$$$$$$'+st);
                                    string encodedfolderPath = EncodingUtil.urlEncode( Chatterfld.Folder_Path__c,'UTF-8' ); 
                                    string encodedfileName = EncodingUtil.urlEncode(fileName,'UTF-8');
                                    
                                    Http h2 = new Http();
                                    HttpRequest req2 = new HttpRequest();
                                    String endpointOfReturn =listOfUrlOfSPFileUpload[0].SP_Uploaded_File_Rename_EndPoint__c+'?oldFilepath=' + st + '&newFilename=' +encodedfileName 
                                        + '&folderPath='+ encodedfolderPath + '&accountID='+Chatterfld.sObject_Record_ID__c+ '&contentSize=' +fileSize + '&folderID='+Chatterfld.id;
                                    req2.setEndpoint(endpointOfReturn);  
                                    
                                    req2.setMethod('POST');
                                    req2.setTimeout(120*1000);
                                    req2.setHeader('Content-Length', '512'); 
                                    HttpResponse res2 = h2.send(req2);
                                    String resp2 =  res2.getbody();
                                    System.debug('resp2 '+resp2 ); 
                                    
                                    if(resp2.contains('>')){
                                        String urlOfFileUploadedOnSharePoint= resp2 .substringBetween('>','<');
                                        id idsOfSobject =  id.valueof(Chatterfld.sObject_Record_ID__c);
                                        String sObjName = idsOfSobject.getSObjectType().getDescribe().getName();
                                        System.debug('sObjName  '+sObjName );
                                            
                                        //create file in salesforce
                                        if(urlOfFileUploadedOnSharePoint != null && sObjName != null  &&(Schema.sObjectType.File__c.isAccessible() && Schema.sObjectType.File__c.fields.name.isAccessible() && Schema.sObjectType.File__c.fields.File_Type__c.isAccessible() && Schema.sObjectType.File__c.fields.URL__c.isAccessible() && Schema.sObjectType.File__c.fields.File_Path__c.isAccessible() &&  Schema.sObjectType.File__c.fields.File_Size__c.isAccessible() &&  Schema.sObjectType.File__c.fields.Folder__c.isAccessible() &&  Schema.sObjectType.File__c.fields.File_Source__c.isAccessible())){      
                                            Set<String> setOfFilesNameOfSelFolder = new Set<String>();
                                            for(File__c  fil :[Select Id,Name,File_Type__c,URL__c,File_Path__c,Folder__c  From File__c Where Folder__c =:Chatterfld.id]){
                                                if(fil.id != null &&fil.Name != null && fil.File_Type__c != null)
                                                setOfFilesNameOfSelFolder.add(fil.Name+'.'+fil.File_Type__c );
                                            }
                                            if(File__c.sObjectType.getDescribe().isCreateable() && Schema.sObjectType.File__c.fields.name.isCreateable() && Schema.sObjectType.File__c.fields.File_Type__c.isCreateable() && Schema.sObjectType.File__c.fields.URL__c.isCreateable() && Schema.sObjectType.File__c.fields.File_Path__c.isCreateable() &&  Schema.sObjectType.File__c.fields.File_Size__c.isCreateable() &&  Schema.sObjectType.File__c.fields.Folder__c.isCreateable() &&  Schema.sObjectType.File__c.fields.File_Source__c.isCreateable()){
                                                File__c files =  new    File__c();
                                                if(setOfFilesNameOfSelFolder != null && !setOfFilesNameOfSelFolder.contains(fileName)){
                                                    files.Name = fileName.substringBefore('.'); 
                                                    files.URL__c = urlOfFileUploadedOnSharePoint != null ?urlOfFileUploadedOnSharePoint:'' ;
                                                    files.File_Path__c =Chatterfld.Folder_Path__c ;  
                                                    files.File_Size__c =  Integer.valueOf(fileSize);
                                                    files.Folder__c =Chatterfld.id;
                                                    files.File_Type__c = fileName.substringAfter('.');
                                                    files.File_Source__c='Chatter' ;
                                                }
                                                try{
                                                     if(files != null && File__c.sObjectType.getDescribe().isCreateable()){
                                                         insert files;
                                                         System.debug('file record inserted after upload file '+files);
                                                     }
                                                 }   
                                                catch(Exception e){
                                                    System.debug('Error Message on file upload :::::::::'+e.getmessage()+'Line Number::'+e.getLineNumber());
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        }
                    }
                }
            }
        }
    }  
    
    public static folder__c checkAndCreateRootFolder(id parentId, String sObjectType)
    {
        if(parentId != null && sObjectType != null)
        {
            String query = 'SELECT id, Name FROM '+sObjectType +' WHERE id = \''+parentId +'\'';
            list<sObject> sObjList = database.query(query);
            
            if(sObjList.size() > 0)
            {
                if(Schema.sObjectType.Folder__c.isAccessible() && Schema.sObjectType.Folder__c.fields.name.isAccessible() && Schema.sObjectType.Folder__c.fields.Folder_Path__c.isAccessible() && Schema.sObjectType.Folder__c.fields.Parent_Folder__c.isAccessible() && Schema.sObjectType.Folder__c.fields.Root_Name__c.isAccessible() &&  Schema.sObjectType.Folder__c.fields.sObject_Record_ID__c.isAccessible() &&  Schema.sObjectType.Folder__c.fields.sObject_Type__c.isAccessible()){
                    String idValue = (String)sObjList[0].get('id');
                    String nameValue = (String)sObjList[0].get('name');
                    list<folder__c> rootFolder = [SELECT id, Name, Folder_Path__c, Parent_Folder__c, Root_Name__c, sObject_Record_ID__c, sObject_Type__c FROM folder__c 
                                                 WHERE sObject_Record_ID__c =: idValue AND sObject_Type__c =: sObjectType AND Name =: nameValue ];
                    
                    if(rootFolder.size() > 0)
                    {
                        return rootFolder[0];
                    }
                    else
                    {
                        return createNewFolder(nameValue, sObjectType, idValue, null );
                    }
                }
            }
        }
        return null;
    }
    
    public static folder__c checkAndCreateChatterFilesFolder(id parentId, String sObjectType, id sObjectRecordId)
    {
        if(parentId != null && sObjectType != null)
        {
            if(Schema.sObjectType.Folder__c.isAccessible() && Schema.sObjectType.Folder__c.fields.name.isAccessible() && Schema.sObjectType.Folder__c.fields.Folder_Path__c.isAccessible() && Schema.sObjectType.Folder__c.fields.Parent_Folder__c.isAccessible() && Schema.sObjectType.Folder__c.fields.Root_Name__c.isAccessible() &&  Schema.sObjectType.Folder__c.fields.sObject_Record_ID__c.isAccessible() &&  Schema.sObjectType.Folder__c.fields.sObject_Type__c.isAccessible()){
                list<folder__c> rootFolder = [SELECT id, Name, Folder_Path__c, Parent_Folder__c, Root_Name__c, sObject_Record_ID__c, sObject_Type__c FROM folder__c 
                                             WHERE sObject_Record_ID__c =: sObjectRecordId AND sObject_Type__c =: sObjectType AND Name = 'Chatter Files' Limit 1];
                
                if(rootFolder.size() > 0)
                {
                    return rootFolder[0];
                }
                else
                {
                    return createNewFolder('Chatter Files', sObjectType, sObjectRecordId, parentId);
                }
            }
        }
        return null;
    }
    
    public static folder__c createNewFolder(String folderName, String sObjectType, String sObjectRecordId, id ParentFolderId)
    {
        if(Schema.sObjectType.Folder__c.isAccessible() && Schema.sObjectType.Folder__c.fields.name.isAccessible() && Schema.sObjectType.Folder__c.fields.Folder_Path__c.isAccessible() && Schema.sObjectType.Folder__c.fields.Parent_Folder__c.isAccessible() && Schema.sObjectType.Folder__c.fields.Root_Name__c.isAccessible() &&  Schema.sObjectType.Folder__c.fields.sObject_Record_ID__c.isAccessible() &&  Schema.sObjectType.Folder__c.fields.sObject_Type__c.isAccessible()){
            if(Folder__c.sObjectType.getDescribe().isCreateable() && Schema.sObjectType.Folder__c.fields.Name.isCreateable() &&  Schema.sObjectType.Folder__c.fields.sObject_Type__c.isCreateable()  &&  Schema.sObjectType.Folder__c.fields.sObject_Record_ID__c.isCreateable()  &&  Schema.sObjectType.Folder__c.fields.Parent_Folder__c.isCreateable()){
                Folder__c fld = new Folder__c();
                fld.Name = folderName;
                fld.sObject_Type__c  = sObjectType;
                fld.sObject_Record_ID__c = sObjectRecordId;
                
                if(ParentFolderId != null)
                {
                    fld.Parent_Folder__c= ParentFolderId;
                }
                try{
                    if(folder__c.sObjectType.getDescribe().isCreateable()){
                        insert fld;
                    }
                }
                catch(exception ee){
                    System.debug('### - '+ee);
                }
                if(fld.id != null)
                {
                    return [SELECT id, Name, Folder_Path__c, Parent_Folder__c, Root_Name__c, sObject_Record_ID__c, sObject_Type__c FROM folder__c WHERE id =: fld.id Limit 1];
                }
            }
        }
        return null;
    }
    
    public static Map<String, String> getPrefixSObjectTypeMap()
    {
        Map<String,String> keys = new Map<String,String>();
        Map<String,Schema.SobjectType> describe = Schema.getGlobalDescribe();
        for(String s:describe.keyset())
        keys.put(describe.get(s).getDescribe().getKeyPrefix(),s);
        return keys;
    }
}