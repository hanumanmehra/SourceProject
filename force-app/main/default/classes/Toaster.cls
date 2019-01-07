public class Toaster implements KitchenUtility
{
 private String ModelNumber;
    public String getModelNumber()
    {
        System.debug('T'+ ModelNumber);
        Return 'T'+ModelNumber;
    }
    public void setModelNumber(String A)
    {
        ModelNumber=A;
    }
}