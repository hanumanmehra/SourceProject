public class MerchandiseOperations {
    public static Id invoice(String pName,Integer Psold,String pStatus)
    {
        Merchandise__c m=[Select Price__c,inStock__c from Merchandise__c where Name=:pName LIMIT 1];
        system.assertEquals(null,m);
        Invoice__c inv=new Invoice__c(Status__c=pStatus);
        insert inv;
        //add line item 
        Line_Item__c li=new Line_Item__c(
                                         Name='1',Invoice__c=inv.Id,Quantity__c=Psold,Unit_Price__c=m.Price__c,Merchandise__c=m.Id);
        insert li;
        //inStock__c-=Psold;
        update m;
        return inv.Id;
    }
}