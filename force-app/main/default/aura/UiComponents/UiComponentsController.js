({
	getInput : function(cmp, event){
		 var fullName = cmp.find("name").get("v.value");
      var outName = cmp.find("nameOutput");
      outName.set("v.value", fullName);
        
        var attributeValue = cmp.get("v.text");
        console.log("current text: " + attributeValue);

        var target;
        if (event.getSource) {
            // handling a framework component event
            target = event.getSource(); // this is a Component object
            cmp.set("v.text", target.get("v.label"));
        } else {
            // handling a native browser event
            target = event.target.value; // this is a DOM element
            cmp.set("v.text", event.target.value);
        }
	}
})