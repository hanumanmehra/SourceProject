@isTest
public class TestDataFactory {
    public static Invoice__c CreateOneinvoice(boolean WithLineItem)
    {
        Invoice__c  TestInvoice= createInvoice();
        if(WithLineItem==true)
        {
            Merchandise__c m=CreateOneMerchandiseItem('television');
            AddLineItem(TestInvoice,m);
        }
        return TestInvoice;
    }
      private  static Merchandise__c CreateOneMerchandiseItem(String merchName)
      {
          Merchandise__c m=new Merchandise__c(Name='merchName',Description__c='new',Price__c=1300,Quantity__c=10);
          insert m;
          return m;
      }
    private static Invoice__c CreateInvoice()
    {
        Invoice__c inv=new Invoice__c(Status__c='Closed');
        insert inv;
        return inv;
    }
    private static Line_Item__c AddLineItem(Invoice__c inv,Merchandise__c m)
    {
        Line_Item__c LineItem=new Line_Item__c(Invoice__c=inv.Id,Merchandise__c=m.Id,
                                              Unit_Price__c=m.Price__c,Quantity__c=(double)(10*math.random()+1));
        insert LineItem;
        return LineItem;
    }
}