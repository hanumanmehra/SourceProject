Public with sharing class SFSPConnector_V2{
    public String treeStructure{get;set;}
    private list<Folder__c> FolderList;
    private id recordId{get;set;}
    public String selectedFolderId{get;set;}
    public Folder__c newFolder {get;set;}
    private String RootFolderName;
    public list<SelectOption> folderOption{get;set;}
    public map<id, boolean> folderOptionCheckMap ;
    public String selectedFolderToMoveIn{get;set;}
    public map<String ,String> mapOfParentChildfolder;
    public list<wrapper_files> listOfMoveFold_Wr{get;set;}
    public list<wrapper_del_file> listOfDelFile_Wr{get;set;}
    public string NewLableFolder{get;set;}
    public String sObjName ;
    public  String pageName;
    
    public list<Folder__c > listofAllFolders;
    public string selectedFolderName{get;set;}
    
    private map<String, list<file__c>> filesAgainstFolderMap;
    string fileIconURL;
    
    public SFSPConnector_V2(ApexPages.standardController controller)
    {
       if(Schema.sObjectType.Account.isAccessible() && Schema.sObjectType.folder__c.isAccessible() && Schema.sObjectType.Opportunity.isAccessible() ){
            recordId = controller.getRecord().id;
            sObjName ='';
            pageName='';
            
            if(recordId  != null)
            
            sObjName = recordId.getSObjectType().getDescribe().getName();
            Schema.SObjectType  sobj =  recordId.getSObjectType();
            selectedFolderToMoveIn = 'Root';
            NewLableFolder = '';
            folderOption = new list<selectOption>();
            folderOptionCheckMap = new map<id, boolean>();
            mapOfParentChildfolder=  new map<String ,String> ();
            listOfMoveFold_Wr =  new List<wrapper_files>() ;
            listOfDelFile_Wr=  new List<wrapper_del_file>() ;
            listofAllFolders =  new list<Folder__c > () ;
            filesAgainstFolderMap = new map<String, list<file__c>>();
            
            sObject  sObjectRecord =Database.query('Select Id, Name From ' + sObjName + ' Where Id = :recordId '+'limit 1');
            if(sObjectRecord != null ) {
                RootFolderName = (String)sObjectRecord.get('name');
                selectedFolderName =(String)sObjectRecord.get('name');
            }
            pageName = ApexPages.currentPage().getUrl().substringBetween('apex/','?');
            if(Schema.sObjectType.document.isAccessible() && Schema.sObjectType.folder__c.fields.name.isAccessible() )
            {
                list<document> fileIconDocumentList = [SELECT id FROM document WHERE name = 'SFSP_Tree_FileIcon'];
                if(fileIconDocumentList.size() > 0) {
                    fileIconURL = '/servlet/servlet.FileDownload?file='+fileIconDocumentList[0].id;
                }
            }
            init();
        }
    }
    
    public void init()
    {
        treeStructure = '';
        filesAgainstFolderMap = new map<String, list<file__c>>();
        set<id> folderIdSet = new set<id>();
        if(Schema.sObjectType.folder__c.isAccessible()  && Schema.sObjectType.folder__c.fields.name.isAccessible() && Schema.sObjectType.folder__c.fields.Element_Number__c.isAccessible() && Schema.sObjectType.folder__c.fields.Levels__c.isAccessible() && Schema.sObjectType.folder__c.fields.Parent_Folder__c.isAccessible() && Schema.sObjectType.folder__c.fields.Folder_Path__c.isAccessible() && Schema.sObjectType.folder__c.fields.sObject_Record_ID__c.isAccessible() && Schema.sObjectType.folder__c.fields.sObject_Type__c.isAccessible())
        {
            newFolder = new Folder__c();
            String recordId_15;
            if(String.valueof(recordId).length() > 15){
                recordId_15= String.valueof(recordId).substring(0,15);
            }
            else{
                recordId_15=recordId;
            }
            
            list<Folder__c> FoldersList =[SELECT id, name, Element_Number__c, Levels__c, Node_Number__c,Parent_Folder__r.Folder_Path__c, Parent_Folder__c, Parent_Folder__r.Node_Number__c, sObject_Record_ID__c,Folder_Path__c,sObject_Type__c  
                                          FROM Folder__c WHERE Element_Number__c != null AND (sObject_Record_ID__c =: recordId OR sObject_Record_ID__c =: recordId_15 ) ORDER BY Node_Number__c Limit 10000 ];  
            
            map<id, folder__c> folderMap = new map<id, folder__c>();
            if(FoldersList != null && FoldersList.size() > 0){
                for(Folder__c fc: FoldersList ){
                    folderMap.put(fc.id,fc);
                }
            }
            list<Folder__c> FolderList = new list<folder__c>();
            if(folderMap.keySet().size() > 0)
            {
                FolderList = folderMap.values();
                list<file__c> fileList = [SELECT id, name, File_Path__c, Node_Number__c,File_Type__c,folder__c FROM file__c WHERE folder__c IN: folderMap.keySet() limit 10000];
                if(fileList.size() > 0)
                {
                    for(file__c file : fileList)
                    {
                        if(file.Node_Number__c != null && filesAgainstFolderMap.containsKey(file.Node_Number__c))
                        {
                            list<file__c> tempFileList = filesAgainstFolderMap.get(file.Node_Number__c);
                            tempFileList.add(file);
                            filesAgainstFolderMap.put(file.Node_Number__c, tempFileList);
                        }
                        else
                        {
                            list<file__c> tempFileList = new list<file__c>();
                            tempFileList.add(file);
                            filesAgainstFolderMap.put(file.Node_Number__c, tempFileList);
                        }
                    }
                }
            }
            if(FolderList  != null && FolderList.size() > 0)
            {
                treeStructure = '<div id="html1" ><ul id="firstTree" class="tree">';    // Tree Structure Start tags.
                for(Folder__c fld : FolderList)
                {
                    folderIdSet.add(fld.id);
                    treeStructure = generateTreeStructure(treeStructure , fld);
                    String pathoffolder='';
                    if(!folderOptionCheckMap.containsKey(fld.id))
                    {
                        if(fld.Levels__c <=2){
                            pathoffolder =(fld.Folder_Path__c).substringAfter('/');   
                        }
                        else{
                            List<String> listOfpathString =(fld.Folder_Path__c).split('/');
                            if(listOfpathString.Size() > 2){
                                integer listSize = listOfpathString.Size()-1 ; 
                                pathoffolder =fld.Name+'...'+listOfpathString[listSize-2]+'/'+listOfpathString[listSize-1] +'/'+ listOfpathString[listSize];
                            }   
                        }
                        folderOption.add(new selectOption(fld.id,pathoffolder));
                        folderOptionCheckMap.put(fld.id, true);
                        
                        if(mapOfParentChildfolder.containskey(fld.id)){
                            mapOfParentChildfolder.put(fld.Parent_Folder__c,fld.Id);
                        }
                        else{
                            mapOfParentChildfolder.put(fld.Parent_Folder__c,fld.Id);
                        }
                    }
                }
                treeStructure += '</ul></div>';        // Tree Structure End tags.
                listofAllFolders  =  FolderList;
                getGadgetHTMLContent();
            }
            System.debug('### -FolderList  '+FolderList );
            System.debug('### - '+treeStructure );
            System.debug('### folderOption- '+folderOption);      
        }  
    }
    
    public Component.Apex.OutputText getGadgetHTMLContent(){
        Component.Apex.OutputText oppText = new Component.Apex.OutputText(escape = false);
        oppText.value = treeStructure ;       //gadgetcontent is the variable which holds the HTML content
        System.debug('Tree Structure in component method'+oppText.value );
        return oppText ;
    }
    
    public String generateTreeStructure(String treeStructure , Folder__c folder)
    {
        if(folder.Parent_Folder__c == null)    // Root Folder
        {
            treeStructure += '<li ><a href="javascript:void(0);" onclick="getFolderId(\''+folder.id+'\')">'+folder.name+'</a>';//+'</li>BreakROOTBreak';
            if(filesAgainstFolderMap.containsKey(folder.node_number__c))
            {
                list<file__c> filesUnderFolder = filesAgainstFolderMap.get(folder.node_number__c);
                if(filesUnderFolder.size() > 0)
                {
                    treeStructure += '<ul>';
                    for(file__c file : filesUnderFolder)
                    {
                        treeStructure += '<li data-jstree=\'{"icon":"'+fileIconURL +'"}\'><a href="javascript:void(0);" onclick="getFolderId(\''+file.id+'\')">'+file.name+'.'+file.File_Type__c+'</a></li>';
                    }
                    treeStructure += '</ul>';
                }
            }
            treeStructure += '<ul>BreakROOTBreak';
            treeStructure += '</ul></li>';
        }
        else
        {
            if(folder.Element_Number__c == 1)
            {
                String nextLevelStartingNode = '<li>';
                nextLevelStartingNode += '<a href="javascript:void(0);" onclick="getFolderId(\''+folder.id+'\')">';
                nextLevelStartingNode += folder.name;
                nextLevelStartingNode += '</a>';
                System.debug('### 156- '+folder.node_number__c);
                System.debug('### 157- '+filesAgainstFolderMap);
                if(filesAgainstFolderMap.containsKey(folder.node_number__c))
                {
                    list<file__c> filesUnderFolder = filesAgainstFolderMap.get(folder.node_number__c);
                    if(filesUnderFolder.size() > 0)
                    {
                        nextLevelStartingNode += '<ul>';
                        for(file__c file : filesUnderFolder)
                        {
                            nextLevelStartingNode += '<li data-jstree=\'{"icon":"'+fileIconURL +'"}\'><a href="javascript:void(0);" onclick="getFolderId(\''+file.id+'\')">'+file.name+'.'+file.File_Type__c+'</a></li>';
                        }
                        nextLevelStartingNode += '</ul>';
                    }
                }
                
                nextLevelStartingNode += '<ul>Break'+folder.node_number__c+'Break</ul></li>';
                
                treeStructure = adjustTheTree(treeStructure, nextLevelStartingNode, folder);
                System.debug('### 44- '+treeStructure );
            }
            
            else
            {
                String currentLevelNode;
                currentLevelNode = '<li><a href="javascript:void(0);" onclick="getFolderId(\''+folder.id+'\')">'+folder.name+'</a>';
                System.debug('### 182- '+folder.node_number__c);
                System.debug('### 183- '+filesAgainstFolderMap);
                if(filesAgainstFolderMap.containsKey(folder.node_number__c))
                {
                    list<file__c> filesUnderFolder = filesAgainstFolderMap.get(folder.node_number__c);
                    if(filesUnderFolder.size() > 0)
                    {
                        currentLevelNode += '<ul>';
                        for(file__c file : filesUnderFolder)
                        {
                            currentLevelNode += '<li data-jstree=\'{"icon":"'+fileIconURL+'"}\' style="background-size: 20px 20px"><a href="javascript:void(0);" onclick="getFolderId(\''+file.id+'\')">'+file.name+'.'+file.File_Type__c+'</a></li>';
                        }
                        currentLevelNode += '</ul>';
                    }
                }
                
                currentLevelNode += '<ul>Break'+folder.node_number__c+'Break</ul></li>';
                treeStructure = adjustTheTree(treeStructure, currentLevelNode , folder);
                
                System.debug('### 53- '+treeStructure );
            }
        }
        System.debug('### 56- '+treeStructure );
        return treeStructure ;
    }
    
    public String adjustTheTree(String treeStructure, String currentNode, folder__c folder)
    {
        String treenodes;
        
        String breakStr;
        if(folder.Parent_Folder__r.Node_Number__c == null || folder.Parent_Folder__r.Node_Number__c == String.valueOf(0))
        {
            breakStr = 'BreakROOTBreak';
        }
        else
        {
            breakStr = 'Break'+folder.Parent_Folder__r.Node_Number__c+'Break';
        }
        System.debug('breakedTreeList::'+breakStr);
        if(treeStructure.contains(breakStr))
        {
            List<String> breakedTreeList = treeStructure.split(breakStr);
            if(breakedTreeList.size() > 0)
            {
                treenodes = breakedTreeList[0]+breakStr;
                treenodes += currentNode;
                //if(breakedTreeList.size() > 1)
                treenodes += breakedTreeList[1];
                return treenodes;
            }
            
        }
        System.debug('66'+treeStructure);
        return treeStructure;
    }
    
    
    public PageReference createNewFolder()
    {
        if(Schema.sObjectType.folder__c.isAccessible())
        {
            System.debug('### - '+selectedFolderId);
            set<id> folderIdSet = new set<id>();
            if(selectedFolderId != null && Schema.sObjectType.folder__c.isAccessible()  && Schema.sObjectType.folder__c.fields.name.isAccessible() && Schema.sObjectType.folder__c.fields.Folder_Path__c  .isAccessible() && Schema.sObjectType.folder__c.fields.sObject_Record_ID__c .isAccessible())
            {
                if(selectedFolderId  != null && String.isBlank(selectedFolderId ) ){
                    List<Folder__c >    folderListOfchilds  = [SELECT id, name,Folder_Path__c  FROM Folder__c WHERE name =: RootFolderName   AND sObject_Record_ID__c =: recordId Limit 1];
                    if(folderListOfchilds != null && folderListOfchilds.size() > 0)
                    selectedFolderId  =folderListOfchilds [0].id;
                }
                boolean sameName  = false;
                if(selectedFolderId != null  && newFolder.name != null) {
                    for(Folder__c  fc : [SELECT id, name,Folder_Path__c,Parent_Folder__c FROM Folder__c WHERE Parent_Folder__c =: selectedFolderId]){
                       if((fc.name).equalsIgnoreCase(newFolder.name)){
                           sameName  =true;  
                       } 
                    }
                }
                System.debug('selectedFolderId ::'+selectedFolderId );
                if( Folder__c.sObjectType.getDescribe().isCreateable() && Schema.sObjectType.Folder__c.fields.name.isCreateable() && Schema.sObjectType.Folder__c.fields.sObject_Record_ID__c.isCreateable() && Schema.sObjectType.Folder__c.fields.parent_folder__c.isCreateable() && Schema.sObjectType.Folder__c.fields.sObject_Type__c.isCreateable() ){
                    newFolder.sObject_Record_ID__c = recordId;
                    newFolder.parent_folder__c = selectedFolderId;
                    newFolder.sObject_Type__c =sObjName ;
                }
                
                try{
                    if(Folder__c.sObjectType.getDescribe().isCreateable()) {
                        if(sameName  != true && !String.isBlank(newFolder.Name) ){
                            insert newfolder;
                            
                            folderIdSet.add(newfolder.id);
                            createNewFolderOnSharePoint(folderIdSet);
                        }
                        else if(sameName){
                              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'You cannot create same name folder at same level '));    
                        }
                        else if(String.isBlank(newFolder.Name)){
                             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Please provide name of folder in  New folder text field')); 
                        }    
                    }
                    init();
                }
                catch(Exception ee) {
                    System.debug('### - '+ee); 
                }
            }
            else {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Please select Parent Folder.'));
            }
        }         
        return null;
    }
    
    public PageReference createRootFolder()
    { 
        String NewRootFolderId;
        String oldFolderPath;
        boolean isRootFolderCreated =  false;
        if(recordId  != null && Schema.sObjectType.folder__c.isAccessible() && Schema.sObjectType.folder__c.fields.name.isAccessible() && Schema.sObjectType.folder__c.fields.sObject_Record_ID__c.isAccessible()) {
            set<id> folderIdSet = new set<id>();
            list<folder__c> folderList = [SELECT id, name,Folder_Path__c,sObject_Record_ID__c,sObject_Type__c FROM Folder__c WHERE (Name =: RootFolderName OR IsRootFolder__c=:True)  AND sObject_Record_ID__c =: recordId];  
           
            try{        
                if(folderList.isEmpty() && (Folder__c.sObjectType.getDescribe().isCreateable() && Schema.sObjectType.Folder__c.fields.name.isCreateable() && Schema.sObjectType.Folder__c.fields.sObject_Record_ID__c.isCreateable() && Schema.sObjectType.Folder__c.fields.sObject_Type__c.isCreateable() && Schema.sObjectType.Folder__c.fields.IsRootFolder__c.isCreateable() && Schema.sObjectType.Folder__c.isUpdateable()&& Schema.sObjectType.Folder__c.fields.IsRootFolder__c.isUpdateable() && Schema.sObjectType.Folder__c.fields.sObject_Type__c.isUpdateable() && Schema.sObjectType.Folder__c.fields.sObject_Record_ID__c.isUpdateable()))
                {
                    Folder__c rootFolder = new Folder__c();
                    rootFolder.sObject_Record_ID__c = recordId;
                    rootFolder.name = RootFolderName ;
                    rootFolder.sObject_Type__c =sObjName ;
                    rootFolder.IsRootFolder__c = true;
                    
                    if(Folder__c.sObjectType.getDescribe().isCreateable()) {
                        insert rootFolder;
                        System.debug('rootFolder'+rootFolder);
                        if(rootFolder !=  null && rootFolder.name != null ){
                            folderList.add(rootFolder);
                            NewRootFolderId =rootFolder.id;
                            folderList.add(rootFolder);
                            isRootFolderCreated =  true;
                            folderIdSet.add(rootFolder.id);
                            createNewFolderOnSharePoint(folderIdSet);
                        }
                    }
                } 
                else if(folderList.size() > 0 && (RootFolderName  != folderList[0].Name)){
                
                    oldFolderPath =folderList[0].Folder_Path__c;
                    if(Schema.sObjectType.Folder__c.isUpdateable()&& Schema.sObjectType.Folder__c.fields.name.isUpdateable()){
                        folderList[0].Name=RootFolderName; 
                        update folderList;
                        NewRootFolderId =folderList[0].id;
                        isRootFolderCreated = true;
                    }
                   
                    
                    //Future Method callout for ReName Root Folder
                    if(oldFolderPath != null && folderList.size() >0 ){
                        renameFolderOnSharePoint(oldFolderPath,folderList[0].Id,folderList[0].Name); 
                        
                    } 
                }
                //reaname folder and files path 
                    if(folderList.size() > 0){
                        List<Folder__c> listOfAllChildrenFolderOfRoot =[Select id,Name,sObject_Type__c,Folder_Path__c,Parent_Folder__c,sObject_Record_ID__c FROM Folder__c WHERE IsRootFolder__c != true and sObject_Record_ID__c =:folderList[0].sObject_Record_ID__c Limit 10000]; 
                        
                        if(listOfAllChildrenFolderOfRoot != null && listOfAllChildrenFolderOfRoot.size() > 0 && Schema.sObjectType.Folder__c.isUpdateable()){
                            update listOfAllChildrenFolderOfRoot;
                        }  
                        
                        list<File__c> listOfFilesToUpdatePathAndUrl =  new List <File__c>(); 
                        if(Schema.sObjectType.File__c.fields.name.isAccessible()  && Schema.sObjectType.File__c.fields.File_Path__c.isAccessible() && Schema.sObjectType.File__c.fields.File_Size__c.isAccessible() && Schema.sObjectType.File__c.fields.File_Source__c.isAccessible() && Schema.sObjectType.File__c.fields.File_Type__c.isAccessible() && Schema.sObjectType.File__c.fields.Folder__c.isAccessible() && Schema.sObjectType.File__c.fields.sObject_Type__c.isAccessible() && Schema.sObjectType.File__c.fields.URL__c.isAccessible() &&(Schema.sObjectType.File__c.isUpdateable() && Schema.sObjectType.File__c.fields.URL__c.isUpdateable())){
                            for(File__c file : [Select Id,name,File_Path__c,   File_Size__c,File_Source__c,File_Type__c,Folder__c,sObject_Type__c,URL__c,Folder__r.sObject_Record_ID__c From File__c Where  Folder__r.sObject_Record_ID__c  =: folderList[0].sObject_Record_ID__c order by Node_Number__c Limit 50000 ]){
                                if(file != null && file.URL__c != null){
                                    String NewFolderPath =(folderList[0].Folder_Path__c).substringBefore('/') +'/'+RootFolderName;
                                    //System.debug('oldFolderPath'+oldFolderPath +'New folderPath'+NewFolderPath);
                                    String urlPathToupdate  = (file.URL__c).replace(oldFolderPath,NewFolderPath);
                                    //System.debug('urlPathToupdate:::'+urlPathToupdate  );
                                    file.URL__c =  urlPathToupdate;
                                    listOfFilesToUpdatePathAndUrl.add(file);
                                    //System.debug('before update'+listOfFilesToUpdatePathAndUrl);
                                }
                            }
                            if(listOfFilesToUpdatePathAndUrl != null && listOfFilesToUpdatePathAndUrl.size() > 0 && Schema.sObjectType.File__c.isUpdateable() && Schema.sObjectType.File__c.fields.name.isUpdateable()){
                                update listOfFilesToUpdatePathAndUrl ;
                                System.debug('listOfFilesToUpdatePathAndUrl 2:::'+listOfFilesToUpdatePathAndUrl);
                            } 
                        }
                    } 
                init();
                
                PageReference pg;
                if(NewRootFolderId != null){
                    pg = new PageReference('/apex/'+pageName +'?id='+recordId +'&inline=1 &isRootFolderCreated='+isRootFolderCreated);
                    pg.setRedirect(true);
                    return pg;
                }
                else{
                    return null; 
                }
            }
            catch(Exception e){
                System.debug('Error Message :::::::::'+e.getmessage()+'Line Number::'+e.getLineNumber());
            }
        }
        return null;
    }
    
    
    @Future(callout=true)
    public static void createNewFolderOnSharePoint(set<id> folderIdSet)
    {
        if(Schema.sObjectType.folder__c.isAccessible()){
            list<folder__c> folderList = new list<folder__c>();
            folder__c folder = new folder__c();
            
            if(folderIdSet.size() > 0 && (Schema.sObjectType.folder__c.isAccessible()  && Schema.sObjectType.folder__c.fields.name.isAccessible() && Schema.sObjectType.folder__c.fields.Element_Number__c.isAccessible() && Schema.sObjectType.folder__c.fields.Levels__c.isAccessible() && Schema.sObjectType.folder__c.fields.Parent_Folder__c.isAccessible() && Schema.sObjectType.folder__c.fields.Folder_Path__c.isAccessible() && Schema.sObjectType.folder__c.fields.sObject_Record_ID__c.isAccessible() && Schema.sObjectType.folder__c.fields.sObject_Type__c.isAccessible()))
            {
                folderList = [SELECT id, name, Element_Number__c, Levels__c, Node_Number__c, Parent_Folder__c, Parent_Folder__r.Node_Number__c, sObject_Record_ID__c,Folder_Path__c
                                FROM folder__c WHERE id =: folderIdSet];
               
                if(folderList.size() > 0){
                    folder = folderList[0];
                }
            }
            
            //Soap Api callout for create folder 
            wwwTechnomileconnectCom.BasicHttpsBinding_IService1 WS_sharePoint = new wwwTechnomileconnectCom.BasicHttpsBinding_IService1 ();
            boolean resultFlat = WS_sharePoint.SP_CreateFolder(folder.Folder_Path__c, folder.sObject_Record_ID__c, folder.id);
            System.debug('### resultFlat - '+resultFlat );
        }
    }    
     
    public void openFilesFoldersForMove(){
        if(Schema.sObjectType.folder__c.isAccessible() && Schema.sObjectType.File__c.isAccessible()){
            listOfMoveFold_Wr =  new List<wrapper_files>() ;
            List<Folder__c>  folderListOfchilds =  new List<Folder__c>  ();
            
            if(selectedFolderId != null  && !String.isBlank(selectedFolderId )){
                if(Schema.sObjectType.folder__c.isAccessible()  && Schema.sObjectType.folder__c.fields.name.isAccessible() && Schema.sObjectType.folder__c.fields.Element_Number__c.isAccessible() && Schema.sObjectType.folder__c.fields.Levels__c.isAccessible() && Schema.sObjectType.folder__c.fields.Parent_Folder__c.isAccessible() && Schema.sObjectType.folder__c.fields.Folder_Path__c.isAccessible() && Schema.sObjectType.folder__c.fields.sObject_Record_ID__c.isAccessible() && Schema.sObjectType.folder__c.fields.sObject_Type__c.isAccessible() && (Schema.sObjectType.File__c.fields.name.isAccessible()  && Schema.sObjectType.File__c.fields.File_Path__c.isAccessible() && Schema.sObjectType.File__c.fields.File_Size__c.isAccessible() && Schema.sObjectType.File__c.fields.File_Source__c.isAccessible() && Schema.sObjectType.File__c.fields.File_Type__c.isAccessible() && Schema.sObjectType.File__c.fields.Folder__c.isAccessible() && Schema.sObjectType.File__c.fields.sObject_Type__c.isAccessible() && Schema.sObjectType.File__c.fields.URL__c.isAccessible())) {
                    List<Folder__c> listOfRootFolder =[SELECT id, name,(SELECT id, name FROM Folders__r Where Name =:'Chatter Files'),sObject_Record_ID__c  FROM Folder__c WHERE name =: RootFolderName   AND Parent_Folder__c =null And sObject_Record_ID__c =: recordId Limit 1];
                    String chatterFolderId;
                    if(listOfRootFolder.size() > 0 && listOfRootFolder[0].Folders__r.size() > 0){
                        chatterFolderId= listOfRootFolder[0].Folders__r[0].Id;
                    }
                    folderListOfchilds = [SELECT id, name,(Select Id,name,File_Path__c,   File_Size__c,File_Source__c,File_Type__c,Folder__c,sObject_Type__c,URL__c,createddate  From    Files__r Where Folder__c=:selectedFolderId ), Element_Number__c, Levels__c, Node_Number__c, Parent_Folder__c, Parent_Folder__r.Node_Number__c, sObject_Record_ID__c,Folder_Path__c,(SELECT id, name, Element_Number__c, Levels__c, Node_Number__c, Parent_Folder__c, Parent_Folder__r.Node_Number__c, sObject_Record_ID__c,Folder_Path__c  FROM Folders__r Where Id !=: chatterFolderId)
                             FROM folder__c WHERE  Element_Number__c != null AND Id=:selectedFolderId   limit 1];
                }
            }
            else {
                if(Schema.sObjectType.folder__c.isAccessible()  && Schema.sObjectType.folder__c.fields.name.isAccessible() && Schema.sObjectType.folder__c.fields.Element_Number__c.isAccessible() && Schema.sObjectType.folder__c.fields.Levels__c.isAccessible() && Schema.sObjectType.folder__c.fields.Parent_Folder__c.isAccessible() && Schema.sObjectType.folder__c.fields.Folder_Path__c.isAccessible() && Schema.sObjectType.folder__c.fields.sObject_Record_ID__c.isAccessible() && Schema.sObjectType.folder__c.fields.sObject_Type__c.isAccessible() &&  (Schema.sObjectType.File__c.fields.name.isAccessible()  && Schema.sObjectType.File__c.fields.File_Path__c.isAccessible() && Schema.sObjectType.File__c.fields.File_Size__c.isAccessible() && Schema.sObjectType.File__c.fields.File_Source__c.isAccessible() && Schema.sObjectType.File__c.fields.File_Type__c.isAccessible() && Schema.sObjectType.File__c.fields.Folder__c.isAccessible() && Schema.sObjectType.File__c.fields.sObject_Type__c.isAccessible() && Schema.sObjectType.File__c.fields.URL__c.isAccessible())){
                    folderListOfchilds  = [SELECT id, name,Folder_Path__c  ,(Select Id,name,File_Path__c,File_Size__c,File_Source__c,File_Type__c,Folder__c,sObject_Type__c,URL__c,createddate    From    Files__r Where Folder__c=:selectedFolderId),(SELECT id, name, Element_Number__c, Levels__c, Node_Number__c, Parent_Folder__c, Parent_Folder__r.Node_Number__c, sObject_Record_ID__c,Folder_Path__c  FROM Folders__r Where Name !='Chatter Files')  FROM Folder__c WHERE name =: RootFolderName   AND sObject_Record_ID__c =: recordId AND Parent_Folder__c =null Limit 1];
                    if(folderListOfchilds.size()  > 0)
                    selectedFolderId  =folderListOfchilds [0].id;
                }
            }
            if(folderListOfchilds != null  &&folderListOfchilds.size() > 0){
                selectedFolderName=(folderListOfchilds[0].Name);
                if(folderListOfchilds[0].folders__r != null && folderListOfchilds[0].folders__r.size() > 0 ){
                    for( Folder__c   fc: folderListOfchilds[0].folders__r){
                        wrapper_files wr =  new wrapper_files();
                        wr.isSelected = false;
                        wr.folder= fc;
                        wr.Path = fc.Folder_Path__c;
                        wr.recordId =fc.sObject_Record_ID__c; 
                        wr.Name =fc.name;
                        wr.type ='folder';
                        listOfMoveFold_Wr.add(wr);
                    }
                }
                if(folderListOfchilds[0].Files__r != null && folderListOfchilds[0].Files__r.size() > 0){
                    for(File__c  file: folderListOfchilds[0].Files__r ){
                        wrapper_files wr =  new wrapper_files();
                        wr.isSelected = false;
                        wr.files= file;
                        wr.Path = file.File_Path__c;
                        wr.Name =file.name+'.'+file.File_Type__c;
                        wr.type ='file';
                        listOfMoveFold_Wr.add(wr);
                    }
                }
            }
        }
    }
    
    public PageReference moveFolder()
    {
        if(Schema.sObjectType.folder__c.isAccessible() && Schema.sObjectType.File__c.isAccessible() && (Schema.sObjectType.folder__c.fields.name.isAccessible() && Schema.sObjectType.folder__c.fields.Folder_Path__c.isAccessible() && Schema.sObjectType.folder__c.fields.sObject_Record_ID__c.isAccessible())){
            List<Folder__c > listofFoldersTomove=  new List<Folder__c >() ;
            List<Folder__c > listofParentFoldersTomove=  new List<Folder__c >() ;
            map<id,Folder__c > mapOfMoveFolderIds =  new map<Id,Folder__c >();
            map<id,Folder__c > mapOfSelectedFolderAndPath =  new map<id,Folder__c >();
            List<File__c> listOfFileIds =  new List<File__c> () ;
            Set<Id>  setofSelectedFilesIds=  new Set<Id>();
            Set<Id>  setofSelectedParentFoldersIds=  new Set<Id>();
            Boolean sameNameFolderatSameLevel =false;
            Set<String> setOfTargetfolderchildNames =  new Set<String>();
            
            try{
                String selectedFilePath;
                for(wrapper_files wrcls : listOfMoveFold_Wr){
                    if(wrcls.isSelected){
                        if(wrcls.type =='folder'){
                            mapOfSelectedFolderAndPath.put(wrcls.folder.id,wrcls.folder);
                            setofSelectedParentFoldersIds.add(wrcls.folder.Id);
                            
                        }
                        else{
                            if(Schema.sObjectType.File__c.isAccessible()  && Schema.sObjectType.File__c.fields.name.isAccessible() && Schema.sObjectType.File__c.fields.File_Path__c.isAccessible()){
                                listOfFileIds.add(wrcls.files);
                                setofSelectedFilesIds.add(wrcls.files.id);
                                selectedFilePath= wrcls.files.File_Path__c;
                            }
                        }
                    }
                }
                
                Folder__c targetFolder =  new Folder__c ();
                list<Folder__c> listOftargetFolder = [SELECT id, name,sObject_Record_ID__c,Folder_Path__c ,(SELECT id, name   FROM folders__r)  FROM folder__c  WHERE id =:selectedFolderToMoveIn limit 1 ];
                
                if(listOftargetFolder != null && listOftargetFolder.size() >0){
                    targetFolder = listOftargetFolder[0];
                }
                if(targetFolder  != null && (targetFolder.folders__r != null && targetFolder.folders__r.size() >0)){
                    for(Folder__c  foltar :targetFolder.folders__r){
                        setOfTargetfolderchildNames.add((foltar.name).toLowerCase());
                    }
                }
                String parentFolderPath =null;
                String selectFolderNodeNum;
                for( Folder__c   fc: listofAllFolders ){
                    if(mapOfSelectedFolderAndPath.containskey(fc.id)){
                        if(targetFolder.id  != null && !setOfTargetfolderchildNames.contains((fc.name).toLowerCase())){
                            selectFolderNodeNum =  fc.Node_Number__c;
                            if(Folder__c.sObjectType.getDescribe().isUpdateable() && Schema.sObjectType.Folder__c.fields.Parent_Folder__c.isUpdateable()){
                                fc.Parent_Folder__c = selectedFolderToMoveIn;
                                parentFolderPath = fc.Parent_Folder__r.Folder_Path__c; 
                            }
                            listofParentFoldersTomove.add(fc);
                            mapOfMoveFolderIds.put(fc.id,fc);
                        }
                        else{
                            sameNameFolderatSameLevel  =true;
                        }
                    }      
                    if((selectFolderNodeNum != null && fc.Node_Number__c  != null) && (fc.Node_Number__c.contains(selectFolderNodeNum) && fc.Node_Number__c.startsWith(selectFolderNodeNum ) && (!mapOfSelectedFolderAndPath.containskey(fc.id)))){
                        listofFoldersTomove.add(fc);
                        mapOfMoveFolderIds.put(fc.id,fc);
                    }       
                }
                
                
                if(mapOfMoveFolderIds.containskey(selectedFolderToMoveIn)){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'You cannot Move parent folder to its own child folders'));   
                } 
                else if(sameNameFolderatSameLevel){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'You cannot move to same name folder at same level'));
                }
                
                else {
                    if(setofSelectedParentFoldersIds.size() > 0){
                        //future method call for move folders 
                        moveFolderOnSharePoint(setofSelectedParentFoldersIds,parentFolderPath,selectedFolderToMoveIn,recordId); 
                        if(listofParentFoldersTomove != null && listofParentFoldersTomove.size() > 0 ){
                            //update selected folders
                            update listofParentFoldersTomove;
                            if(listofFoldersTomove.size() > 0){
                                //update selected folder's child folders 
                                update listofFoldersTomove;
                            }
                            
                            list<File__c> listOfFileInMoveFolders =  new List <File__c>(); 
                            if(mapOfMoveFolderIds.keyset().size() > 0 && Schema.sObjectType.File__c.fields.name.isAccessible()  && Schema.sObjectType.File__c.fields.File_Path__c.isAccessible() && Schema.sObjectType.File__c.fields.File_Size__c.isAccessible() && Schema.sObjectType.File__c.fields.File_Source__c.isAccessible() && Schema.sObjectType.File__c.fields.File_Type__c.isAccessible() && Schema.sObjectType.File__c.fields.Folder__c.isAccessible() && Schema.sObjectType.File__c.fields.sObject_Type__c.isAccessible() && Schema.sObjectType.File__c.fields.URL__c.isAccessible() &&(Schema.sObjectType.File__c.isUpdateable() && Schema.sObjectType.File__c.fields.URL__c.isUpdateable())){
                                for(File__c file : [Select Id,name,File_Path__c,   File_Size__c,File_Source__c,File_Type__c,Folder__c,sObject_Type__c,URL__c From File__c Where  Folder__c In:mapOfMoveFolderIds.keyset() order by Node_Number__c ]){
                                    if(file != null && file.URL__c != null && parentFolderPath != null){
                                        String urlPathToupdate  = (file.URL__c).replace(parentFolderPath,targetFolder.Folder_Path__c);
                                        
                                        file.URL__c =  urlPathToupdate;
                                        listOfFileInMoveFolders.add(file);
                                    }
                                }
                                System.debug('listOfFileInMoveFolders '+listOfFileInMoveFolders);
                                if(listOfFileInMoveFolders != null && listOfFileInMoveFolders.size() > 0 && Schema.sObjectType.File__c.isUpdateable()){
                                    //update files for selected folders 
                                    update listOfFileInMoveFolders;
                                } 
                            }
                        }
                    }
                }
                
                if(setofSelectedFilesIds != null &&  setofSelectedFilesIds.size() > 0  && (targetFolder  != null && targetFolder.id != null) && (selectedFolderId != null) && selectedFilePath != null){
                    //Future method call for move files on sharepoint  
                    movefileOnsharepoint(setofSelectedFilesIds,selectedFilePath,targetFolder.id); 
                    
                    if(Schema.sObjectType.File__c.fields.name.isAccessible()  && Schema.sObjectType.File__c.fields.File_Path__c.isAccessible() && Schema.sObjectType.File__c.fields.File_Size__c.isAccessible() && Schema.sObjectType.File__c.fields.File_Source__c.isAccessible() && Schema.sObjectType.File__c.fields.File_Type__c.isAccessible() && Schema.sObjectType.File__c.fields.Folder__c.isAccessible() && Schema.sObjectType.File__c.fields.sObject_Type__c.isAccessible() && Schema.sObjectType.File__c.fields.URL__c.isAccessible()){
                        List<File__c>  ListOfMoveFiles = [Select Id,name,File_Path__c,   File_Size__c,File_Source__c,File_Type__c,Folder__c,sObject_Type__c,URL__c From File__c Where  Id In:setofSelectedFilesIds]; 
                        for(File__c  fil : ListOfMoveFiles){
                            if(fil.id != null && Schema.sObjectType.File__c.fields.Folder__c.isUpdateable() && Schema.sObjectType.File__c.fields.URL__c.isUpdateable()){    
                                fil.Folder__c =targetFolder.Id;
                                String urlPathToupdate  = (fil.URL__c).replace(fil.File_Path__c,targetFolder.Folder_Path__c);
                                fil.URL__c =urlPathToupdate != null ?urlPathToupdate: fil.URL__c;
                            }
                        }
                        
                        if(Schema.sObjectType.File__c.isUpdateable()){
                            //update move files path
                            update ListOfMoveFiles;
                        }
                    } 
                }
      
                selectedFolderName = RootFolderName;
                
                init();
            }
            catch(Exception e){
                System.debug('Error Message :::::::::'+e.getmessage()+'Line Number::'+e.getLineNumber());
            }
        }
        return null;
    }
    
    @Future(callout=true)
    public static void movefileOnsharepoint(Set<id> setOfSelectedFileIds,String parentFolderPath,String newFolderId){
        
        if(setOfSelectedFileIds.size() > 0 && parentFolderPath!= null && newFolderId != null && Schema.sObjectType.folder__c.fields.name.isAccessible() && (Schema.sObjectType.folder__c.fields.Folder_Path__c.isAccessible() && Schema.sObjectType.folder__c.fields.sObject_Record_ID__c.isAccessible() && Schema.sObjectType.folder__c.fields.Parent_Folder__c.isAccessible() && Schema.sObjectType.folder__c.fields.Node_Number__c.isAccessible()) ){
            Folder__c targetFolder = [SELECT id, name,sObject_Record_ID__c,Folder_Path__c FROM folder__c  WHERE id =:newFolderId limit 1 ];
            if(Schema.sObjectType.File__c.fields.name.isAccessible()  && Schema.sObjectType.File__c.fields.File_Path__c.isAccessible() && Schema.sObjectType.File__c.fields.File_Size__c.isAccessible() && Schema.sObjectType.File__c.fields.File_Source__c.isAccessible() && Schema.sObjectType.File__c.fields.File_Type__c.isAccessible() && Schema.sObjectType.File__c.fields.Folder__c.isAccessible() && Schema.sObjectType.File__c.fields.sObject_Type__c.isAccessible() && Schema.sObjectType.File__c.fields.URL__c.isAccessible()){
                for(File__c  fil : [Select Id,name,File_Path__c,   File_Size__c,File_Source__c,File_Type__c,Folder__c,sObject_Type__c,URL__c From File__c Where  Id In:setOfSelectedFileIds]){
                    if(fil.id != null){
                        String fileName=  fil.name+'.'+fil.File_Type__c;
                        //System.debug('File name '+fil.name +'old path'+fil.File_Path__c + 'New path'+targetFolder.Folder_Path__c +'sobject'+targetFolder.sObject_Record_ID__c +'Target folder id '+targetFolder.Id);
                        wwwTechnomileconnectCom.BasicHttpsBinding_IService1 WS_sharePoint = new wwwTechnomileconnectCom.BasicHttpsBinding_IService1 ();
                        String resultOfMovFile = WS_sharePoint.SP_MoveFile(fileName,parentFolderPath,targetFolder.Folder_Path__c,targetFolder.sObject_Record_ID__c,targetFolder.Id);
                        System.debug('resultOfMovFile '+resultOfMovFile);
                    }
                }
            }
        }
     }
    
    
    
    @Future(callout=true)
    public static void moveFolderOnSharePoint(Set<ID> setOfSelectParFolderIds,String olderFolderPath,String targetFolderId,String sobjectId)
    {
        if(setOfSelectParFolderIds.size() > 0 && Schema.sObjectType.folder__c.isAccessible() && Schema.sObjectType.File__c.isAccessible() && (Schema.sObjectType.folder__c.fields.name.isAccessible() && Schema.sObjectType.folder__c.fields.Folder_Path__c.isAccessible() && Schema.sObjectType.folder__c.fields.sObject_Record_ID__c.isAccessible() && Schema.sObjectType.folder__c.fields.Parent_Folder__c.isAccessible() && Schema.sObjectType.folder__c.fields.Node_Number__c.isAccessible())){
            Folder__c targetFolder = new Folder__c();
            List<Folder__c> targetFolderList = [SELECT id, name,sObject_Record_ID__c,Folder_Path__c  FROM folder__c  WHERE id =:targetFolderId limit 1 ];
            if(targetFolderList  != null  && targetFolderList.size() > 0){
                targetFolder =targetFolderList[0];
            }
            
            List<Folder__c> folderParToMoveList  = new List<Folder__c>() ; 
            
            for(Folder__c parFol : [SELECT id, name,sObject_Record_ID__c,Folder_Path__c ,Parent_Folder__c,Parent_Folder__r.Folder_Path__c,Node_Number__c  FROM folder__c  WHERE id =:setOfSelectParFolderIds ORDER BY Node_Number__c]){
                String targetpath= targetFolder.Folder_Path__c+'/'+ parFol.Name;
                 
                //Soap Callout for move folder on sharepoint 
                wwwTechnomileconnectCom.BasicHttpsBinding_IService1 WS_sharePoint = new wwwTechnomileconnectCom.BasicHttpsBinding_IService1 ();
                boolean resultMoveFol= WS_sharePoint.SP_MoveFolder(olderFolderPath+'/'+ parFol.Name,targetpath,sobjectId,targetFolder.Id);
                System.debug('resultMoveFol '+resultMoveFol );     
            }
        }
    }
    
   
   //Show list for delete  folders and file  
    public void openOfThisFolder(){
        System.debug('Selected FolderId on click ::'+selectedFolderId );
        listOfDelFile_Wr=  new List<wrapper_del_file>() ;
        List<Folder__c>  folderListOfchilds =  new List<Folder__c>  ();
        if(selectedFolderId != null  && !String.isBlank(selectedFolderId ))
        {
            if((Schema.sObjectType.folder__c.isAccessible()  && Schema.sObjectType.folder__c.fields.name.isAccessible() && Schema.sObjectType.folder__c.fields.Parent_Folder__c.isAccessible() && (Schema.sObjectType.folder__c.fields.Folder_Path__c.isAccessible() && Schema.sObjectType.folder__c.fields.sObject_Record_ID__c.isAccessible() && Schema.sObjectType.folder__c.fields.sObject_Type__c.isAccessible() && Schema.sObjectType.folder__c.fields.Node_Number__c.isAccessible()) && Schema.sObjectType.File__c.fields.name.isAccessible()  && Schema.sObjectType.File__c.fields.File_Path__c.isAccessible() && Schema.sObjectType.File__c.fields.File_Size__c.isAccessible() && Schema.sObjectType.File__c.fields.File_Source__c.isAccessible() && Schema.sObjectType.File__c.fields.File_Type__c.isAccessible() && Schema.sObjectType.File__c.fields.Folder__c.isAccessible() && Schema.sObjectType.File__c.fields.sObject_Type__c.isAccessible() && Schema.sObjectType.File__c.fields.URL__c.isAccessible()) ) {
                List<Folder__c> listOfRootFolder =[SELECT id, name,(SELECT id, name FROM Folders__r Where Name =:'Chatter Files'),sObject_Record_ID__c  FROM Folder__c WHERE name =: RootFolderName   AND Parent_Folder__c =null And sObject_Record_ID__c =: recordId Limit 1];
                String chatterFolderId;
                if(listOfRootFolder.size() > 0 && listOfRootFolder[0].Folders__r.size() > 0){
                    chatterFolderId= listOfRootFolder[0].Folders__r[0].Id;
                }
                folderListOfchilds = [SELECT id, name,Folder_Path__c,(SELECT id, name,Node_Number__c, Parent_Folder__c, Parent_Folder__r.Node_Number__c, sObject_Record_ID__c,Folder_Path__c  FROM Folders__r Where id !=:chatterFolderId),
                                                (Select Id,name,File_Path__c,File_Size__c,File_Type__c,Folder__c,URL__c,CreatedDate  From    Files__r)  FROM folder__c WHERE  Element_Number__c != null AND Id=:selectedFolderId   limit 1];
            }
        }
        else {
            if((Schema.sObjectType.folder__c.isAccessible()  && Schema.sObjectType.folder__c.fields.name.isAccessible() && Schema.sObjectType.folder__c.fields.Parent_Folder__c.isAccessible() && (Schema.sObjectType.folder__c.fields.Folder_Path__c.isAccessible() && Schema.sObjectType.folder__c.fields.sObject_Record_ID__c.isAccessible() && Schema.sObjectType.folder__c.fields.sObject_Type__c.isAccessible() && Schema.sObjectType.folder__c.fields.Node_Number__c.isAccessible()) && Schema.sObjectType.File__c.fields.name.isAccessible()  && Schema.sObjectType.File__c.fields.File_Path__c.isAccessible() && Schema.sObjectType.File__c.fields.File_Size__c.isAccessible() && Schema.sObjectType.File__c.fields.File_Source__c.isAccessible() && Schema.sObjectType.File__c.fields.File_Type__c.isAccessible() && Schema.sObjectType.File__c.fields.Folder__c.isAccessible() && Schema.sObjectType.File__c.fields.sObject_Type__c.isAccessible() && Schema.sObjectType.File__c.fields.URL__c.isAccessible()) ) {
                folderListOfchilds  = [SELECT id, name,Folder_Path__c,(SELECT id, name,Node_Number__c, Parent_Folder__c, Parent_Folder__r.Node_Number__c, sObject_Record_ID__c,Folder_Path__c  FROM Folders__r Where Name !='Chatter Files'),(Select Id,name,File_Path__c,   File_Size__c,File_Type__c,Folder__c,sObject_Type__c,URL__c,CreatedDate  From  Files__r) FROM Folder__c WHERE name =: RootFolderName   AND Parent_Folder__c =null And sObject_Record_ID__c =: recordId Limit 1];
                if(folderListOfchilds  != null && folderListOfchilds .size() > 0)
                selectedFolderId  =folderListOfchilds [0].id;
            }
        }
        
        if(folderListOfchilds != null  &&folderListOfchilds.size() > 0){
            selectedFolderName=(folderListOfchilds[0].Name);
            for( Folder__c   fc: folderListOfchilds[0].folders__r){
                wrapper_del_file wrdel =  new wrapper_del_file ();
                wrdel.isSelected = false;
                wrdel.folder= fc;
                wrdel.Path = fc.Folder_Path__c;
                wrdel.recordId =fc.sObject_Record_ID__c; 
                wrdel.type ='folder';
                wrdel.Name =fc.name;
                listOfDelFile_Wr.add(wrdel );    
            }
            
            if(folderListOfchilds [0].Files__r != null  && folderListOfchilds [0].Files__r.size() > 0){
                for(File__c  files: folderListOfchilds [0].Files__r){
                    wrapper_del_file wrdel =  new wrapper_del_file (); 
                    wrdel.isSelected = false;
                    wrdel.file= files;
                    wrdel.Path = files.File_Path__c;
                    wrdel.Name =files.name+'.'+files.File_Type__c;
                    wrdel.type ='file';
                    listOfDelFile_Wr.add(wrdel );
                }
            }
        }
    }
    
    public PageReference  deleteFolder(){
        List<Folder__c > listofFoldersToDelete=  new List<Folder__c >() ;
        List<Folder__c > listofParentFoldersToDelete=  new List<Folder__c >() ;
        map<id,Folder__c > mapOfSelectedFolderAndPath =  new map<id,Folder__c >();
        map<id,Folder__c > mapOfToDeleteFolderIds =  new map<Id,Folder__c >();
        List<File__c> listOfFileIds =  new List<File__c> () ;
        
        try{
            for(wrapper_del_file wrdelcls : listOfDelFile_Wr){
                if(wrdelcls.isSelected){
                    if(wrdelcls.type =='folder'){
                        mapOfSelectedFolderAndPath.put(wrdelcls.folder.id,wrdelcls.folder);
                    }
                    else{
                        listOfFileIds.add(wrdelcls.file);
                    }
                }
            }
            
            String selectFolderNodeNum;
            for( Folder__c   fc: listofAllFolders ){
                if(mapOfSelectedFolderAndPath.containskey(fc.id)){
                    selectFolderNodeNum =  fc.Node_Number__c;
                    listofParentFoldersToDelete.add(fc);
                    mapOfToDeleteFolderIds.put(fc.id,fc);
                    System.debug('folder path Before update'+fc.Folder_Path__c);
                }
                
                //condition for all child folders for selected folder 
                if((selectFolderNodeNum != null && fc.Node_Number__c  != null) && (fc.Node_Number__c.contains(selectFolderNodeNum) && fc.Node_Number__c.startsWith(selectFolderNodeNum ) && (!mapOfSelectedFolderAndPath.containskey(fc.id)))){
                    listofFoldersToDelete.add(fc);
                    mapOfToDeleteFolderIds.put(fc.id,fc);
                }       
            }
              
            if(listofParentFoldersToDelete != null  &&  listofParentFoldersToDelete.size() > 0) {  
                if(Schema.sObjectType.folder__c.isAccessible()  && Schema.sObjectType.folder__c.fields.name.isAccessible() && Schema.sObjectType.folder__c.fields.Folder_Path__c.isAccessible() ){
                    List<Folder__c>  folderListDeletePath  = [SELECT id, name,Folder_Path__c FROM folder__c WHERE id =: mapOfSelectedFolderAndPath.keySet()];
                    System.debug('folderListDeletePath  '+folderListDeletePath);
                    
                    if(folderListDeletePath  != null && folderListDeletePath  .size() > 0){
                        for(Folder__c fol : folderListDeletePath) {
                            //Share point DeleteFolder callout
                            deleteFolderOnSharePoint(fol.Folder_Path__c);
                        }
                        //delete selected fol
                        if((mapOfToDeleteFolderIds.keySet() != null &&  mapOfToDeleteFolderIds.size() > 0 )  && (Schema.sObjectType.File__c.isAccessible() && Schema.sObjectType.File__c.fields.name.isAccessible())){
                            list<File__c> listOfFiles=  [Select Id,name From File__c Where  Folder__c In:mapOfToDeleteFolderIds.keyset() ];
                            
                            if(Schema.sObjectType.File__c.isDeletable()){
                                delete listOfFiles;
                            }
                        }
                        if(Schema.sObjectType.Folder__c.isDeletable()){
                            delete listofParentFoldersToDelete;
                        }
                        if(listofFoldersToDelete!= null && listofFoldersToDelete.size()  > 0){ 

                            if(Schema.sObjectType.Folder__c.isDeletable()){
                                delete listofFoldersToDelete;  
                            }
                        }
                    }
                }
            }
            
            //delete functionality for selected files 
            if(listOfFileIds != null && listOfFileIds.size() > 0){
                if(Schema.sObjectType.Folder__c.isAccessible() && Schema.sObjectType.Folder__c.fields.name.isAccessible() && Schema.sObjectType.Folder__c.fields.Folder_Path__c.isAccessible()){
                    Folder__c targetFolder = [SELECT id, name,Folder_Path__c  FROM folder__c WHERE id =:selectedFolderId limit 1 ];
                    if(targetFolder  != null && targetFolder.id != null){
                       System.debug(' before listOfFileIds  :::'+listOfFileIds  +'targetFolder'+targetFolder  );
                        for(File__c  fil: listOfFileIds  ){
                        
                            // call a future method for callout 
                             String filename=fil.name+'.'+fil.File_Type__c;
                             deleteFileOnsharepoint(filename,targetFolder.Folder_Path__c );          
                        }
                        if(Schema.sObjectType.File__c.isDeletable()){
                            delete listOfFileIds ;
                        }
                        System.debug('after update'+listOfFileIds );
                    }
                }
            }
            selectedFolderName = RootFolderName;
            init();
        }
        catch(Exception e){
            System.debug('Error Message :::::::::'+e.getmessage()+'Line Number::'+e.getLineNumber());
        }
        
        PageReference pg;  
        pg = new PageReference('/apex/'+pageName +'?id='+recordId +'&inline=1');
        pg.setRedirect(true);
        return pg;
    }
    
    //Delete file on sharepoint 
    @Future(callout=true)
    public Static void deleteFileOnsharepoint(String fileName,String folderString){
        if(fileName != null  && folderString != null ){
            wwwTechnomileconnectCom.BasicHttpsBinding_IService1 WS_sharePoint = new wwwTechnomileconnectCom.BasicHttpsBinding_IService1 ();
            String  resultDeletefiles = WS_sharePoint.SP_DeleteFile(fileName,folderString);
            System.debug('resultDeleteFolderPath '+resultDeletefiles );
        }
    }
    
    //delete folder on share point
    @Future(callout=true)
    public static void deleteFolderOnSharePoint(String FolderPath) {
        if(FolderPath != null){
            wwwTechnomileconnectCom.BasicHttpsBinding_IService1 WS_sharePoint = new wwwTechnomileconnectCom.BasicHttpsBinding_IService1 ();
            boolean resultDeleteFolderPath = WS_sharePoint.SP_DeleteFolder(FolderPath);
            System.debug('resultDeleteFolderPath '+resultDeleteFolderPath );
        }
    }
    
    public PageReference  changeFolderLabel(){
        if(!String.isBlank(NewLableFolder)  && NewLableFolder != null ){
        
            List<Folder__c> foldersOfRenameParentList=  new List<Folder__c>() ;
            List<Folder__c>  folderListOfchilds =  new List<Folder__c>  ();
            map<id,Folder__c > mapOfReNameFolderIds =  new map<Id,Folder__c >();
            String oldFolderPath = null;
            
            try{
                List<Folder__c > listOfRootFolder  = [SELECT id, name,Folder_Path__c  FROM Folder__c WHERE name =: RootFolderName   AND sObject_Record_ID__c =: recordId Limit 1];
                
                if(selectedFolderId != null  && !String.isBlank(selectedFolderId ) && (listOfRootFolder.size() > 0 && listOfRootFolder[0].Id != selectedFolderId )) {
                    if(Schema.sObjectType.Folder__c.isAccessible() && Schema.sObjectType.Folder__c.fields.name.isAccessible() && Schema.sObjectType.Folder__c.fields.Node_Number__c.isAccessible() && Schema.sObjectType.Folder__c.fields.Parent_Folder__c.isAccessible() && Schema.sObjectType.Folder__c.fields.Folder_Path__c.isAccessible()){
                        folderListOfchilds = [SELECT id, name,Node_Number__c, Parent_Folder__c,Folder_Path__c FROM folder__c WHERE  Element_Number__c != null AND Id=:selectedFolderId AND Name != 'Chatter Files' limit 1];
                        
                        if(folderListOfchilds.size() == 0){
                             String sObjectName = Id.valueof(selectedFolderId).getSObjectType().getDescribe().getName();
                             
                             if(sObjectName != null   &&  sObjectName =='File__c'){
                                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'You cannot rename a file name'));
                             }
                             else{
                                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'You cannot rename Chatter Files folder name '));
                             }  
                        }
                    }
                }
                else {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'You cannot rename Root folder name ')); 
                }
                 
                if(folderListOfchilds  != null && folderListOfchilds.size() > 0 && NewLableFolder  !=RootFolderName){
                    String  selectFolderNodeNum =  folderListOfchilds[0].Node_Number__c;
                    oldFolderPath  =folderListOfchilds[0].Folder_Path__c;
                    
                    if(Folder__c.sObjectType.getDescribe().isUpdateable() && Schema.sObjectType.Folder__c.fields.name.isUpdateable()){
                        folderListOfchilds[0].name = NewLableFolder;
                    }
                    
                    mapOfReNameFolderIds.put(folderListOfchilds[0].Id,folderListOfchilds[0]);
                    Boolean smNameFolderOnsmLevel=false;
                    
                    for( Folder__c   fc: listofAllFolders ){
                        if(fc.Parent_Folder__c ==folderListOfchilds[0].Parent_Folder__c &&  (fc.Name).equalsIgnoreCase(NewLableFolder)){
                            smNameFolderOnsmLevel =true;
                        }
                        if((selectFolderNodeNum != null && fc.Node_Number__c != null )  && (fc.Node_Number__c.contains(selectFolderNodeNum) && fc.Node_Number__c.startsWith(selectFolderNodeNum )) && fc.Id !=  folderListOfchilds[0].Id){
                           foldersOfRenameParentList.add(fc);
                           mapOfReNameFolderIds.put(fc.id,fc);
                        }    
                    } 
                    
                    if(!smNameFolderOnsmLevel ) {
                    
                        if(Folder__c.sObjectType.getDescribe().isUpdateable()){  
                            update  folderListOfchilds ;
                        }
                
                        if(foldersOfRenameParentList != null && foldersOfRenameParentList.size() > 0 ) {
                            if(Folder__c.sObjectType.getDescribe().isUpdateable()) {  
                                update foldersOfRenameParentList ;
                            }
                        }
                        
                        if(oldFolderPath  != null ){
                            renameFolderOnSharePoint(oldFolderPath,folderListOfchilds[0].Id,folderListOfchilds[0].Name);     
                        }
                        
                        Map<Id,Folder__c>  foldersMapforFileUpdate  = new Map<Id,Folder__c> ([SELECT id, name, Parent_Folder__c,sObject_Record_ID__c,Folder_Path__c FROM folder__c WHERE id In :mapOfReNameFolderIds.keyset()]);
                        //System.debug('foldersMapforFileUpdate  '+foldersMapforFileUpdate  );
                        
                        if(Schema.sObjectType.File__c.fields.name.isAccessible()  && Schema.sObjectType.File__c.fields.File_Path__c.isAccessible() && Schema.sObjectType.File__c.fields.File_Size__c.isAccessible() && Schema.sObjectType.File__c.fields.File_Source__c.isAccessible() && Schema.sObjectType.File__c.fields.File_Type__c.isAccessible() && Schema.sObjectType.File__c.fields.Folder__c.isAccessible() && Schema.sObjectType.File__c.fields.sObject_Type__c.isAccessible() && Schema.sObjectType.File__c.fields.URL__c.isAccessible()) {      
                        /* File path or url update */
                            list<File__c> listOfFiles=  [Select Id,name,File_Path__c,   File_Size__c,File_Source__c,File_Type__c,Folder__c,sObject_Type__c,URL__c From File__c Where  Folder__c =: mapOfReNameFolderIds.keyset() ];
                            
                            if(listOfFiles != null && listOfFiles.size() > 0) {
                                for(File__c file :listOfFiles){
                                    if(foldersMapforFileUpdate.containskey(file.Folder__c)){
                                        String urlPathToupdate  = (file.URL__c).replace(mapOfReNameFolderIds.get(file.Folder__c).Folder_Path__c,foldersMapforFileUpdate.get(file.Folder__c).Folder_Path__c);
                                        file.URL__c =  urlPathToupdate;
                                    }
                                }
                                if(Schema.sObjectType.File__c.isUpdateable()){
                                    update listOfFiles;
                                }
                            }
                        }        
                    } 
                    else if(smNameFolderOnsmLevel) {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'You cannot rename this if other folder have same name at this level')); 
                    } 
                } 
                init();
            }
            catch(Exception e){
                System.debug('Error Message :::::::::'+e.getmessage()+'Line Number::'+e.getLineNumber());
            }
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Please enter value in  New label text field')); 
        }
        return null;
    }
    
    //Rename for on share point 
    @Future(callout=true)
    public static void renameFolderOnSharePoint(String  oldFolderPath,String newFolderId,String NewFolderName)
    {
        list<folder__c> folderList = new list<folder__c>();
        folder__c folder = new folder__c();
        
        if(newFolderId != null ){
            if(Schema.sObjectType.Folder__c.isAccessible() && Schema.sObjectType.Folder__c.fields.name.isAccessible()  && Schema.sObjectType.Folder__c.fields.Folder_Path__c.isAccessible()){
                folderList = [SELECT id, name,sObject_Record_ID__c,Folder_Path__c FROM folder__c WHERE id =: newFolderId];
                if(folderList  != null && folderList.size() > 0) {
                    folder = folderList[0];
                }
            }
        }
        if(folder  != null){  
            //Soap callout for Rename folder on sharepoint
            wwwTechnomileconnectCom.BasicHttpsBinding_IService1 WS_sharePoint = new wwwTechnomileconnectCom.BasicHttpsBinding_IService1 ();
            boolean resultRenameFolderPath = WS_sharePoint.SP_RenameFolder(oldFolderPath,folder.Folder_Path__c);
            
            System.debug('resultRenameFolderPath '+resultRenameFolderPath );
        }
    }
     
     public void  uploadFile(){
        if(selectedFolderId == Null || String.isBlank(selectedFolderId )){
            if(Schema.sObjectType.Folder__c.isAccessible() && Schema.sObjectType.Folder__c.fields.name.isAccessible()  && Schema.sObjectType.Folder__c.fields.Folder_Path__c.isAccessible()){
                List<folder__c > folderList = [SELECT id, name,Folder_Path__c  FROM Folder__c WHERE name =: RootFolderName   AND sObject_Record_ID__c =: recordId Limit 1];
                if(folderList  != null && folderList.size() > 0){
                    selectedFolderId  =folderList[0].id; 
                    selectedFolderName=(folderList[0].Name);
                } 
            }
        }
        else{
            if(Schema.sObjectType.Folder__c.isAccessible() && Schema.sObjectType.Folder__c.fields.name.isAccessible()  && Schema.sObjectType.Folder__c.fields.Folder_Path__c.isAccessible()){
                List<folder__c > folderList = [SELECT id, name,Folder_Path__c FROM folder__c WHERE  Element_Number__c != null AND Id=:selectedFolderId   limit 1];
                
                if(folderList  != null && folderList.size() > 0){
                    selectedFolderName=(folderList[0].Name);
                } 
            }
        }
    }
   
   //Wraaper class for Move Folders and Files
    public with sharing class wrapper_files {
        public boolean isSelected{get;set;}
        public file__c files{get;set;}
        public folder__c folder{get;set;}
        public string type{get;set;}    
        public String Name{get;set;}
        public String Path{get;set;}
        public String URL{get;set;}
        public id recordId{get;set;}
        public double filesize{get;set;}
    }
    
    //Wraaper class for delete Folders and Files
    public  with sharing class wrapper_del_file {
        public boolean isSelected{get;set;}
        public file__c file{get;set;}
        public folder__c folder{get;set;}
        public string type{get;set;}
        
        public String Name{get;set;}
        public String Path{get;set;}
        public String URL{get;set;}
        public id recordId{get;set;}
        public double filesize{get;set;}
    }      
}