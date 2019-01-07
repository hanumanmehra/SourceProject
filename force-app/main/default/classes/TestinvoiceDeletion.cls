@IsTest
private class TestinvoiceDeletion {
      static TestMethod void TestDeletionInvoiceWithLineItem()
      {
          Invoice__c inv=TestDataFactory.CreateOneinvoice(true);
          Test.StartTest();
          Database.DeleteResult result=Database.delete(inv, false);
          test.stopTest();
              // verify invoice with line item didnot get delete
             System.assert(!result.isSuccess());
      }
    static TestMethod void TestDeletionWithOutLineItems(){
         Invoice__c inv=TestDataFactory.CreateOneinvoice(false);
        Test.startTest();
        Database.DeleteResult result=Database.delete(inv,false);
        Test.stopTest();
        //verify invoice without lineitem get deleted
        System.assert(!result.isSuccess());
    }
    static TestMethod void TestBulkDeletionInvoice()
    {
        List<Invoice__c> invlist=new LIST< Invoice__c>();
        invlist.add(TestDataFactory.CreateOneinvoice(true));
        Invlist.add(TestDataFactory.CreateOneinvoice(false));
        Test.startTest();
        Database.DeleteResult[] results=Database.delete(invlist,false);
        Test.stopTest();
        //verify the invoice with lineitem didn't get deleted
    system.assert(!results[0].isSuccess());
        //verify the invoice without lineitem didn't getdeleted
       System.assert(!results[1].isSuccess());
    }
}