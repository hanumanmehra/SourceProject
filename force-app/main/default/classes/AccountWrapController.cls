public class AccountWrapController {
    
    @AuraEnabled
	public static List<Account> GetAccountNames()
	{
        System.debug('We are in Account');
   		return [select id, Name,Industry,Website from Account limit 20];
	}
    
    @AuraEnabled
	public static List<Contact> GetContactNames(String AccountsId)
	{
       List<Contact> conlist =  new List<Contact>();
        if(AccountsId != Null)
        {
            Set<Id> SetOfIds = (Set<Id>)JSON.deserialize(AccountsId, Set<Id>.class);
            System.debug('SetOfIds::::'+SetOfIds);
            conlist = [select id, Name,Account.Name from Contact where AccountId In:SetOfIds];
        }
   		return conlist; 
	}
    
    
	public with sharing class AccountWrapper
	{
        @AuraEnabled
        public Account acc {get; set;}
     
        @AuraEnabled
        public Boolean selected {get; set;}
	}
    
    public with sharing class ContactWrapper
	{
        @AuraEnabled
        public Contact con {get; set;}
     
        @AuraEnabled
        public Boolean isSelected {get; set;}
	}


}