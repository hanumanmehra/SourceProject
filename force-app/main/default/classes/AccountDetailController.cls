public class AccountDetailController
{
    public String selectValue{get;set;}
    public String inputvalue{get;set;}
    public List<Account> Accountlist;
    public List<Account> acclist{get;set;}
    Public String accId;
    public map<Id,List<Contact>> contactmap {get;set;}
    public ApexPages.StandardController setcon;
     public static  List<Account> accountlist{get;set;}
    
    public AccountDetailController(ApexPages.StandardController setcon)
    {
        this.setcon = setcon;
        Accountlist =  new List<Account>();
        acclist = new List<Account>();
        accId = setcon.getId();
        System.debug('Ids '+accId );
        contactmap = new map<Id,List<Contact>>();
        inputmethod();
        
    }
    public void inputmethod()
    {
        System.debug('inputvalue'+inputvalue);
        String querystr = 'Select Name,Total_Contacts__c,My_Contacts__c,(Select Name,Email,Phone,Account.Name from Contacts) From Account ';
        
        if(inputvalue != null)
        {
             querystr =+querystr +'where Name LIKE  \''+inputvalue + '%\'' ;
             System.debug('querystr'+querystr);
             
             Accountlist= database.query(querystr);
         }
         else
         {
            Accountlist= database.query(querystr); 
         }
         System.debug('listacc'+Accountlist);
         if(Accountlist !=null && Accountlist.size() >0)
         {
             for(Account ac:Accountlist )
             {
                   if(ac.id != null && ac.Contacts.size() ==0)
                   {
                       acclist.add(ac);
                       contactmap.put(ac.Id,new List<Contact>());
                   } 
                    else if(ac.id != null && ac.contacts.size() >0)
                    {
                     acclist.add(ac);
                     System.debug('ac'+ac.contacts);
                     contactmap.put(ac.Id,ac.contacts);      
                    }
                    
             }
             System.debug(contactmap);
         }   
    }
    
    @RemoteAction
    public static list<Account> remoteAccount(String accountName )
    {
        String querystr = 'Select Name,Total_Contacts__c,My_Contacts__c,(Select Name,Email,Phone,Account.Name from Contacts) From Account ';
        if(accountName != null)
        {
             querystr =+querystr +'where Name LIKE  \''+accountName + '%\'' ;
             //querystr =+querystr +'where Name LIKE :'+accountName + '%' ;
             System.debug('querystr'+querystr);
             
             accountlist= database.query(querystr);
         }
         else
         {
           accountlist= database.query(querystr); 
         }
         
         System.debug('accountlist'+accountlist);
         if( accountlist!= null  && accountlist.size() >0)
         {
            return accountlist;
         }
         else
         {
            return null;
         }
    }
    
    public PageReference Save() 
     {     
        setcon.Save();
        PageReference pr = new PageReference('/apex/AccountDetailPage');
        pr.setredirect(true);
        return pr;
     }
     public PageReference Cancel() 
     {     
        PageReference pr = new PageReference('/apex/AccountDetailPage');
        pr.setredirect(true);
        return pr;
     }
}