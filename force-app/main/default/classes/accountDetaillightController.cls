public class accountDetaillightController {
    public static Account accounttable;
    @AuraEnabled
    public static Account  getHmAccountlist(Id formId){
        System.debug('formId'+formId);
        Account ac = new Account();
        ac=[Select id,Name,AccountNumber,Phone,SLAExpirationDate__c From Account where id =:formId ];
        System.debug('account::'+ac);
        return ac;
    }
    @AuraEnabled
    public static Account newRowContactTable(Id contactId)
    {
        System.debug('contactId::::'+contactId);
        //contValRecordTypeId = Schema.SObjectType.Value_Table__c.getRecordTypeInfosByName().get('Milestone Billing').getRecordTypeId();
        accounttable = new Account (Name='',AccountNumber='',SLAExpirationDate__c=Date.today(),phone='');
        System.debug('accounttable::::'+accounttable);
        return accounttable; 
    }
     @AuraEnabled
    public static void saveAccountValTable(String contValList,Id recordId,string delConValIdsStr)
    {
        System.debug('we are in the save method'+contValList +'delConValIdsStr::'+delConValIdsStr);
        if(delConValIdsStr!=Null)
        {
            string[] delIds=delConValIdsStr.split(',');
            delIds.remove(0);
            
            List<Account> delList = [Select Id from Account where Id IN: delIds];
            delete delList;
        }
        System.debug('we in the save ::');
      
           System.debug(' we are in if contValList :::');
           List<Account> acctabList = (List<Account>)JSON.deserialize(contValList, List<Account>.class);
           System.debug('acctabList::::'+acctabList);
            for(Account ac : acctabList)
            {
                System.debug('vtid = '+ac.Id);
                If(ac.Id==Null){
  					System.debug(' in if');               
                }
            upsert acctabList;
            System.debug('acctabList2 :::::'+acctabList);
        }
    }
}