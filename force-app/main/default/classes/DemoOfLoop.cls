public class DemoOfLoop {
  public void Findarray()
  {
      integer[] myint=new Integer[]{10,20,30,40,50,60,70,80,90,100} ;
          
          for(Integer j=1;j<=10;j++)
          for(Integer i:myint)
      {
          System.debug(i);
      }
  }
}