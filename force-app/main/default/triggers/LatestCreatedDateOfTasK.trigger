trigger LatestCreatedDateOfTasK on Task (after insert,after delete,after update,after undelete) {
    List<Task> ListOfTask =Trigger.isdelete ? trigger.old : trigger.New;
    Set<Id> setOfContactIds =  new Set<Id> ();
    for(Task tsk : ListOfTask ){
        if(Trigger.isInsert  || Trigger.isundelete  || Trigger.isdelete  ||Trigger.isupdate  && tsk.WhoId  != Trigger.OldMap.get(tsk.Id).WhoId){
            setOfContactIds.add(tsk.WhoId);
            if(Trigger.isupdate  && tsk.WhoId  != Trigger.OldMap.get(tsk.Id).WhoId){
                 setOfContactIds.add(Trigger.OldMap.get(tsk.Id).WhoId);
            }
        }
    }
    System.debug('setOfContactIds'+setOfContactIds);
    if(setOfContactIds != null && setOfContactIds.size() > 0){
        List<Contact> listOfContact =[Select Id,Name,(Select Id,CreatedDate From Tasks Order by CreatedDate desc) From Contact  Where Id In:setOfContactIds];
        System.debug('listOfContact ::::'+listOfContact );
        if(listOfContact != null && listOfContact .size() > 0){
            for( Contact con  : listOfContact ) {
                if(con.Tasks != null  && con.Tasks.size() > 0){
                  System.debug('task date'+con.Tasks[0].CreatedDate);

                  con.LatestTaskDateTime__c = con.Tasks[0].CreatedDate ; 
                  }  
            }
            update listOfContact ;
        }
    }

}