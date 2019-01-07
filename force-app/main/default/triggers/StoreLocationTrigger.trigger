trigger StoreLocationTrigger on Store_Location__c (after insert, after update) 
{
	if(Trigger.IsAfter)
	{
		if(LocationHandler.updatecheck != true)
		{
			for (Store_Location__c a : trigger.new)
        	if (a.Location__c == null)
			LocationHandler.getLocation(a.Id);   
			System.debug('Trigger first time');
		}
	}
	
}