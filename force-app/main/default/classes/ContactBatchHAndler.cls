public with sharing class ContactBatchHAndler
{
    public static void accountIdBatch(List<Contact> listContact)
    {
        Set<Id> setAccountId= new Set<Id>();
        for( Contact con : listContact)
        {
            if(con.AccountId != null)
            {
                setAccountId.add(con.AccountId);
            }
        }
        
        if(setAccountId != null && setAccountId.size() >0)
        {
            ID batchprocessid = Database.executeBatch(New ContactBatchClass(setAccountId),5);

        }
    }


}