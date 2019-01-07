Global with Sharing class SFSP_ConnectorMassData_v2
{
    @Future(callout=true)
    global static void createNewFolderOnSharePoint(set<id> folderIdSet)
    {
        if(Schema.sObjectType.folder__c.isAccessible()){
            list<folder__c> folderList = new list<folder__c>();
            
            if(folderIdSet.size() > 0 && (Schema.sObjectType.folder__c.isAccessible()  && Schema.sObjectType.folder__c.fields.name.isAccessible() && Schema.sObjectType.folder__c.fields.Element_Number__c.isAccessible() && Schema.sObjectType.folder__c.fields.Levels__c.isAccessible() && Schema.sObjectType.folder__c.fields.Parent_Folder__c.isAccessible() && Schema.sObjectType.folder__c.fields.Folder_Path__c.isAccessible() && Schema.sObjectType.folder__c.fields.sObject_Record_ID__c.isAccessible() && Schema.sObjectType.folder__c.fields.sObject_Type__c.isAccessible()))
            {
                folderList = [SELECT id, name, Element_Number__c, Levels__c, Node_Number__c, Parent_Folder__c, Parent_Folder__r.Node_Number__c, sObject_Record_ID__c,Folder_Path__c
                                FROM folder__c WHERE id =: folderIdSet];
               
                wwwTechnomileconnectCom.BasicHttpsBinding_IService1 WS_sharePoint = new wwwTechnomileconnectCom.BasicHttpsBinding_IService1 ();
                for(folder__c folder : folderList)
                {
                    //boolean resultFlat = WS_sharePoint.SP_CreateFolder(folder.Folder_Path__c, folder.sObject_Record_ID__c, folder.id);
                    boolean resultFlat = WS_sharePoint.SP_CreateFolder(folder.Folder_Path__c, folder.Parent_Folder__c, folder.id);
                }
            }
        }
    }    
}