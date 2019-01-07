global with sharing class WS_SharePointToSFActionController
{
    /*
        > Method to create folder. 
        > Only Root folder we can't by using this method. 
        > Following Parameters are accepted >> 
            i)   folderName : Name of folder. 
            ii)  parentFolderId : Salesforce Id of the Parent Folder,  Parent folder will be Root or any other folder. 
            iii) sObjectRelatedRecordId : Salesforce id of the sObject record (Account / opportunity etc.)  that the direcotry is belong. 
    */
    webService static String createFolder(String folderName, String parentFolderId)
    {
        if(folderName == null || folderName == '')
        {
            return 'Invalid folder name, please enter appropiate forlder name.';
        }
        if(parentFolderId == null || parentFolderId == '')
        {
            return 'Folder should be child of Root folder or any other folder. Service to create Root folder is not available.';
        }
        
        
        Map<String, String> prefixSObjectTypeMap = new Map<String, String>();
        prefixSObjectTypeMap = getPrefixSObjectTypeMap();    // Method to get the sObject type based on record Id (e.g  Id: 0015000001LmK3x, sObject Type is Account)
        //String sObjectType = prefixSObjectTypeMap.get(String.valueOf(sObjectRelatedRecordId).substring(0,3));
        Boolean sameNameFolder = false;
        String FolderId;
        if(parentFolderId != null && folderName != null ){
            for(Folder__c  fc: [Select Name,parent_folder__c From Folder__c Where parent_folder__c =:parentFolderId]){
                if(fc.id !=null  && (fc.name).equalsIgnoreCase(folderName)){
                    sameNameFolder = true;
                    FolderId = fc.id;
                }
            }
            if(sameNameFolder ){
                return FolderId;
            }
        }
        if(!sameNameFolder){
            if(Schema.sObjectType.folder__c.isAccessible()  && Schema.sObjectType.folder__c.fields.name.isAccessible() && Schema.sObjectType.folder__c.fields.Element_Number__c.isAccessible() && Schema.sObjectType.folder__c.fields.Levels__c.isAccessible() && Schema.sObjectType.folder__c.fields.Parent_Folder__c.isAccessible() && Schema.sObjectType.folder__c.fields.Folder_Path__c.isAccessible() && Schema.sObjectType.folder__c.fields.sObject_Record_ID__c.isAccessible() && Schema.sObjectType.folder__c.fields.sObject_Type__c.isAccessible()){
                Folder__c folder = new Folder__c();
                folder.name = folderName;
                folder.parent_folder__c  = parentFolderId;
                //folder.sObject_Record_ID__c = sObjectRelatedRecordId;
                //folder.sObject_Type__c = sObjectType ;
               if(Folder__c.sObjectType.getDescribe().isCreateable()){
                insert folder;
               }
              
                if(folder.id != null)
                {
                    return folder.id ;
                }
                else
                {
                    return 'Operation failed. Please contact to system admin.';
                }
            }
        }
        return null;
    }
    /*
        > Method to delete Folder by passing Salesforce forlder Id.
        > It will delete sub folders and files.
        > We cannot delete ROOT folder by this method.
        > Take a Salesforce folder Id as a parameter.
    */
    webservice static String deleteFolder(String folderId)
    {    
        if(folderId == null || folderId =='')
        {
            return 'Invalid folder Id';
        }
        IF(Schema.sObjectType.Folder__c.isAccessible() && Schema.sObjectType.Folder__c.fields.name.isAccessible() && Schema.sObjectType.Folder__c.fields.Folder_Path__c.isAccessible() && Schema.sObjectType.Folder__c.fields.Node_Number__c.isAccessible() &&  Schema.sObjectType.Folder__c.fields.sObject_Record_ID__c.isAccessible()){

            list<Folder__c> FolderList = [SELECT id, Node_Number__c, sObject_Record_ID__c FROM Folder__c WHERE id =: folderId];
            if(FolderList.size() > 0)
            {
                if(FolderList[0].Node_Number__c == null || FolderList[0].sObject_Record_ID__c == null)
                {
                    return 'Invalid folder, please contact to System Admin. Delete operation is failed.';
                }
                else if(FolderList[0].Node_Number__c == '0')
                {
                    return 'You cannot delete the Root folder.';
                }
                else
                {
                    String nodeNumberStartWith = FolderList[0].Node_Number__c+'%';
                    map<id, folder__c> folderMap = new map<id, folder__c>([SELECT id FROM folder__c 
                                                                           WHERE sObject_Record_ID__c =: FolderList[0].sObject_Record_ID__c AND
                                                                           Node_Number__c Like: nodeNumberStartWith ]);
                    
                    if(folderMap.keySet().size() > 0 && (Schema.sObjectType.File__c.isAccessible() && Schema.sObjectType.File__c.fields.name.isAccessible()))
                    {
                        list<File__c> FileListForDelete = [SELECT id FROM File__c WHERE folder__c IN: folderMap.keySet()];
                        
                        if(FileListForDelete.size() > 0 && Schema.sObjectType.File__c.isDeletable())
                        {
                            delete FileListForDelete;
                        }
                        if(Schema.sObjectType.folder__c.isDeletable()){
                            delete folderMap.values();
                        }
                        
                        return 'Folder, related subfolders and Files are deleted successfully.';
                    }
                }
                
            }
            else
            {
                return 'Folder is not exist in Salesforce';
            }
            if(FolderList.size() > 0 && Schema.sObjectType.folder__c.isDeletable())
            {
                delete FolderList;
                return 'Folder deleted successfully';
            }
        }
        return null;
    }
    
    /*
        > Method to create file in Salesforce. 
        > Following parameters are required - 
            i) fileName   : Name of file. Extension should we include the file.
            ii) fileURL   : Sharepoint file URL. 
            iii) fileSize : Size of the File, size should be in bytes. (E.g 2 KB file means value of filesize will be 2048)
            iV) folderId  : Salesforce folder ID, where the file will store. 
    */
    webservice static String createFile(String fileName, String fileURL, Integer fileSize, String folderId)
    {
        if(fileName == null || fileName =='')
        {
            return 'Please name is required. Failed to create file'; 
        }
        else
        {
          if(Schema.sObjectType.File__c.isAccessible() && Schema.sObjectType.File__c.fields.name.isAccessible()  && Schema.sObjectType.File__c.fields.File_Path__c.isAccessible() && Schema.sObjectType.File__c.fields.File_Size__c.isAccessible() && Schema.sObjectType.File__c.fields.File_Source__c.isAccessible() && Schema.sObjectType.File__c.fields.File_Type__c.isAccessible() && Schema.sObjectType.File__c.fields.Folder__c.isAccessible() && Schema.sObjectType.File__c.fields.sObject_Type__c.isAccessible() && Schema.sObjectType.File__c.fields.URL__c.isAccessible()){  
              String sameNameFileId = null;
              if(folderId != null && fileName != null ){
                for(File__c fil : [Select id,Name,File_Type__c,Folder__c from File__c Where Folder__c=: folderId]) {
                    if(fil.id !=null){
                        String FileNameOnSF =fil.name+'.'+fil.File_Type__c;
                        if((FileNameOnSF).equalsIgnoreCase(fileName)){
                            sameNameFileId =fil.id; 
                        }
                    }
                }
                  if(sameNameFileId != null){
                      return sameNameFileId;
                  }
              }
              System.debug('sameNameFileId'+sameNameFileId);
              if(sameNameFileId == null){
                File__c file = new File__c();
                if(fileName.contains('.'))
                {
                    file.name = fileName.substringBefore('.');
                    file.File_Type__c = fileName.substringAfter('.');
                }
                else
                {
                    file.name = fileName;
                }
                
                file.URL__c = (fileURL != null? fileURL:'');
                file.File_Size__c = (fileSize != null? fileSize:0);
                file.Folder__c = folderId;
                file.File_Source__c = 'Sharepoint';
                if(File__c.sObjectType.getDescribe().isCreateable()){
                    insert file;
                }
                
                if(file.id != null)
                {
                    //return 'File created successfully.';
                    return file.id;
                }
            }
              }
        }
        return null;
    }
    
    /*
        > Method to delete Salesforce custom file.
        > Taking the URL (Sharepoint URL) as a parameter and to identify the File. 
    */
    webservice static String deleteFile(String fileURL)
    {
        if(fileURL == null || fileURL =='')
        {
            return 'File is not exist in Salesforce, please contact to System Administrator.';
        }
        else
        {
            if(Schema.sObjectType.File__c.isAccessible() && Schema.sObjectType.File__c.fields.name.isAccessible()){
                list<file__c> fileList = [SELECT id FROM file__c WHERE URL__c =: fileURL];
                if(fileList.size() > 0 && Schema.sObjectType.File__c.isDeletable())
                {
                    delete fileList;
                    return 'File deleted successfully.';
                }
                else
                {
                    return 'File not found with specified URL.';
                }
            }
        }
        return null;
    }
    
     /*
        > Method to Move folders. 
        > Only Root folder we can't by using this method. 
        > Following Parameters are accepted >> 
            i)   folderId: Current folder's salesforce id to which you want move in salesforce. 
            ii)  targetFolderId: Salesforce Id of the target  Folder,where you want to move folder in salesforce. 
     */
    webservice static String moveFolder(String folderId,String targetFolderId)
    {
        if(folderId == null || folderId ==''){
            return 'Invalid folder Id , please enter appropiate forlder Id .';
        }
        else if(targetFolderId == null || targetFolderId ==''){
             return 'Invalid target Folder Id  , please enter appropiate target forlder Id .';
        }
        
        else{
            Boolean isSameNameFolder = false;
            String folderIds;
            if(folderId != null  && (Schema.sObjectType.folder__c.isAccessible()  && Schema.sObjectType.folder__c.fields.name.isAccessible() && Schema.sObjectType.folder__c.fields.Element_Number__c.isAccessible()  && Schema.sObjectType.folder__c.fields.Parent_Folder__c.isAccessible() && Schema.sObjectType.folder__c.fields.Folder_Path__c.isAccessible() && Schema.sObjectType.folder__c.fields.sObject_Record_ID__c.isAccessible() && Schema.sObjectType.folder__c.fields.sObject_Type__c.isAccessible())){
                String targetFolderPath;
                //System.debug('targetFolderId::: '+targetFolderId );
                List<Folder__c> folderList =[Select id,Name,parent_folder__c,sObject_Record_ID__c,Folder_Path__c,Node_Number__c From Folder__c where Id=:folderId];
               
                if(folderList != null && folderList.size() > 0){
                    List<Folder__c> ListOfParentfolders =[Select id,Name,parent_folder__c,sObject_Record_ID__c,Folder_Path__c,(Select id,Name,parent_folder__c,sObject_Record_ID__c,Folder_Path__c From Folders__r) From Folder__c Where id =:targetFolderId];
                    if(ListOfParentfolders.size() > 0){
                        targetFolderPath = ListOfParentfolders[0].Folder_Path__c;
                        if(ListOfParentfolders[0].Folders__r.size() > 0){
                            for(Folder__c  fc: ListOfParentfolders[0].Folders__r){
                                if(fc.name !=null  && (fc.name).equalsIgnoreCase(folderList[0].Name)){
                                    isSameNameFolder = true;
                                    folderIds = fc.id;
                                }
                            }
                        }
                        System.debug('targetFolderPath 2:'+targetFolderPath);
                    }
                }
                if(isSameNameFolder){
                    return folderIds;
                }
                else{
                    if(folderList != null && folderList.size() > 0 && Schema.sObjectType.folder__c.fields.name.isUpdateable() && Schema.sObjectType.folder__c.fields.Parent_Folder__c.isUpdateable()){
                        String selectFolderNodeNum,olderfolderpath;
                        Set<Id> setOfFoldersIds =  new Set<Id>() ;
                        
                        for(Folder__c fol : folderList){
                            fol.Parent_Folder__c = targetFolderId;
                            selectFolderNodeNum =fol.Node_Number__c;
                            olderfolderpath = fol.Folder_Path__c;
                            setOfFoldersIds.add(fol.Id);
                        }
                        
                        List<Folder__c >  listOfchildFolders = new List<Folder__c>();
                        
                        for(Folder__c chilfold : [Select Id,Name,parent_folder__c,sObject_Record_ID__c,Folder_Path__c,Node_Number__c from Folder__c Where Node_Number__c like: selectFolderNodeNum + '%' And sObject_Record_ID__c =:folderList[0].sObject_Record_ID__c]){
                            if(chilfold != null && chilfold.id !=folderId){
                                listOfchildFolders.add(chilfold);
                                setOfFoldersIds.add(chilfold.Id);
                            }
                        }
                        System.debug('listOfchildFolders'+listOfchildFolders);
                        
                        if(folderList.size() > 0 && Folder__c.sObjectType.getDescribe().isUpdateable()){
                            update folderList;
                            
                            if(listOfchildFolders != null && listOfchildFolders.size() > 0){
                                update listOfchildFolders; 
                            }
                            
                        }
                        if(setOfFoldersIds != null && setOfFoldersIds.size() > 0){
                            if(Schema.sObjectType.File__c.fields.name.isAccessible()  && Schema.sObjectType.File__c.fields.File_Path__c.isAccessible() && Schema.sObjectType.File__c.fields.File_Size__c.isAccessible() && Schema.sObjectType.File__c.fields.File_Source__c.isAccessible() && Schema.sObjectType.File__c.fields.File_Type__c.isAccessible() && Schema.sObjectType.File__c.fields.Folder__c.isAccessible() && Schema.sObjectType.File__c.fields.sObject_Type__c.isAccessible() && Schema.sObjectType.File__c.fields.URL__c.isAccessible()){
                                List<File__c>  ListOfMoveFiles = [Select Id,name,File_Path__c,File_Size__c,File_Source__c,File_Type__c,Folder__c,sObject_Type__c,URL__c From File__c Where  Folder__c In:setOfFoldersIds]; 
            
                                for(File__c  fil : ListOfMoveFiles){
                                    if(fil.id != null && Schema.sObjectType.File__c.fields.Folder__c.isUpdateable() && Schema.sObjectType.File__c.fields.URL__c.isUpdateable()){    
                                        String newFolderpathOffile =targetFolderPath +'/'+folderList[0].Name;
                                        
                                        String urlPathToupdate  = (fil.URL__c).replace(olderfolderpath,newFolderpathOffile);
                                        //System.debug('urlPathToupdate::::' +urlPathToupdate);
                                       
                                        fil.URL__c =urlPathToupdate != null ?urlPathToupdate: fil.URL__c;
                                    }
                                }
                            
                                if(Schema.sObjectType.File__c.isUpdateable()){
                                    update ListOfMoveFiles;
                                }
                            }
                        }
                        return folderList[0].id;
                    }
                }
            }
        }
        return null;
    }
    
    /*
        > Method to move file in Salesforce. 
        > Following parameters are required - 
            i) fileName   : Name of file. Extension should we include the file.
            ii) fileURL   : updated Sharepoint file URL. 
            iii) currentFolderId: current folder id  where file exist,before move. 
            iV) targetFolderId : target folder id  where you want to move file. 
    */
    
    webservice static String movefile(String currentFolderId,String targetFolderId,String fileUrl,String fileName){
       if(fileURL == null || fileURL=='') {
            return 'File is not exist in Salesforce, please contact to System Administrator.';
        }
        else  if(currentFolderId== null || currentFolderId =='') {
            return 'Invalid folder Id , please enter appropiate forlder Id .';
        }
        else if(targetFolderId == null || targetFolderId ==''){
             return 'Invalid target Folder Id  , please enter appropiate target forlder Id .';
        }
        else if(fileName == null || fileName =='') {
             return 'Please file name is required.';
        }
        else{
            if(currentFolderId != null && fileName != null){ 
                if(Schema.sObjectType.File__c.fields.name.isAccessible()  && Schema.sObjectType.File__c.fields.File_Path__c.isAccessible() && Schema.sObjectType.File__c.fields.File_Size__c.isAccessible() && Schema.sObjectType.File__c.fields.File_Source__c.isAccessible() && Schema.sObjectType.File__c.fields.File_Type__c.isAccessible() && Schema.sObjectType.File__c.fields.Folder__c.isAccessible() && Schema.sObjectType.File__c.fields.sObject_Type__c.isAccessible() && Schema.sObjectType.File__c.fields.URL__c.isAccessible()){
                    //System.debug('currentFolderId:::'+currentFolderId +'targetFolderId ::'+targetFolderId +'fileName '+fileName  +'fileUrl'+fileUrl);
                    String sameNameFileId = null;
                    for(File__c fil : [Select id,Name,File_Type__c,Folder__c from File__c Where Folder__c=: targetFolderId]) {
                        if(fil.id !=null){
                            String FileNameOnSF =fil.name+'.'+fil.File_Type__c;
                            if((FileNameOnSF).equalsIgnoreCase(fileName)){
                                sameNameFileId =fil.id; 
                            }
                        }
                    }
                    if(sameNameFileId != null){
                        return sameNameFileId;
                    }
                    else{
                        String fileNameofSharePoint = fileName.substringBefore('.');
                        List<File__c>  ListOfMoveFiles  = [Select Id,name,File_Path__c,File_Size__c,File_Source__c,File_Type__c,Folder__c,sObject_Type__c,URL__c From File__c Where  Folder__c =:currentFolderId And Name =:fileNameofSharePoint limit 1]; 
                        System.debug('ListOfMoveFiles');
                       
                        for(File__c  fil : ListOfMoveFiles){
                            if(fil.id != null && Schema.sObjectType.File__c.fields.Folder__c.isUpdateable() && Schema.sObjectType.File__c.fields.URL__c.isUpdateable()){    
                                fil.Folder__c = targetFolderId != null? targetFolderId:fil.Folder__c;
                                fil.URL__c =fileUrl!= null ?fileUrl: fil.URL__c;
                            }
                        }
                        
                        if(ListOfMoveFiles.size() > 0 && Schema.sObjectType.File__c.isUpdateable()){
                            update ListOfMoveFiles;
                            return ListOfMoveFiles[0].id ; 
                        }
                    }
                }
            }   
        }
        return null;
    }
    
     /*
        > Method to rename folder. 
        > Only Root folder we can't by using this method. 
        > Following Parameters are accepted >> 
            i)   folderName : New Name of folder. 
            ii)  FolderId : Salesforce Id of the Folder,to which you want Rename. 
    */
    
    webService static String reNameFolder(String folderName, String folderId) {
    
    
        if(folderName == null || folderName == '') {
            return 'Invalid folder name, please enter appropiate forlder name.';
        }
        if(folderId == null || folderId == '') {
            return 'Folder should be child of Root folder or any other folder. Service to create Root folder is not available.';
        }
        else{
            if(Schema.sObjectType.folder__c.isAccessible()  && Schema.sObjectType.folder__c.fields.name.isAccessible() && Schema.sObjectType.folder__c.fields.Element_Number__c.isAccessible()  && Schema.sObjectType.folder__c.fields.Parent_Folder__c.isAccessible() && Schema.sObjectType.folder__c.fields.Folder_Path__c.isAccessible() && Schema.sObjectType.folder__c.fields.sObject_Record_ID__c.isAccessible() && Schema.sObjectType.folder__c.fields.sObject_Type__c.isAccessible() && Schema.sObjectType.folder__c.fields.Element_Number__c .isAccessible()){
                String parentfolderId;
                List<Folder__c> folderlist = [Select id,Name,parent_folder__c,sObject_Record_ID__c,Folder_Path__c,Node_Number__c From Folder__c where Id=:folderId]; 
                if(folderlist != null && folderlist.size() > 0){
                    parentfolderId = folderlist[0].parent_folder__c;
                    
                    List<Folder__c> rootfolderlist = [Select id,Name,sObject_Record_ID__c from Folder__c  where sObject_Record_ID__c =:folderlist[0].sObject_Record_ID__c And Element_Number__c =:0];
                    System.debug('rootfolderlist '+rootfolderlist);
                    Boolean isRootFolder = false;
                    if(rootfolderlist!= null && rootfolderlist.size() > 0 ){
                        if(rootfolderlist[0].Id == folderId)
                        isRootFolder = true;
                    }
                    if(isRootFolder ){
                        return 'You cannot reName Root folder,Please provide appropriate folderId ';
                    }
                    if(parentfolderId != null && (!isRootFolder)){
                        Boolean sameNameFolder = false;
                        String sameNameFolderId;
                        if(parentFolderId != null && folderName != null ){
                            for(Folder__c  fc: [Select Name,parent_folder__c From Folder__c Where parent_folder__c =:parentFolderId]){
                                if(fc.id !=null  && (fc.name).equalsIgnoreCase(folderName)){
                                    sameNameFolder = true;
                                    sameNameFolderId= fc.id;
                                }
                            }
                            if(sameNameFolder && sameNameFolderId != null ){
                                return sameNameFolderId;
                            }
                            else{
                                String selectFolderNodeNum,olderfolderpath;
                                Set<Id> setOfFoldersIds =  new Set<Id>() ;
                                
                                for(Folder__c fol : folderList){
                                    fol.Name= folderName;
                                    selectFolderNodeNum =fol.Node_Number__c;
                                    olderfolderpath = fol.Folder_Path__c;
                                    setOfFoldersIds.add(fol.Id);
                                }
                                List<Folder__c >  listOfchildFolders = new List<Folder__c>();
                                
                                for(Folder__c chilfold : [Select Id,Name,parent_folder__c,sObject_Record_ID__c,Folder_Path__c,Node_Number__c from Folder__c Where Node_Number__c like: selectFolderNodeNum + '%' And sObject_Record_ID__c =:folderList[0].sObject_Record_ID__c]){
                                    if(chilfold != null && chilfold.id !=folderId){
                                        listOfchildFolders.add(chilfold);
                                        setOfFoldersIds.add(chilfold.Id);
                                    }
                                }
                                System.debug('listOfchildFolders'+listOfchildFolders);
                                if(folderList.size() > 0 && Schema.sObjectType.Folder__c.isUpdateable()){
                                    update folderList;
                                    
                                    if(listOfchildFolders != null && listOfchildFolders.size() > 0){
                                        update listOfchildFolders; 
                                    }
                                    
                                }
                                if(setOfFoldersIds != null && setOfFoldersIds.size() > 0){
                                    if(Schema.sObjectType.File__c.fields.name.isAccessible()  && Schema.sObjectType.File__c.fields.File_Path__c.isAccessible() && Schema.sObjectType.File__c.fields.File_Size__c.isAccessible() && Schema.sObjectType.File__c.fields.File_Source__c.isAccessible() && Schema.sObjectType.File__c.fields.File_Type__c.isAccessible() && Schema.sObjectType.File__c.fields.Folder__c.isAccessible() && Schema.sObjectType.File__c.fields.sObject_Type__c.isAccessible() && Schema.sObjectType.File__c.fields.URL__c.isAccessible() && Schema.sObjectType.File__c.fields.URL__c.isUpdateable()){
                                        List<File__c>  ListOfMoveFiles = [Select Id,name,File_Path__c,File_Size__c,File_Source__c,File_Type__c,Folder__c,sObject_Type__c,URL__c From File__c Where  Folder__c In:setOfFoldersIds]; 
                                        System.debug('ListOfMoveFiles ::::'+ListOfMoveFiles );
                                       
                                        for(File__c  fil : ListOfMoveFiles){
                                            if(fil.id != null && Schema.sObjectType.File__c.fields.Folder__c.isUpdateable() && Schema.sObjectType.File__c.fields.URL__c.isUpdateable()){    
                                                String folderpath =folderList[0].Folder_Path__c.substringBeforeLast('/');
                                                String newFolderpathOffile  =  folderpath +'/'+folderlist[0].Name;
                                                // System.debug('new path::::' +newFolderpathOffile);
                                                //System.debug('olderfolderpath::::' +olderfolderpath);
                                                String urlPathToupdate  = (fil.URL__c).replace(olderfolderpath,newFolderpathOffile);
                                                System.debug('urlPathToupdate::::' +urlPathToupdate);
                                               
                                                fil.URL__c =urlPathToupdate != null ?urlPathToupdate: fil.URL__c;
                                                folderpath =null;
                                            }
                                        }
                                    
                                        if(Schema.sObjectType.File__c.isUpdateable()){
                                            update ListOfMoveFiles;
                                        }
                                    }
                                }
                                return folderList[0].id;
                            }
                        }
                    }
                }
            }
        }
        return null;
    }
    
    public static Map<String, String> getPrefixSObjectTypeMap(){
        Map<String,String> keys = new Map<String,String>();
        Map<String,Schema.SobjectType> describe = Schema.getGlobalDescribe();
        for(String s:describe.keyset())
        keys.put(describe.get(s).getDescribe().getKeyPrefix(),s);
        return keys;
    }
}