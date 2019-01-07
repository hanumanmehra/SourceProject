public class Fridge implements KitchenUtility{
   public String ModelNumber;
    public integer NumberInStock;
    public static final Integer StockThresold=5;
        public Fridge()
     {
         ModelNumber='XX-XX';
         NumberInStock=0;    
     }
    public Fridge(String TheModelNumber,Integer TheNumberInStock)
    {     ModelNumber=TheModelNumber;
         NumberInStock= TheNumberInStock;
    }
    public void UpdateStock(Integer JustSold)
    { 
        

       NumberInStock=NumberInStock-JustSold; 
    }
   public void setModelNumber(String theModelNumber) {
modelNumber = theModelNumber;
}
public String getModelNumber() {
return modelNumber;
}
    
    public integer ecoRating
    {
        get{return ecoRating;}
        set{ecoRating=value;if(ecoRating<0) value=0;}
    }
    
   }