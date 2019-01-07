public class AccountController
{
    public List<Account> aclist{get;set;}
    public Account account{get;set;}
    String ac= Apexpages.currentPage().getparameters().get('Id');
    public String SelectId{get;set;}
    
    Public AccountController()
    {
        account=new Account();
        aclist=new List<Account>();
        aclist=[Select id,Name,phone,Site,BillingState,Type From Account ORDER BY Name];
        system.debug('ac'+ac+aclist);
        system.debug('size'+ aclist.size());
    }
    
    public PageReference edit() 
    {   
        try
        {
            update account;
        }
        catch(exception e)
        {
        }
        PageReference page = new Pagereference('/apex/NewAccountEdit?Id='+Account.Id);
        System.debug('id of this'+page);
        page.setRedirect(true);
        return page;
    }
    
    public PageReference deleteacc()
    {  
        try
        {
            String accid= ApexPages.currentPage().getParameters().get('accid'); 
            List<Account> account = [Select id from Account where Id =:SelectId];
            delete account;
            if(account !=null && accid!=null )
            {
                delete account;   
            }
             aclist=[Select id,Name,phone,Site,BillingState,Type From Account ORDER BY Name];
           
        }
        catch(DMLException de)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,de.getmessage()));
            system.debug('error message:'+de.getmessage());
            Apexpages.addmessages(de);  
        }
        return null;
    }
   
}