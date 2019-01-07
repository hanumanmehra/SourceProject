({
    
	saveAccountTableList : function (component, event, helper){
    
     var delConValIds=component.get("v.delConValId");
        //alert("**delString***"+delConValIds);
        var valTableCotValList=component.get("v.AccountContVal");
        alert('valTableCotValList:::'+valTableCotValList);
        var valueTableJSON = '[';
        
        for (var i=0; i<valTableCotValList.length; i++){        
            if(valueTableJSON.length>1){
                valueTableJSON +=  ',{"attributes":{"type":"Account"},';
                var vTId = valTableCotValList[i].Id;
                var name = valTableCotValList[i].Name;
              //  alert('description = '+description);
                var accountNumber = valTableCotValList[i].AccountNumber;
                //var endDate = valTableCotValList[i].End_Date__c;
                var phone = valTableCotValList[i].Phone;
                //var Exercised_Contract_Value_Options__c  = valTableCotValList[i].Exercised_Contract_Value_Options__c ;
                var slaDate  = valTableCotValList[i].SLAExpirationDate__c;
                var Contract_Vehicle__c  = valTableCotValList[i].Contract_Vehicle__c ;
                var appendData = '';
                if(!(vTId===undefined))
                {
                     appendData +='"Id":"'+ vTId+'" ,';
                }
                appendData += '"Name":"'+ name+'" , "AccountNumber":"'+accountNumber+'","Phone":"'+phone+'","SLAExpirationDate__c":"'+slaDate+'"}';
                valueTableJSON += appendData;
            }else{
                valueTableJSON +=  '{"attributes":{"type":"Account"},';
                var vTId = valTableCotValList[i].Id;
                var name = valTableCotValList[i].Name;
              //  alert('description = '+description);
                var accountNumber = valTableCotValList[i].AccountNumber;
                //var endDate = valTableCotValList[i].End_Date__c;
                var phone = valTableCotValList[i].Phone;
                //var Exercised_Contract_Value_Options__c  = valTableCotValList[i].Exercised_Contract_Value_Options__c ;
                var slaDate  = valTableCotValList[i].SLAExpirationDate__c;
                var Contract_Vehicle__c  = valTableCotValList[i].Contract_Vehicle__c ;
                var appendData = '';
                if(!(vTId===undefined))
                {
                     appendData +='"Id":"'+ vTId+'" ,';
                }
               
                appendData += '"Name":"'+ name+'" , "AccountNumber":"'+accountNumber+'","Phone":"'+phone+'","SLAExpirationDate__c":"'+slaDate+'"}';
                valueTableJSON += appendData;
            }
        } 
      //  alert(valueTableJSON);
        
        valueTableJSON += ']';
        var action = component.get("c.saveAccountValTable");
        action.setParams({ 
            "contValList": valueTableJSON,
            "recordId": component.get("v.formId"),
            "delConValIdsStr": delConValIds
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS")
            {
                alert("records save successfully");
            }
            else if (state === "ERROR") {
                console.log(response.getError());            }
        });
        $A.enqueueAction(action);
    
},
    AccountTableList : function(component, event, helper) {
      var action = component.get("c.getHmAccountlist");
        action.setParams({
            
           "formId": component.get("v.formId")
        });
        
        action.setCallback(this, function(a) {
            var conValTableList=a.getReturnValue();
            alert(conValTableList);
            component.set("v.valueTableContValSizeFlag",conValTableList.length);
            component.set("v.AccountContVal", a.getReturnValue());
        })
        $A.enqueueAction(action); 
    },
    
})