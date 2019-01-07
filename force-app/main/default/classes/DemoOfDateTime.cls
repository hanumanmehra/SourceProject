public class DemoOfDateTime {
    public void DateTime()
    {
       Date Mydate=Date.newInstance(2015, 8, 15);
        Time Mytime=Time.newInstance(4, 20, 10, 77);
        System.debug(Mydate);
        System.debug(Mytime);
        DateTime myDateTime=DateTime.now();
        System.debug(myDateTime);
        Date MyToday=Date.today();
        Date NextDay=MyToday.addDays(1);
        System.debug(MyToday);
    }

}