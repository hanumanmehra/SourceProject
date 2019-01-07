public class MyAccountController
  { 
    public Account account{get;set;}
    public List<Contact> listcont{get;set;}
    public List<Case> listcase{get;set;}
     
    private Account acc; 
    private String queryString; 
    String ac= Apexpages.currentPage().getparameters().get('Id');
     
       public MyAccountController() 
          {      
         account=new Account();
         listcont=new List<Contact>();
         listcase=new List<case>();
         
              if(ac!='' && ac!=null)
            {
                List<Account> aclist=[Select Name,Id,ownerId,rating,phone,Active__c,accountnumber,website,site,ownership,industry,sic,accountsource,SLA__c,NumberofLocations__c,SLAExpirationDate__c,description,AnnualRevenue,UpsellOpportunity__c,YearStarted,CustomerPriority__c,SicDesc,NaicsDesc,DunsNumber,NumberOfEmployees,NaicsCode,LastModifiedById,CreatedById,shippingCity,shippingCountry,shippingStreet,shippingState,Type,CleanStatus,Fax,TickerSymbol,Tradestyle From Account where Id=: ac LIMIT 1];
            if(aclist.size()>0)
             {
             account=aclist[0];
             listcase=[Select Id,CaseNumber,Subject,Priority,Status From case where AccountId=:Account.Id];
             listcont=[Select Name,Email,phone From Contact Where AccountId=:Account.Id];
            }
            }
 
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
 }