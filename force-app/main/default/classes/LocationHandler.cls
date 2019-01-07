public with sharing class LocationHandler 
{
	public static Boolean updatecheck =false;
	
	@future (callout=true)  // future method needed to run callouts from Triggers	
	public static void getLocation(Id StoreIds)
  	{
  		
  		// gather Location info
       List<Store_Location__c>  locationSTorage = [SELECT Street__c,City__c,State__c,Postal_Code__c,Country__c,Location__Latitude__s,Location__Longitude__s FROM Store_Location__c WHERE id  =: StoreIds]; 
       System.debug('StoreInfo'+locationSTorage);
       	
    	// create an address string
    	String address ='';
    	
	        if (locationSTorage[0].Street__c != null)
	            address += locationSTorage[0].Street__c +', ';
	        if (locationSTorage[0].City__c != null)
	            address += locationSTorage[0].City__c +', ';
	        if (locationSTorage[0].State__c != null)
	            address += locationSTorage[0].State__c +' ';
	        if (locationSTorage[0].Postal_Code__c != null)
	            address += locationSTorage[0].Postal_Code__c +', ';
	        if (locationSTorage[0].Country__c != null)
	            address += locationSTorage[0].Country__c;  
        HttpResponse res;
           
		if(address != null && address !='')
		{
	        address = EncodingUtil.urlEncode(address, 'UTF-8');
	        System.debug('address'+address);
	        Http h = new Http();
	        HttpRequest req = new HttpRequest();
	        req.setEndpoint('http://maps.googleapis.com/maps/api/geocode/json?address='+address+'&sensor=false');
	        req.setMethod('GET');
	        req.setTimeout(60000);
	        System.debug('req1'+req);
	        res = h.send(req);
	        System.debug('res1'+res);
		}  
		
	 	if(locationSTorage[0].Location__Longitude__s != null && locationSTorage[0].Street__c == null && locationSTorage[0].City__c == null)
		{
			String latlngaddress = '';
			
			if (locationSTorage[0].Location__Latitude__s != null)
		            latlngaddress += locationSTorage[0].Location__Latitude__s +',';
	        if (locationSTorage[0].Location__Longitude__s != null)
	        latlngaddress += locationSTorage[0].Location__Longitude__s ;
		            
				System.debug('latlngaddress before encode'+latlngaddress);
		        //latlngaddress = EncodingUtil.urlEncode(latlngaddress, 'UTF-8');
		        System.debug('latlngaddress'+latlngaddress);
		        Http h = new Http();
		        HttpRequest req = new HttpRequest();
		        req.setEndpoint('http://maps.googleapis.com/maps/api/geocode/json?latlng='+latlngaddress);
		        
		        req.setMethod('GET');
		        req.setTimeout(60000);
		        System.debug('req'+req);
		        res = h.send(req);
		        System.debug('res2'+res); 
		} 
		
        // build callout
        try	
        {
            // callout
            // parse coordinates from response
            JSONParser parser = JSON.createParser(res.getBody());
            System.debug('parser' +parser);
            double lat = null;
            double lon = null;
            while (parser.nextToken() != null) 
            {
            	System.debug('parser.getCurrentToken()'+parser.getCurrentToken() + ':::::parser.getText()' +parser.getText());   
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
                    (parser.getText() == 'location'))
                {
               		parser.nextToken(); // object start
					while (parser.nextToken() != JSONToken.END_OBJECT)
                   	{
						String txt = parser.getText();
                       	parser.nextToken();
                        if (txt == 'lat')
                       	{
                       		lat = parser.getDoubleValue();
                        	System.debug('lat'+lat);
                       	}
                              
                       else if (txt == 'lng')
                       {
                       		lon = parser.getDoubleValue();
                       	 	System.debug('lon'+lon);
                       }
                   }
                }
            }
            
            String street = '';
            String route='';
            String city = '';
            String state ='';
            String country='';
            String PostalCode ='';
			Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
			system.debug('#### jasonMap = '+jsonMap.keySet());
			if(jsonMap != null && jsonMap.size() > 0 && jsonMap.containsKey('results'))
			{
		 		List<Object> lstObj = (List<Object>)jsonMap.get('results');
		 		if(lstObj != null && lstObj.size() > 0)
		 		{ 
 		 			for(Object obj : lstObj)
		  			{
			   			Map<String, Object> mapObj = (Map<String, Object>)obj;
			   			system.debug('#### mapObj = '+mapObj.keySet());
						if(mapObj != null && mapObj.size() > 0 && mapObj.containsKey('address_components'))
			   			{
			    			List<Object> lstObj2 = (List<Object>)mapObj.get('address_components');
			    			if(lstObj2 != null && lstObj2.size() > 0)
			    			{
			    				for(Object myObj : lstObj2)
			     				{
			      					Map<String, Object> mapObj2 = (Map<String, Object>)myObj;
			      					system.debug('#### mapObj2 = '+mapObj2.keySet());
			      					if(mapObj2 != null && mapObj2.size() > 0)
		      						{
		       						
			       						if(mapObj2.containsKey('types') && (mapObj2.get('types')+'').contains('street_number') && mapObj2.containsKey('long_name'))
			       						{
			       							street =String.valueof(mapObj2.get('long_name')) ; 
		       								system.debug('#### street = '+mapObj2.get('long_name')+'street'+street);
		       							}
			       						if(mapObj2.containsKey('types') && (mapObj2.get('types')+'').contains('route') && mapObj2.containsKey('long_name'))
		       							{
		       								route =String.valueof(mapObj2.get('long_name'));
			       							system.debug('#### route = '+mapObj2.get('long_name')+'street'+street);
			       						}
								       	if(mapObj2.containsKey('types') && (mapObj2.get('types')+'').contains('locality') && mapObj2.containsKey('long_name'))
								       	{
								       		city = String.valueof(mapObj2.get('long_name')); 
								        	system.debug('#### City = '+mapObj2.get('long_name')+'city'+city);
								       	}
								       	if(mapObj2.containsKey('types') && (mapObj2.get('types')+'').contains('administrative_area_level_1') && mapObj2.containsKey('long_name'))
								       	{
								       		state =String.valueof(mapObj2.get('long_name'));
								       		system.debug('#### State = '+mapObj2.get('long_name') +'state'+state);
								       	}
								       	if(mapObj2.containsKey('types') && (mapObj2.get('types')+'').contains('country') && mapObj2.containsKey('long_name'))
								       	{
								       		country = String.valueof(mapObj2.get('long_name'));
								        	system.debug('#### Country = '+mapObj2.get('long_name')+'country'+country);
								       	}
								       	if(mapObj2.containsKey('types') && (mapObj2.get('types')+'').contains('postal_code') && mapObj2.containsKey('long_name'))
								       	{
								       		PostalCode =String.valueof(mapObj2.get('long_name'));
								        	system.debug('#### Postal code = '+mapObj2.get('long_name') +'PostalCode'+PostalCode);
								       	}
		      						}
		     					}
		    				}
		   				}
		  			}
		 		}
			}
           

            // update coordinates if we get back
            if (lat != null)
            {
                locationSTorage[0].Location__Latitude__s = lat;
                System.debug('locationSTorage[0].Location__Latitude__s'+locationSTorage[0].Location__Latitude__s);
                locationSTorage[0].Location__Longitude__s = lon;
                System.debug('locationSTorage[0].Location__Longitude__s'+locationSTorage[0].Location__Longitude__s);
                
                updatecheck = true;
            	update locationSTorage[0];
            }
            if(street!= null || city!= null ||state!= null || country!= null || PostalCode != null)
            {
            	locationSTorage[0].Street__c = street + ','+route;
            	locationSTorage[0].City__c = city;
            	locationSTorage[0].Country__c = country;
            	locationSTorage[0].State__c = state;
            	locationSTorage[0].Postal_Code__c = PostalCode;
            	updatecheck = true;
            	update locationSTorage[0];
            }
        } 
        catch (Exception e) 
        {
        }
      	 System.debug('locationSTorage[0]'+locationSTorage[0]);
    	}
	
}