public with sharing class ContactTriggerHandler 
{

    public static void countAccount(list<Contact> conlist)
    {
         Set<id> accountids = new set<id>();
         for(Contact con :conlist )
         {
             accountids.add(con.AccountId);
             System.debug('accountids'+accountids); 
         }
         if(accountids != null && accountids.size() >0 )
         {
             updatetotalcontact(accountids);
         }
         System.debug('accountids'+accountids);
    }
    
    public static void countAccountmap(list<Contact> conlist,map<id,Contact> contactmap)
    {
         Set<id> accountids = new set<id>();
         for(Contact con :conlist)
         {
	         if(con.id != null && con.Account != contactmap.get(con.id).Account)
	             System.debug('con.Accountid'+con.Accountid);
	             accountids.add(con.Accountid);
	             accountids.add(contactmap.get(con.id).Accountid);
	             
	             System.debug('accountids'+accountids); 
	     }
         
         if(accountids != null && accountids.size() >0 )
         {
             updatetotalcontact(accountids);
         }
        
    }
    
    public static void updatetotalcontact(Set<id> setaccId)
    {
    
        if(setaccId!= null  && setaccId.size() >0)
        {
            List<AggregateResult> aggr = [Select AccountId acId, Count(name)sum1 from  Contact where AccountId in :setaccId group by AccountId]; 
            
            System.debug('aggr '+aggr );
            Map<Id,Integer> mapResult1 = new Map<Id,Integer>();
            
            Integer sum1;
            if(aggr != null && aggr.size() >0)
            { 
            for(AggregateResult ag:aggr)
            {
                sum1 = Integer.valueof(ag.get('sum1')) != null ? Integer.valueof((ag.get('sum1'))) : 0; 
                Id str = (Id)ag.get('acId') != null ?(Id)ag.get('acId'): new Account().Id ;
                mapResult1.put(Id.valueof(str),sum1);
            }
        
            List <Account> ListofAccount =[Select Id,Name,My_Contacts__c from  Account where  Id IN : setaccId]; 
            
            if(ListofAccount != null && ListofAccount .size() > 0)
            {
                for(Account ac : ListofAccount )
                {
                    if(mapResult1.containsKey(ac.Id))
                    {
                     ac.My_Contacts__c = mapResult1.get(ac.Id);
                    }
                    
                    else
                    {
                      ac.My_Contacts__c = 0;
                    }
                }  
                
               update ListofAccount;
            } 
        }
        }
    }
}