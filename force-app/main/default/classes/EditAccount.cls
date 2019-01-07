public class EditAccount
{
    public Account acc{get;set;}
    public List<Account> listacc{get;set;}

public EditAccount() 
{     
    String ac= Apexpages.currentPage().getparameters().get('Id');
    listacc=new List<Account>();
    if(ac!='' && ac!=null)
    {
        list<Account>  listacc=[Select Name,Id,ownerId,rating,phone,Active__c,accountnumber,website,site,ownership,industry,sic,accountsource,SLA__c,NumberofLocations__c,SLAExpirationDate__c,description,AnnualRevenue,UpsellOpportunity__c,YearStarted,CustomerPriority__c,SicDesc,BillingCity,BillingStreet,BillingCountry,BillingState,NaicsDesc,DunsNumber,NumberOfEmployees,NaicsCode,LastModifiedById,CreatedById,shippingCity,shippingCountry,shippingStreet,shippingState,Type,CleanStatus,Fax,TickerSymbol,Tradestyle From Account where Id=: ac ];
            if(listacc.size()>0)
            {
                acc=listacc[0];
            }
    }
}

    public PageReference save() 
    {   
        try
        {
            upsert acc;
        }
        catch(exception e)
        {
        }
        PageReference page = new Pagereference('/apex/Pagination?Id='+Account.Id);
        System.debug('id of this'+page);
        return page;
    }
    public PageReference cancel()
    {
        PageReference newpage = new PageReference('/apex/Pagination');
        return newpage;
    }
}