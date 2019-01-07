public with sharing class HelperController
{
    
    public static void setElementNumber(set<id> folderIdSet, set<id> ParentFolderIdSet)
    {    
        map<id, list<folder__c>> parentIdFolderListMap = new map<id, list<folder__c>>();
        list<folder__c> newFolderList = [SELECT id, Parent_Folder__c, Element_Number__c FROM folder__c WHERE id IN: folderIdSet];
        list<folder__c> newInstanceFolderList = new list<folder__c>();
        if(newFolderList.size() > 0)
        {
            for(Folder__c fld : newFolderList )
            {
                folder__c newInstance = new folder__c();
                newInstance = fld;
                newInstanceFolderList.add(newInstance);
            }
        }
        if(newInstanceFolderList.size() > 0)
        {
            for(Folder__c fld : newInstanceFolderList)
            {
                if(fld.Parent_Folder__c != null)
                {
                    if(parentIdFolderListMap.containsKey(fld.Parent_Folder__c))
                    {
                        list<folder__c> folderList = parentIdFolderListMap.get(fld.Parent_Folder__c);
                        folderList.add(fld);
                        parentIdFolderListMap.put(fld.Parent_Folder__c,  folderList);
                    }
                    else
                    {
                        list<folder__c> folderList = new list<folder__c>();
                        folderList.add(fld);
                        parentIdFolderListMap.put(fld.Parent_Folder__c,  folderList);
                    }
                }
            }
            if(!parentIdFolderListMap.isEmpty())
            {
                list<AggregateResult> ARList = new list<AggregateResult> ();
                if(ParentFolderIdSet != null)
                {
                    ARList = [SELECT Max(Element_Number__c) maxElement, Parent_Folder__c parentFolder FROM Folder__c WHERE (Not Id IN: folderIdSet) AND Parent_Folder__c IN: parentIdFolderListMap.keySet() GROUP BY Parent_Folder__c ];
                }
                else
                {
                    ARList = [SELECT Max(Element_Number__c) maxElement, Parent_Folder__c parentFolder FROM Folder__c WHERE Parent_Folder__c IN: parentIdFolderListMap.keySet() GROUP BY Parent_Folder__c ];
                }
                if(ARList.size() > 0)
                {
                    for(AggregateResult AR : ARList )
                    {
                        if(AR.get('parentFolder') != null)
                        {
                            id parentId = (id)AR.get('parentFolder');
                            if(parentIdFolderListMap.containsKey(parentId))
                            {
                                if(AR.get('maxElement') == null || AR.get('maxElement') == 0)
                                {
                                    integer i = 1;
                                    for(folder__c folder : parentIdFolderListMap.get(parentId))
                                    {
                                        folder.Element_Number__c = i;
                                        i++;
                                    }
                                }
                                else
                                {
                                    integer i = integer.valueOf(AR.get('maxElement')) + 1;
                                    for(folder__c folder : parentIdFolderListMap.get(parentId))
                                    {
                                        folder.Element_Number__c = i;
                                        i++;
                                    }
                                }
                            }
                        }
                    }
                }
                
                if(!parentIdFolderListMap.isEmpty())
                {
                    list<folder__c> folderListForUpdate = new list<folder__c>();
                    for(list<folder__c> folderTempList : parentIdFolderListMap.values())
                    {
                        if(folderTempList.size() > 0)
                        {
                            folderListForUpdate.addAll(folderTempList);
                        }
                    }
                    if(folderListForUpdate.size() > 0)
                    {
                        update folderListForUpdate ;
                    }
                }
             }
        }
    }
}