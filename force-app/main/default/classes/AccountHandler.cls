public class AccountHandler
{
    public static void accountmap(list<Account> listAccount,map<id,Account> accountMap)
    {
        map<Id,Account> accmap =  new map<Id,Account>();
        set<Id> accountidset = new set<Id>();
        for(Account ac : listAccount)
        {
             if(ac.Account_field__c != accountMap.get(ac.id).Account_field__c)
             {
                accountidset.add(ac.id); 
                accmap.put(ac.id,ac); 
             }
 
        }
        
        if(accountIdset.size() >0 && accountIdset != null)
        {
            List<Contact> listContact =[Select Name, Contact_field__c,AccountId from Contact Where AccountId in :accountIdset];
            System.debug('listContact'+listContact);
            
            if(listContact.size() >0 && listContact != null)
            {
                for( Contact con  :listContact)
                {
                    String st = accmap.get(con.AccountId).Account_field__c;
                    con.Contact_field__c = st;
                    System.debug('con.Contact_field__c'+con.Contact_field__c);
                }
                upsert listContact;
                System.debug(listContact);
            }
        } 
    }
    
}