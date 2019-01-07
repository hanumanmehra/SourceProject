({
	 getNumbers: function(component, event) {
        var numbers = [];
        for (var i = 0; i < 10; i++) {
            numbers.push({
                value: i
            });
        }
        component.set("v.numbers", numbers);
         
     
    }
    
})