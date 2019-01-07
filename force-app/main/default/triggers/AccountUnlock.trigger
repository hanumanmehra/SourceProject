trigger AccountUnlock on Account (after update ) {
   Set<Id> accountSet = new Set<Id>();
   for(Account ac: Trigger.new ){
       if(ac.Status__c =='Approve'){
           accountSet.add(ac.Id);
       }
   }
   if(accountSet.size() > 0){
       // Unlock the accounts
      /*Approval.UnlockResult[] urList = Approval.unlock(accountSet, false);
        
        // Iterate through each returned result
        for(Approval.UnlockResult ur : urList) {
            if (ur.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully unlocked account with ID: ' + ur.getId());
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : ur.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Account fields that affected this error: ' + err.getFields());
                }
            }
        }*/
   }

}