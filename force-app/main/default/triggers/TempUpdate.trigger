trigger TempUpdate on Account (after insert ,after update) 
{
    
   List<Account> accountList = trigger.New;
   Map<Id,Account> mapOfTempAccount =  new Map<Id,Account>();
    
      Set<Id> tempSetOfIds = new Set<Id>();
    if(Trigger.isInsert || Trigger.isUpdate)
    {
        for(Account acc : accountList)
        {
            
                tempSetOfIds.add(acc.Id);
                mapOfTempAccount.put(acc.AccountTemp__c,acc);
                System.debug('mapOfTempAccount in insert :::'+mapOfTempAccount);
        }           
    }
    else
    {
       for(Account acc : accountList)
        {
            
                tempSetOfIds.add(acc.Id);
                mapOfTempAccount.put(acc.AccountTemp__c,acc);
                System.debug('mapOfTempAccount in insert :::'+mapOfTempAccount);
                if(acc.AccountTemp__c != Trigger.oldMap.get(acc.id).AccountTemp__c)
                {
                     tempSetOfIds.add(Trigger.oldMap.get(acc.id).AccountTemp__c);
                     mapOfTempAccount.put(Trigger.oldMap.get(acc.id).AccountTemp__c,acc);
                     System.debug('mapOfTempAccount in update:::'+mapOfTempAccount);
                }
        }      
    }
    
    if(tempSetOfIds != null && tempSetOfIds.size() > 0)
    {
        List<Temp__c> templist = [Select Name,Account__c from Temp__c Where Id In :tempSetOfIds ];
        System.debug('templist ::'+templist );
        if(templist != null && templist.size() >0)
        {
            for(Temp__c tmp : templist )
            {
                System.debug('mapOfTempAccount ::'+mapOfTempAccount.get(tmp.Id).Name);  
                tmp.Account__c =mapOfTempAccount.get(tmp.Id).Id != tmp.Account__c ?  mapOfTempAccount.get(tmp.Id).Id :tmp.Account__c ;
                System.debug(tmp .Account__c);
            }
            upsert templist;
        }
    }

}