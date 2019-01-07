public class DemoOfArrayList {
    public void FindList()
    {
        list<Integer> Mylist=new List<Integer>{1,2,3,4,5,4,3,6};
            List<String> MyString=new List<String>{'one','two','three'};
            
    System.debug(Mylist.size());
    System.debug(MyString.size());
        myList.add(8);
   
        integer i=Mylist[0];
        integer j=Mylist.get(2);
        Mylist[0]=10;
        System.debug(Mylist);
        System.debug(j);
        Mylist.set(2, 15);
            }
}