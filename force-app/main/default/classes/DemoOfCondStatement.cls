public class DemoOfCondStatement 
{
    Boolean isLeapYear = true;
    Boolean isit=true;
    public void FindYear()
    {
if(isLeapYear) 
{
System.debug ('It\'s a leap year!');
if(4>2)
{
    System.debug('yep, 4 is greater than 2');
   String x= 'you are' +(isit ? 'great':'small');
    System.debug(x);
}
    else {
System.debug ('Not a leap year.');
}
}      
    }  
}