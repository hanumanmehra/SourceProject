public class PaginationController{ 
    public String message {get;set;}
    public String alphabet{get;set;}
    public String accept{get;set;}
    public integer nofromacclist=10;
    public integer totalsize=0;
    public integer offset_size=0;
    public List<Account> aclist{get;set;}
    public Account account{get;set;}
    public String selectid{get;set;}
    public integer pageno{get;set;}
    public boolean checked{get;set;}
    public List<Wrapperclass> wraplist{get;set;}
    //public String message{get;set;}
    public Set<String> acset{get;set;}
    public list<Account> listasobject{get;set;}
    public String wraplistmethod{get;set;}
    public List<Account> aclist1{get;set;}
    public Integer numberofchecked{get;set;}
    
    // Constructor of class
    Public PaginationController() {
        account=new Account();
        aclist=new List<Account>();
        System.debug('Constructor Called ---------------->');
        acset=new Set<String>();
        wraplist = new List<Wrapperclass>();
        listasobject=new List<Account>();
        totalcount();
        acclist();
    }
    
    public void wraplistmethod() {  
        if(true) {
            wraplist = new List<Wrapperclass>();
            for(Account a:aclist) {
                // As each Account is processed we create a new wrapAccount object and add it to the wrapAccountList
                wraplist.add(new Wrapperclass(a));
            }
            System.debug('wraplistmethod Called ----------------'+wraplist);
        }
    }
    
    public void checkedRecord() { 
        System.debug('checkedRecord');
        if(true) {        
            wraplist  = new List<Wrapperclass>(); 
            for(Account a : aclist) {
                wraplist.add(new Wrapperclass(a));
            }
            for(Wrapperclass  Obj : wraplist) { 
                if(acset.contains(obj.wrapperac.id)){
                    obj.checked = true;
                    numberofchecked =acset.size();
                }
                else {
                    obj.checked = false;   
                }   
            }
        }     
    }   
      
    //Method of list of account
    public list<Account>  acclist() {  
        String querystr = 'Select id,Name,phone,Site,BillingState,Type From Account';
        if(alphabet != 'All' && alphabet != null && alphabet != '') {
            String temp = alphabet+'%';
            querystr += ' where name like :temp ';
        }
        querystr +=' ORDER BY Name ASC limit :nofromacclist OFFSET :offset_size';
        aclist = Database.query(querystr);
        totalcount();
        wraplistmethod();
        return aclist;    
    }
    
    //Method of total record count
    public void totalcount() { 
        String queryCount = 'select COUNT() from Account';
        if(alphabet != 'All' && alphabet != null && alphabet != '') {
            String temp = alphabet + '%';
            queryCount += ' where name like :temp ';
        }
        Integer countrecord = Database.countQuery(queryCount);
        totalsize = countrecord;
        checkedRecord();  
        processSelected();
        
    }
    
    //Method for numberof list record   
    public void Nooflistrecord() {   
        nofromacclist = integer.valueof(accept);
        offset_size = 0;
        acclist();
        checkedRecord();  
        processSelected();
          
    }  
                    
    //Method for delete record in accountlist
    public PageReference deleteacc() { 
        try { 
            Account liac = new Account();
            for(integer i = 0; i < aclist.size();i++) {
                if(aclist[i].id == selectid) {
                    liac = aclist[i];  
                }
            }
            if(liac.id != null) {
                DELETE liac;
                acclist();
                checkedRecord();  
                processSelected();
            }      
        }
        catch(DMLException de) {
           // ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,de.getmessage()));    
        }
        return null;
    }
    
    // Method is use for filter of list alphabatically
    public void filter(){ 
        if(alphabet.equals('ALL')) {
            checkedRecord();
            offset_size = 0; 
            processSelected();
            totalcount();
            acclist(); 
           
        }
        else {
            offset_size = 0;
            acclist(); 
            checkedRecord();  
            processSelected();
        }
        
    }
    
    //Method for nextbutton
    public void  next() { 
        checkedRecord(); 
        offset_size += nofromacclist; 
        acclist();
        processSelected();
        System.debug('previous Called ---------------- >');         
    }
    
    //Method for previousbutton        
    public void  previous() {
        offset_size -= nofromacclist;
        acclist();
        checkedRecord();  
        processSelected();
        System.debug('Next Called ---------------->'); 
    }
    
    //Method for Firstbutton 
    public void  first() {
        offset_size = 0;
        acclist(); 
        checkedRecord();
        processSelected();
    }
    
    //Method for last method
    public void  last() { 
        checkedRecord();
        processSelected();
        offset_size = totalsize - math.mod(totalsize ,nofromacclist);
        integer var = (offset_size >= totalsize) ? totalsize - math.mod(totalsize ,nofromacclist)-nofromacclist :  totalsize - math.mod(totalsize ,nofromacclist);
        offset_size = var;
        System.debug('-------offset_size----'+offset_size);
        acclist();
        pageno = offset_size / nofromacclist + 1 ;
        
    }
      
    //Previous disable method
    public Boolean getDisablePrevious() {
        if(offset_size == 0 )
            return true;
        else
            return false;
    }
    
    //Next disable method
    public Boolean getDisableNext() {
        if((offset_size + nofromacclist) >= totalsize)
            return true;
        else
            return false;
    }
    
    //Method of TotalSize of record
    public integer getTotalSize() {
        return totalsize;
    }
    
    //Method of get current page number
    public Integer getPageNumber() {  
          return offset_size / nofromacclist + 1;
    }
    
    //method of set page number
    public void setPageNumber(Integer p) {
    }
    
    //Method of totalpages
    public Integer getTotalPages() {
        if (math.mod(totalsize, nofromacclist) > 0) {
            return totalsize / nofromacclist + 1;
        } 
        else {
            return (totalsize / nofromacclist);
        }
    }
    
    // Method of set pageno manually in input text
    public  PageReference getPageSet() {   
        if(pageno == 0 || pageno < 0) {
            pageno = 1;
            offset_size = pageno * nofromacclist - nofromacclist;  
            acclist();
            
            }
        else {   
            if(pageno > getTotalPages()) {  
                pageno = totalsize / nofromacclist + 1;
                offset_size = (pageno * nofromacclist - nofromacclist);
                acclist(); 
            } 
            
            else {
                offset_size = pageno * nofromacclist - nofromacclist;  
                acclist(); 
            }   
        }
            checkedRecord();  
            processSelected();
            return null;
    }
    
    //Method of get start page number
    public integer getPageStartno() {
        if(totalsize > 0){
            return (nofromacclist * (offset_size / nofromacclist + 1)) - nofromacclist + 1;
        }
        else {
          return 0;
        }
    }
    
    //Method of get end page no
    public integer getPageEndno() {
        if(nofromacclist * (offset_size / nofromacclist + 1) > totalsize) {
            return totalsize;
        }
        else {
            return (nofromacclist * (offset_size / nofromacclist + 1)) ;
        }
    }
   
    //Method for selectlist
    public List<SelectOption> getItems() { 
        List<SelectOption> selectlist = new List<SelectOption>();
        selectlist.add(new SelectOption('10','Display 10   records per page'));
        selectlist.add(new SelectOption('25','Display 25   records per page'));
        selectlist.add(new SelectOption('50','Display 50   records per page'));
        selectlist.add(new SelectOption('100','Display 100 records per page'));
        selectlist.add(new SelectOption('200','Display 200 records per page'));
        return selectlist;
    }
    
    //Set get method of select list
    public String getAccept() {  
        return accept;
    }
    
    public  void setAccept( String accept) {
        this.accept = accept;
    }
    
    public void processSelected() {
          System.debug('-----5--------'+checked);
        //aclist = new List<Account>();
        for(Wrapperclass wrapAccountObj : wraplist) {
            if(wrapAccountObj.checked != false) {
                acset.add(wrapAccountObj.wrapperac.id);
                //aclist.add(wrapAccountObj.wrapperac); 
            }
            else if(wrapAccountObj.checked == false){
                acset.remove(wrapAccountObj.wrapperac.id);
            }
        }
        System.debug('-----s1--------'+acset);
        System.debug('-------aclist------'+aclist); 
    }
    
    public Set<String> getacset() {
        return acset;
    }
    
    //Wrapper class 
    public class Wrapperclass {
        public Account wrapperac{get;set;}
        public boolean checked{get;set;}
       
        //Constructor of wrapper class
        public Wrapperclass(Account ac) {
            this.wrapperac = ac;
            this.checked = false;
            System.debug('value of wrapperac'+wrapperac);
        }
    }
    
    public boolean getchecked() {
        System.debug('------value---checked----'+checked);
        return checked;    
    }
    
  //Csv export method
    public PageReference export() {
        System.debug('export'+acset);
        aclist1=[Select id,Name,phone,Site,BillingState,Type From Account];
        for(String se:acset ) {
            for(Account a:aclist1) {
                if(se==a.id){
                    listasobject.add(a);
                    System.debug('export1'+listasobject);
                    
                }  
            }
        }
        if(listasobject.size() == 0) { 
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.WARNING,'Select record to download csv'));      
        }
        else {
            PageReference pr= Page.Csvpage;
            pr.setRedirect(false); 
            return pr;   
        }
        return null;  
    }
    
    public boolean getDisableExport() {
        if(acset.size() == 0) {
            return true;
        }
        else {
            return false;
        }    
    }
}