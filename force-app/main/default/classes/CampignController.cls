public class CampignController {
    @AuraEnabled
    public static List<Camping_Item__c> findcampingList(){
        List<Camping_Item__c> listOfCamping = [Select id ,Name,Quantity__c,Price__c,Packed__c From Camping_Item__c];
        if(listOfCamping != null && listOfCamping.size()>0)
            return listOfCamping;
		return Null;
    }
		
}