@isTest
private class ContactdetailTest {
	
	static testMethod void myUnitTest() 
    {
		Test.startTest();
        Contact con_obj=new Contact();
        ApexPages.StandardController setcon = new ApexPages.StandardController(con_obj);
        List<Contact>  newcontlist = new List<Contact>();
        //tcon.name== 'Avi Green';
        insert newcontlist;
        ContactController objnew = new ContactController(setcon);
         Task newtask= new Task();
        newtask.OwnerId = userInfo.getUserid();
        objnew.savetask();
        List<OpportunityContactRole> opporId=new List<OpportunityContactRole>();
        objnew.getopporId();
        Event newevent=new Event();
         newevent.DurationInMinutes=50;
        newevent.ActivityDateTime=System.today();
        objnew.saveevent();
        objnew.savecalllog();
         List<Attachment> lstDocument= new List<Attachment>();
         objnew.getDocumentLogoUrl();
        objnew.upload();
        objnew.deleteacc();
        List<Case> newcase= new List<Case>();
        Case caseobj= new Case();
        caseobj.Subject='United oil corporation';
        caseobj.Priority='low';
        caseobj.Status ='closed';
        //caseobj.CaseNumber=00000001;
        objnew.deletecase();
        objnew.postCmnt='hi how are you';
        objnew.Share();
        objnew.question='what is your name';
        objnew.choice1 = 'hanuman';
        objnew.choice2 ='balaram';
        objnew.choice3 ='lokesh';
        objnew.ask();
        objnew.emailsubject ='notice';
        objnew.toAddresses ='hanu@gmail.com';
        objnew.body = 'to inform you about notice';
        objnew.sendEmail();
        objnew.Notesbody='notes of contact';
        objnew.test1();
        objnew.newnote();
        
               
       
    }
		
}