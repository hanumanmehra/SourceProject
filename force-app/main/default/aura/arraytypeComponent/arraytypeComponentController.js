({
	getString : function(component, event) {
        var action =component.get("c.getStringArray");
        action.setCallback(this,function(response){
           var state = response.getState();
        if(state=="SUCCESS"){
            var stringItems = response.getReturnValue();
            component.set("v.favoriteColors", stringItems);
        }
        });
		 $A.enqueueAction(action);
	},
    
    getNumbers: function(component, event, helper) {
    var numbers = [];
    for (var i = 0; i < 20; i++) {
      numbers.push({
        value: i
      });
    }
    component.set("v.numbers", numbers); 
    }
})