public class DemoOfMap {
    public void findMap()
    {
        map<Integer,String> employeeAddress=new map<integer,String>();
        employeeAddress.put(1, '123 sunny Drive,banglore,CA');
        employeeAddress.put(2,'456 night park ,banglore,CA');
        System.debug('address for employee Id 2' +employeeAddress.get(2));
        
        
     //String id map
        map<String,String> myString=
            new map<String,String>{'a'=>'apple','b'=>'bee'};
            System.debug(myString.get('a'));
        
        
    }

}