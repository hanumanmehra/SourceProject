global class ContactBatchClass implements Database.Batchable<sObject>
{

   global String Query;
   global Set<Id> setAccid;

   global ContactBatchClass(Set<Id> AccId)
   {
        this.setAccid = Accid;
        System.debug('AccId'+AccId);
        Query ='Select Name,Total_Contacts__c,My_Contacts__c,(Select Name,Email,Phone,Account.Name from Contacts) From Account where Id IN :setAccid' ;
        System.debug('Query ::'+Query);
   } 

   global Database.QueryLocator start(Database.BatchableContext BC)
   {
      System.debug(Query);
      return Database.getQueryLocator(Query);
   }

   global void execute(Database.BatchableContext BC, List<Account> scope)
   {
    System.debug('This is object '+scope[0].Contacts);
    List<Contact> lstcon =  new List<Contact>();
    for(Account ac: scope)
    {
        for(Contact con : ac.Contacts)
        {
            con.Status__c = 'Pending';
             lstcon.add(con);
        }
    }
    upsert lstcon ;
   
   
   }
   global void finish(Database.BatchableContext BC)
   {
    
   }

}