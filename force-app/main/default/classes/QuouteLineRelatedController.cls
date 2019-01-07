public Class QuouteLineRelatedController
{
    /*public List<QuoteLineWrapper> quoteLineItemWrapperList{get;set;}
    public String quoteId;
    public String selectedId{get;set;}
    public Boolean isRecordLock{get;set;}
    public Quote quoteRecord{get;set;}
    
    public QuouteLineRelatedController(ApexPages.StandardController controller)
    {
        quoteRecord = new Quote();
        isRecordLock =true; 
        quoteLineItemWrapperList =  new List<QuoteLineWrapper>();
        quoteId=  controller.getId();
        quoteRecord = [Select Id,Name,Approval_Status__c,Pricebook2Id,Pricebook2.Name from Quote Where Id=:quoteId limit 1];
        System.debug('Quote '+quoteRecord);
        if(quoteRecord.Approval_Status__c =='Approval Require' || quoteRecord.Approval_Status__c =='Rejected' )
        {
           isRecordLock = false;
        }
        System.debug('isRecordLock '+isRecordLock );
        System.debug('quouteId '+quoteId );
        List<QuoteLineItem> quoteLineItemList = [Select Product2Id,Product2.name,ListPrice,UnitPrice,Quantity,TotalPrice,Subtotal,Discount,QuoteId from QuoteLineItem where QuoteId=:quoteId];
        System.debug('quoteLineItemList '+quoteLineItemList );
        if(quoteLineItemList!= null && quoteLineItemList.size() >0)
        {
            for( QuoteLineItem qc : quoteLineItemList)
            {
                System.debug(qc );
                QuoteLineWrapper qtWrap =  new QuoteLineWrapper();
                qtWrap.quoutLine = qc; 
                
                quoteLineItemWrapperList.add(qtWrap);  
            }
        }
        
          System.debug('quoteLineItemList '+quoteLineItemWrapperList);
    }
    
    
    public PageReference deleteSelectedQuoue ()
    {
        if(selectedId != null)
        {
            List<QuoteLineItem > toDeleteLineItem =  new List<QuoteLineItem >();
            for(QuoteLineWrapper wc : quoteLineItemWrapperList )
            {
               if(selectedId ==String.valueof(wc.quoutLine.Id)) 
               {
                   toDeleteLineItem.add(wc.quoutLine);
               }
            }
            
            if(toDeleteLineItem != null && toDeleteLineItem.size() >0)
            {
                delete toDeleteLineItem;
            }
        }
        
        return null;
    }
    
    public PageReference editAllQuoteLine()
    {
       String pgRef ='/quoteitm/multilineitem.jsp?quoteId='+quoteId+'&retURL=%2F'+quoteId;
       PageReference page = new Pagereference(pgRef);
       page.setRedirect(true);
       
       return page; 
    }
    
    public PageReference addNewQuoteLine()
    {
       PageReference page = new Pagereference('/apex/OpportunityProductSellPrice?id='+quoteId);
       page.setRedirect(true);
       
       return page; 
    }
    
    public Class QuoteLineWrapper
    {
         public QuoteLineItem quoutLine{get;set;} 
         public Boolean isChecked{get;set;}
         
         public QuoteLineWrapper()
         {
            quoutLine =  new QuoteLineItem ();
            isChecked =  false;
         }
    }*/
    
}