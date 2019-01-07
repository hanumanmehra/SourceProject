public class StoreFrontController
{
List<DisplayMerchandise> products;
public List<DisplayMerchandise> getProducts() {
if(products == null) {
products = new List<DisplayMerchandise>();
for(Merchandise__c item : [
SELECT Id, Name, Price__c,Condition__c,inStock__c
FROM Merchandise__c])  
{
products.add(new DisplayMerchandise(item));
}
}
return products;
}
   public class DisplayMerchandise  
   {
       private Merchandise__c merchandise;
    public DisplayMerchandise(Merchandise__c item){ 
         this.merchandise =item;
     }
    // Properties for use in the Visualforce view
     public String Name {
        get { return merchandise.Name; }
    }
    
    public String Condition {
   get{return merchandise.Condition__c;}
    }   
    
   public Decimal Price{
           get{return merchandise.Price__c;}
   } 
   
   public Integer QtyToBuy {
       get;set;
   }
   
   public Integer instock {
       get;set;
   }
   } 
   
  List<DisplayMerchandise> shoppingCart=new List<DisplayMerchandise>();
   public PageReference addToCart() {
for(DisplayMerchandise p : products) {
if(0 < p.qtyToBuy) {
shoppingCart.add(p);
}
}
return null; // stay on the same page
}
public String getCartContents() {
if(0 == shoppingCart.size()) {
return '(empty)';
}
String msg = '<ul>\n';
for(DisplayMerchandise p : shoppingCart) {msg += '<li>';
msg += p.name + ' (' + p.qtyToBuy + ')';
msg += '</li>\n';
}
msg += '</ul>';
return msg;
   }
   }