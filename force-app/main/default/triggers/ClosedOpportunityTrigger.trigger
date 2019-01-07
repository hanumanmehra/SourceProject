trigger ClosedOpportunityTrigger on Opportunity(after insert ,after update) 
{
    Set<Id> setOfOppIds = new Set<Id>();
    if(Trigger.isInsert || Trigger.isUpdate)
    {
        for(Opportunity  opp  : trigger.New)
        {
            if(opp.id != null && opp.StageName =='Closed Won') 
            {
                 if(Trigger.isUpdate && (opp.StageName != trigger.oldmap.get(opp.Id).StageName))
                {
                   
                   setOfOppIds.add(trigger.oldmap.get(opp.Id).Id); 
                }
                setOfOppIds.add(opp.Id);
            }   
        }  
        
         if(setOfOppIds != null && setOfOppIds.size()> 0)
        {
            List<Task> createToTasklist  =  new List<Task>();
            for( Id ids : setOfOppIds)
            {
                Task tsk =  new Task();
                tsk.subject = 'Follow Up Test Task';
                tsk.WhatId =ids;
                createToTasklist.add(tsk);
            }
            if(createToTasklist != null && createToTasklist.size() >0)
            {
                upsert createToTasklist;
            }  
       }
    }
}