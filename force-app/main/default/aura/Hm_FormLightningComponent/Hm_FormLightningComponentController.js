({
	 getHMAccount : function(component, event, helper) {
        var action = component.get("c.getHmAccountlist");
        action.setParams({
           formId: component.get("v.formId")
        });
        action.setCallback(this, function(a) {
            component.set("v.account", a.getReturnValue());
        })
        $A.enqueueAction(action); 
    },
    accountContValList : function(component, event, helper) {
      var action = component.get("c.getHmAccountlist");
        action.setParams({
            
           "formId": component.get("v.formId")
        });
        
        action.setCallback(this, function(a) {
            var conValTableList=a.getReturnValue();
            alert("conValTableList  "+conValTableList);
            //System.debug('conValTableList::'+conValTableList);
            component.set("v.valueTableContValSizeFlag",conValTableList.length);
            component.set("v.AccountContVal", a.getReturnValue());
        })
        $A.enqueueAction(action); 
    },
    
    addAccValRow : function(component, event, helper) {
        var HmAccountlist=component.get("v.AccountContVal");
        var action = component.get("c.newRowContactTable"); //call apex controller method
        action.setParams({
            
            "contactId": component.get("v.formId")
            // contractVehicalId: "a00370000050rtiAAA"
        });
        action.setCallback(this,function(a){
            var newConVal=a.getReturnValue();
           	alert("RecordTypeId  "+newConVal);
            //alert("Contract_Vehicle__c.Id  "+newConVal.Contract_Vehicle__c);
            HmAccountlist.push(newConVal);
            component.set("v.AccountContVal",HmAccountlist);
        });
        $A.enqueueAction(action);
    },
    
    saveAccountTable : function(component, event, helper) {
        helper.saveAccountTableList(component, event, helper);
        helper.AccountTableList(component, event, helper);
    }
})