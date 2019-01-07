@isTest
public Class TestRestrictContactByName{
    @isTest            
    public Static void contactTest()
    {
            Account acc = new Account(Name='Test');
            insert acc;
            Contact con =  new Contact(LastName ='TestContact',AccountId=acc.id);
            insert con;
    }
    
     @isTest            
    public Static void contactTest2()
    {
            Account acc = new Account(Name='Test');
            insert acc;
            Contact con =  new Contact(LastName ='test',AccountId=acc.id);
            insert con;
            
            con.LastName = 'INVALIDNAME';
            update con; 
    }
    
    
}