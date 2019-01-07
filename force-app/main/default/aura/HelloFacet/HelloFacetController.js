({
	 checkBrowser: function(component) {
        var device = $A.get("$Browser.formFactor");
         var locale = $A.get("$Locale.language");
        alert("You are using a " + device);
         lert("You are using a " + locale);
    }
})