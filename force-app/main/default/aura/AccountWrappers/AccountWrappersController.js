({
	doInit: function(component, event, helper) {
       var action = component.get("c.GetAccountNames");
        action.setCallback(this, function(a) {
            //alert('Account list :::'+a.getReturnValue());
            var accs = a.getReturnValue();
            alert('account:::'+accs);
            var wrappers=new Array();
            for (var idx=0; idx<accs.length; idx++) 
            {
   	 	    	var wrapper = { 'acc' : accs[idx],
                   'selected' : false
                };
    	 		wrappers.push(wrapper);
            }
            alert('Account list :::'+wrappers);
            component.set("v.wrappers", wrappers);
        })
        $A.enqueueAction(action); 
    },
    
    getAccounts: function(component, event, helper)
    {
        var wrappers=component.get('v.wrappers');
        alert('wrappers ::'+wrappers);
        var ids=new Array();
        for (var idx=0; idx<wrappers.length; idx++) {
            if (wrappers[idx].selected) {
            ids.push(wrappers[idx].acc);
        }  
        }
        component.set("v.accounts", ids);
        //var idListJSON=JSON.stringify(ids);
        //alert('idListJSON ::'+idListJSON);  
    },
    getContacts : function(component, event, helper)
    {
        var wrappers=component.get('v.wrappers');
        alert('wrappers ::'+wrappers);
        var ids=new Array();
        for (var idx=0; idx<wrappers.length; idx++) {
            if (wrappers[idx].selected) {
            ids.push(wrappers[idx].acc.Id);
        }  
        }
        var idListJSON=JSON.stringify(ids);
        alert('idListJSON ::'+idListJSON); 
        var action = component.get("c.GetContactNames");
        alert('action ::'+action); 
        action.setParams({ 
            "AccountsId": idListJSON  
        });
         action.setCallback(this, function(a) {
            var contlist=a.getReturnValue();
            alert('contlist ::'+contlist);
            var contwrappers=new Array();
            for (var idx=0; idx<contlist.length; idx++) 
            {
                //alert('contlist1 ::'+contlist[idx]);
   	 	    	var wrapper1 = { 'con' : contlist[idx],'isSelected' : false };
    	 		contwrappers.push(wrapper1);
                alert('contact  list :::'+contwrappers);
            }
            alert('contact  list :::'+contwrappers);
             var state =a.getState();  
             alert('contlist::: '+state);
            component.set("v.conwrappers", contwrappers);
        });
        $A.enqueueAction(action); 
    }
    	
})