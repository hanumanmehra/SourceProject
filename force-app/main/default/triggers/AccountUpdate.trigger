trigger AccountUpdate on Temp__c (after insert ,after update)
{
    List<Temp__c > tempList = trigger.New;
    Map<Id,Temp__c> mapOfTempAccount =  new Map<Id,Temp__c>();
    Set<Id> accountIds = new Set<Id>();
    
    if(Trigger.isInsert)
    {
        for(Temp__c tm: tempList )
        {
            accountIds.add(tm.Account__c);
            mapOfTempAccount.put(tm.Account__c,tm);
        }
    }
    else
    {
        for(Temp__c tm: tempList )
        {
            accountIds.add(tm.Account__c);
            mapOfTempAccount.put(tm.Account__c,tm);
            
           if(tm.Account__c != Trigger.oldMap.get(tm.id).Account__c)
           {
                accountIds.add(Trigger.oldMap.get(tm.id).Account__c);
                mapOfTempAccount.put(Trigger.oldMap.get(tm.id).Account__c,tm);
                System.debug('Trigger.Account__c ::'+Trigger.oldMap.get(tm.id).Account__c);
            }
        }
    }
        
    if(accountIds!= null && accountIds.size() > 0)
    {
        List<Account> accountlist = [Select Name,AccountTemp__c from Account Where id In :accountIds];
        System.debug('accountlist ::'+accountlist);
        if(accountlist != null && accountlist.size() >0)
        {
            for(Account acc : accountlist)
            {
              System.debug('mapOfTempAccount ::'+mapOfTempAccount.get(acc.Id).Account__c);
              acc.AccountTemp__c = mapOfTempAccount.get(acc.Id).Id !=acc.AccountTemp__c? mapOfTempAccount.get(acc.Id).Id :acc.AccountTemp__c;
            }
            upsert accountlist;
        }
    }
}