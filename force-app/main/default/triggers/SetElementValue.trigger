trigger SetElementValue on Folder__c (before insert, after insert, after update) {
    id ParentFolderId;
    integer assignElementNumber = 0;
    set<id> folderIdSet = new set<id>();
    if(Trigger.isBefore)
    {
        for(folder__c folder : Trigger.New)
        {
            if(folder.Parent_Folder__c == null)
            {
                folder.Element_Number__c = 0;
            }
        }
    }
    if(Trigger.isAfter)
    {
        if(Trigger.isInsert)
        {
           for(folder__c folder : Trigger.New)
           {
               if(folder.Parent_Folder__c != null)
               {
                   folderIdSet.add(folder.id);
               }
           }
           
           if(folderIdSet.size() > 0)
           {
               HelperController.setElementNumber(folderIdSet,null);
           }
        }
       
        if(Trigger.isUpdate)
        {
            set<id> parentFolderIdSet = new set<id>();
            for(Folder__c fld : Trigger.New)
            {
                if(fld.Parent_Folder__c != null && fld.Parent_Folder__c != trigger.oldMap.get(fld.id).Parent_Folder__c)
                {
                    parentFolderIdSet.add(fld.Parent_Folder__c);
                    folderIdSet.add(fld.id);
                }
                else{
                    if(fld.Parent_Folder__c == null ){
                        folderIdSet.add(fld.id); 
                    }
                }
            }
            if(folderIdSet.size() > 0)
            {
               HelperController.setElementNumber(folderIdSet, parentFolderIdSet);
            }
        }
    }
}