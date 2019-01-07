public class RandomContactFactory {
    public Static List<Contact> generateRandomContacts()
    {		List<Contact> conList=  new List<Contact>();
        	for(Integer i=1;i<=100;i++)
            {
                Contact con =  new Contact();
                con.FirstName='Test';
                con.LastName='Test'+i;
                conList.add(con);
            }
        return conList;
    }

}