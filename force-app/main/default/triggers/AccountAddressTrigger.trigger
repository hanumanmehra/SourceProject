trigger AccountAddressTrigger on Account (before insert, before update) 
{
    
    for(account acc: trigger.new)
    {
        System.debug('match checked 1'+acc.Match_Billing_Address__c);
        if(trigger.isinsert && acc.Match_Billing_Address__c == true)
        {
            if(acc.BillingPostalCode != null)
            { 
                acc.ShippingPostalCode = acc.BillingPostalCode ;
                System.debug('In Insert :::'+acc.ShippingPostalCode);
            }
        }
        
        if(trigger.isUpdate  && (trigger.oldmap.get(acc.Id).Match_Billing_Address__c == false))
        {
            System.debug('match checked 1'+acc.Match_Billing_Address__c);
            if(acc.BillingPostalCode != null)
            { 
                acc.ShippingPostalCode = acc.BillingPostalCode ;
                System.debug('is Update'+acc.ShippingPostalCode);
            }
        }
    } 
}