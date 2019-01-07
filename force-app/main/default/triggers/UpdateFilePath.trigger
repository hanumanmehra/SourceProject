trigger UpdateFilePath on ContentVersion (before insert, before update) {
    map<id, string> filePathMap = new map<id, string>();
    for(ContentVersion cv : Trigger.New)
    {
        if(cv.folder__c != null)
            filePathMap.put(cv.folder__c, '');
    }
    if(filePathMap.keySet().size() > 0)
    {
        list<folder__c> folderList = [SELECT id, name, folder_path__c FROM folder__c WHERE id IN: filePathMap.keySet() ];
        if(folderList.size() > 0)
        {
            for(folder__c fld : folderList)
            {
                if(filePathMap.containsKey(fld.id))
                {
                   filePathMap.put(fld.id, fld.folder_Path__c);
                }
            }
        }
        for(ContentVersion cv : Trigger.New)
        {
            if(cv.folder__c != null)
                cv.file_path__c = filePathMap.get(cv.folder__c); 
        }
        
    }
}