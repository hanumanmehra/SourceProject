@isTest
private class Account_test_class {
	
	static testMethod void myUnitTest() {
		
		Test.startTest();
		
		
        Account ac_obj=new Account();
        List<Account> newaclist = new List<Account>();
            ac_obj.Name = 'Sanjay';
            ac_obj.Site = 'owner';
        	ac_obj.ShippingState = 'Rajasthan';
            ac_obj.Phone = '9414221270' ;
        	ac_obj.Type = 'Techanology Partner';
            newaclist.add(ac_obj);
        
        Account ac_obj1=new Account();
			ac_obj1.Name = 'Sumit';
            ac_obj1.Site = 'co-owner';
        	ac_obj1.ShippingState = 'Rajasthan';
            ac_obj1.Phone = '9414221370' ;
        	ac_obj1.Type = 'management Partner';
			newaclist.add(ac_obj1);
			insert newaclist;
		
        PaginationController obj = new PaginationController();
        
        obj.alphabet = 'ALL'; 
           obj.filter();
        obj.alphabet = 's';
        obj.filter();
        obj.acclist();
        
        obj.pageno =1;
        obj.numberofchecked=2;
        obj.accept = '10';
        obj.offset_size = 10;
        obj.wraplistmethod = 'wrapvalue';
        obj.Nooflistrecord();
        Account ac1=new Account();
        obj.deleteacc();
        obj.next();
        obj.previous();
        obj.first();
        obj.last();
        obj.getDisablePrevious();
        obj.offset_size =10;
        obj.getDisablePrevious();
        obj.getDisableNext();
        obj.getTotalSize();
        obj.getTotalPages();
        obj.getPageNumber();
        obj.setPageNumber(10);
        obj.pageno = -1;
        obj.getPageSet();
        obj.pageno = 0;
        obj.getPageSet();
        obj.pageno =1000;
         obj.getPageSet();
        obj.totalsize=-67;
        obj.getPageStartno();
        obj.totalsize = 1000;
        obj.getPageStartno();
        obj.getchecked();
        obj.getPageEndno();
        Account acn = new Account();
        PaginationController.Wrapperclass wrapcls =new PaginationController.Wrapperclass(acn);
        	obj.getAccept();
        obj.setAccept('display 10');
        obj.getacset();
        obj.getItems();
         obj.export();
        Account acn1 = new Account();
        obj.listasobject.add(acn1);
        obj.export();
        obj.getDisableExport();
        
        
        
      
   
        
		Test.stopTest();
	}

}