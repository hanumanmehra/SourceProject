trigger ContentVersionDeleteTrigger on File__c  (before insert)
{
    /*
    if(trigger.isbefore && trigger.isinsert)
    {
        ContentVersionDeleteOnFileInsHandler.contentVersionDelOnFile(Trigger.new);
    }
    if(trigger.isafter && trigger.isinsert)
    {
        deleteContentVersionHandler.deleteContentVersion(Trigger.new);
    }
    */
    //trigger ContentVersionDeleteOnFileInsTrigger on File__c (before insert) {
    
    List<ContentVersion> contentVersionList = new List<ContentVersion>();
    contentVersionList=[SELECT Id,Title,ContentDocumentId,pathOnClient,File_Path__c FROM ContentVersion LIMIT 10000];
 
    if(! contentVersionList.isEmpty()){
      set<Id> ContentDocDeleteIds = new Set<Id>();
        
        for(File__c file :Trigger.new){
            
            for(ContentVersion cov : contentVersionList)
            {
                if(file.File_Path__c == cov.File_Path__c && file.Name == cov.pathOnClient){
                    ContentDocDeleteIds.add(cov.ContentDocumentId);
                }
            }
            
        }
        List<ContentDocument> documentToDelete = new List<ContentDocument>();
        documentToDelete=[SELECT Id FROM ContentDocument WHERE Id IN:ContentDocDeleteIds];
        
        Try{
            if(! documentToDelete.isEmpty()){
                Delete documentToDelete;
            }
        }catch(DmlException e){
                system.debug('Exception occurred '+e);
            }
        }
    //}
}