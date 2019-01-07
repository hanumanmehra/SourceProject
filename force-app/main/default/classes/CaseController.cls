public class CaseController {
    public  List<Case> caseList {get ;set;}
    public String selectedRecordType{get;set;}
    public CaseController(){
        caseList  =  new List<Case>();
        //caseList  =[Select CaseNumber,RecordType.Name,RecordTypeId From Case ];
        getItems();
    }
    
    /*public List<SelectOption> getItems() 
    { 
        List<SelectOption> selectlist = new List<SelectOption>();
        if(caseList != null && caseList.size() >0)
        {
            for(Case cas: caseList)
            {
               
                selectlist.add(new SelectOption(cas.RecordType.Name ,cas.RecordTypeId));
            }
        }
        System.debug('selectlist :::'+selectlist);
        return selectlist;  
    }*/
    
    public List<SelectOption> getItems(){
       List<SelectOption> recordTypeOptions = new List<SelectOption>();
       List<RecordType> recordTypes = [SELECT Id,Name, Description FROM RecordType WHERE IsActive=true AND SobjectType='Case'];     
        for(RecordType rType : recordTypes){   
             recordTypeOptions.add(new SelectOption(rType.Id,rType.Name));
        }
        return recordTypeOptions;
    }

    public void fieldsOfCases()
    {
        System.debug('selectedRecordType::'+selectedRecordType);
        caseList =[Select Id, CaseNumber From Case Where RecordTypeId = :selectedRecordType];
        System.debug('caseList :::'+caseList);
    }
}