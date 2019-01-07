({
	Init : function(component, event, helper) {
		var action  = Component.get("C.CampingList");
          action.setCallback(this, function(a) {
            component.set("v.CampingList", a.getReturnValue());
        })
        $A.enqueueAction(action); 

	}
})