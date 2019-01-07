public class ContactController 
{
    //variables of controller
    public List<Contact> contlist{get;set;}
    public List<Opportunity> opporlist{get;set;}
    public List<Case> listcase{get;set;}
    private ApexPages.StandardController sc;
    String ac= Apexpages.currentPage().getparameters().get('Id');
    public Task newtask{get;set;}
    public Event newevent{get;set;}
    public Task log_a_call{get;set;}
    public List<OpportunityContactRole> opporId{get;set;}
    public set<Id> contactIds{get;set;}
    List<Attachment> lstDocument{get;set;}
    public String toAddresses{get;set;}
    public String emailsubject{get;set;}
    public String body{get;set;}
    public string postCmnt{get;set;}
    public string Notesbody{get;set;}
    public String choice1{get;set;}
    public String choice2{get;set;}
    public String choice3{get;set;}
    public String question{get;set;}
    
    public ContactController(ApexPages.StandardController setcon){       
        sc = setcon;
        contlist = new List<Contact>();
        Opporlist=new List<Opportunity>();
        listcase=new List<case>();
        listcase=[Select CaseNumber,Subject,Priority,ClosedDate,Status from Case where contact.Id=:ac];
        System.debug('-----listcase-----'+listcase);
        newtask= new Task();
        newevent = new Event();
        log_a_call = new Task();
        opporId=new List<OpportunityContactRole>(); 
        set<Id> contactIds = new set<ID>();
        for(OpportunityContactRole opporId : [select ContactId from OpportunityContactRole]){
            contactIds.add(opporId.ContactId);
        } 
        System.debug('------contactIds----'+contactIds);
        opporlist=[Select Name,StageName,Amount,CloseDate from Opportunity where AccountId =:ac];
        System.debug('-----opporlist-----'+opporlist);
        getDocumentLogoUrl();
        //List<Attachment> lstDocument= new List<Attachment>();
    }
    public set<Id> getopporId(){
        return contactIds;
    }
    public PageReference savetask() 
    {  
        try{
               newtask.OwnerId = userInfo.getUserid();
               insert newtask;
        } 
       catch(exception e){
       }
       return null;
    }
 
    public PageReference saveevent(){
        try{System.debug('-----saveevnt----'+newevent);
            newevent.DurationInMinutes=60;
            newevent.ActivityDateTime=System.today();
            insert newevent;
            System.debug('-----save----'+newevent);     
        }
        catch(exception e){
                System.debug('___event'+e);
        }
        return null;
    }
    public PageReference savecalllog(){
        try{
                insert log_a_call;
                System.debug('-----log call----'+log_a_call);
        }
        catch(exception e){
            System.debug('___call'+e);
        }
        return null;
    }

    public Attachment attachment {
      get {
          if (attachment == null)
            attachment = new Attachment();
          return attachment;
        }
      set;
      }

    public PageReference upload() {

        system.debug('upload method');
        attachment.ParentId = Apexpages.currentPage().getparameters().get('Id'); // the record the file is attached to
        system.debug('upload'+ attachment);
        getDocumentLogoUrl();
    
        try {
          insert attachment;
        } 
        catch (DMLException e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'));
            return null;
        } 
        finally {
        }
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Attachment uploaded successfully'));
        return null;
    }
  
    public string getDocumentLogoUrl(){
        List<Attachment> lstDocument = [Select Id,Name,contentType from Attachment where ParentId =: Apexpages.currentPage().getparameters().get('Id')];
        System.debug('lstDocument'+lstDocument);
        return null;
    }
    public PageReference deleteacc() { 
        try { 
            String ac= Apexpages.currentPage().getparameters().get('Id');
            contlist=[select Name from Contact Where Contact.Id=:ac];
            System.debug('----contlist---'+contlist);  
            if(contlist!=null && ac!=null )
            {
                delete Contlist;        
            }   
        }
        catch(DMLException de) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,de.getmessage()));  
              
        }
        return null;
    }
  
    public PageReference deletecase() {    
        try { 
            //String ac= Apexpages.currentPage().getparameters().get('Id');
            //contlist=[select CaseNumber from Case Where Contact.Id=:ac];
            System.debug('----contlist---'+listcase);  
            if(listcase!=null && ac!=null ){
                delete listcase[0];   
            }   
        }
        catch(DMLException de) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,de.getmessage()));      
        }
        return null;
    }
    
    public void sendEmail(){
        System.debug('email method enter' +emailsubject + '*******' +'-------' +toAddresses +'++++++++' + body);
        try{   
            Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();        
            email.setSubject(emailsubject); 
            email.setToAddresses(new String[] {toAddresses} );
            email.setPlainTextBody(body);
            if(toAddresses == null && emailsubject== null ) {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.info,'Please provide the email address and subject of  the mail.'));
            }
            else{
                Messaging.sendEmail(new Messaging.Singleemailmessage[] { email});   
                //Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            }
        }
        catch(Exception e1){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.info,'Please provide the email address and subject of  the mail.'));
        }
    }
    
    public void Share(){
        String pos = postCmnt;
        System.debug('postCmnt'+postCmnt);
    }
     
    public void ask(){
        String ques=question;
        String note1=choice1;
        String note2=choice2;
        String note3=choice3;  
        System.debug('question:'+ques   + 'choice1='+note1   + 'choice2='+note2 +  'choice3='+note3);
     }
     
     public void test1(){   
     }
     public void newnote(){ 
     }
}