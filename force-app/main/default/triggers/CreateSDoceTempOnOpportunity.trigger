trigger CreateSDoceTempOnOpportunity on Opportunity (after insert) {
    List<SDOC__SDTemplate__c> listToCreateSDoc =  new List<SDOC__SDTemplate__c>();
    List<SDOC__SDTemplate__c> listOfExistSdocTemp  =[Select Id,Name From SDOC__SDTemplate__c Where Id=:'a0A0I00000YHUmF'];
    System.debug('listOfExistSdocTemp:::'+listOfExistSdocTemp );
    
    for(Opportunity  opp : trigger.new){
      /*  SDOC__SDTemplate__c sDocTemp= listOfExistSdocTemp.size() > 0?listOfExistSdocTemp[0].clone(false,True):new SDOC__SDTemplate__c();
        System.debug('sDocTemp:::'+sDocTemp);
        
        sDocTemp.Name ='Contract'+opp .Name;
        sDocTemp.SDOC__Template_Format__c = 'PDF';
        listToCreateSDoc.add(sDocTemp);*/
        
        //SDOC.SDBatch.CreateSDoc(UserInfo.getSessionId(),'id='+opp.id+'&Object=Opportunity&doclist='+listOfExistSdocTemp[0]+'&oneclick=1');
        string coverletteTID = [select Id from SDOC__SDTemplate__c where name =: 'Contract3'][0].Id;
        string contractTID= [select Id from SDOC__SDTemplate__c where name =: 'Contract4'][0].Id;
        System.debug('coverletteTID '+coverletteTID );
        System.debug('contractTID'+contractTID);
        
        //SDOC.SDBatch.CreateSDocSync(UserInfo.getSessionId(),UserInfo.getUserName(),'id='+opp.id+'&Object=Opportunity&doclist='+coverletteTID+','+contractTID+'&oneclick=1'+'&sendEmail=1');
//}     SDOC.SDBatch.CreateSDocSync(UserInfo.getSessionId(),UserInfo.getUserName(),'/apex/SDOC__SDCreate1?id='+opp.id+'&Object=Opportunity&doclist='+coverletteTID+','+contractTID+'&oneclick=1'+'&sendEmail=1');
        //System.debug('SdocList:::'+SDOC.SDBatch.CreateSDoc(UserInfo.getSessionId(),'id='+opp.id+'&Object=Opportunity&doclist='+listOfExistSdocTemp[0]+'&oneclick=1'));
    }
    /*System.debug('listOfExistSdocTemp:::'+listToCreateSDoc );
    if(listToCreateSDoc != null && listToCreateSDoc.size()>0){
        insert listToCreateSDoc;
    }*/

}