trigger LoopFileMoveToSharePoint on FeedItem (after insert) {
    
    set<id> contentVersionIdSet = new set<id>();
    list<SharePoint_File_Source__c> SharePointCustomSetting = new list<SharePoint_File_Source__c>();
    list<String> fileNameList = new list<String>();
    map<id, id> contentVersionParentIdMap = new map<id, id>();
    SharePointCustomSetting = [SELECT id, name, Chatter_File_Name__c, Direct_Upload__c, Chatter_Files__c, Chatter_and_Direct_Upload__c FROM SharePoint_File_Source__c limit 1000];
    if(SharePointCustomSetting.size() > 0)
    {
        for(SharePoint_File_Source__c cs : SharePointCustomSetting)
        {
            if(cs.Chatter_Files__c == true || cs.Chatter_and_Direct_Upload__c == true)
            {
                if(cs.Chatter_File_Name__c != null)
                {
                    if(cs.Chatter_File_Name__c.contains(','))
                    {
                        fileNameList = cs.Chatter_File_Name__c.split(',');
                    }
                    else
                    {
                        fileNameList.add(cs.Chatter_File_Name__c);
                    }
                }
            }
        }
    }
    if(fileNameList.size() > 0)
    {
        for(FeedItem FItem : Trigger.New)
        {
            if(FItem.relatedRecordId != null)
            {
                contentVersionIdSet.add(FItem.relatedRecordId);
                contentVersionParentIdMap.put(FItem.relatedRecordId, FItem.ParentId);
            }
        }
        
        if(contentVersionIdSet.size() > 0 )   
        {
            UploadLoopFileToSharePoint.uploadChatterFile(contentVersionIdSet, fileNameList, contentVersionParentIdMap);
        }
     }
     
     /*
         for get file from any object other then  attachments
         SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = '<Opportunity or other object id here>'
     */
}