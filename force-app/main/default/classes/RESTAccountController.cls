@RestResource(urlMapping='/licenses/serial/*') 

global with sharing class RESTAccountController {
    @HttpPost  
    global static String createNewAccount(String accountIds) {
        String companyName = RestContext.request.params.get('accountIds');
        RestRequest req = RestContext.request;
        //AccountID = req.params.get('id');
        List<Account> company = [Select ID, Name,AccountNumber,BillingCity,BillingCountry,BillingState,Description,Fax,Industry,Phone,ShippingCity,ShippingCountry from Account where Id= :accountIds Limit 1];
        String str;
        if(Company.size() >0){
             return json.serialize(Company[0]);
        }
         return '';  
    }
    
    @HttpGet
    global static String getLicenceProduct() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String serialNumber= req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        
        /*List<new_licensedproduct__c> listOfLicenseProduct = [ Select ID, new_CurtisAccountNumber__c, new_CurtisAccountName__c,new_DeviceID__c,new_ExpirationDate__c,new_HardlockID__c,new_InstallCode__c,new_LicenseUse__c, new_CurtisNAVAccountID__c,new_SerialNumber__c,new_UpdatesExpirationDate__c from new_licensedproduct__c where new_SerialNumber__c = :serialNumber Limit 1];
        //String serialiseResponse;
        if(listOfLicenseProduct.size() > 0){
             List<LicenseProductWrapper>  listOfLicenseProductWrapper = new List<LicenseProductWrapper> () ;
             LicenseProductWrapper serwrap = new LicenseProductWrapper();
             serwrap.updatesExpirationDate =listOfLicenseProduct[0].new_UpdatesExpirationDate__c ;
             serwrap.serialNumber =listOfLicenseProduct[0].new_SerialNumber__c;
             serwrap.navAccountId =listOfLicenseProduct[0].new_CurtisNAVAccountID__c;
             serwrap.licenseType=listOfLicenseProduct[0].new_LicenseUse__c;
             serwrap.installationPackCode =listOfLicenseProduct[0].new_InstallCode__c;
             serwrap.hardlockId  =listOfLicenseProduct[0].new_HardlockID__c;
             serwrap.expirationDate =listOfLicenseProduct[0].new_ExpirationDate__c;
             serwrap.deviceId= listOfLicenseProduct[0].new_DeviceID__c;
             serwrap.accountId= listOfLicenseProduct[0].new_CurtisAccountNumber__c;
             serwrap.accountName= listOfLicenseProduct[0]. new_CurtisAccountName__c;
            
             listOfLicenseProductWrapper.add(serwrap) ;
             return json.serialize(listOfLicenseProductWrapper[0]);
         }*/
         List<Account>  listOfAccount = [Select id,Name,AccountNumber from Account where Name=:serialNumber];
         if(listOfAccount  != null && listOfAccount.size() > 0){
             List<AccountInformtionWrapper> listOFAccountWrapper = new List<AccountInformtionWrapper>();
             AccountInformtionWrapper accountWrap = new AccountInformtionWrapper();
             accountWrap.accountName= listOfAccount[0].Name;
             accountWrap.accountNo=listOfAccount[0].AccountNumber;
             listOFAccountWrapper.add(accountWrap); 
             return json.serialize(listOFAccountWrapper[0]);
         }
         System.debug('serialNumber'+serialNumber);
         return '';    
    }
    public class AccountInformtionWrapper{
        public String accountName;
        public string accountNo;
    }
  /*  public class LicenseProductWrapper{
        public string accountName;
        public String accountId;
        public string deviceId ;
        public date expirationDate;
        public String hardlockId ;
        public string installationPackCode ;
        public string licenseType;
        public string navAccountId ;
        public string serialNumber ;
        public date updatesExpirationDate ;
        public string accountType ;
        public string accountUuid; 
        public string accountVendor ;
        public date activationDate ;
        public boolean active;
        public boolean deactivated;
        public date deactivationDate ;
        public string description ;
        public string dmiPackCode;
        public boolean expired ;
        public string licenseUuid;
        public integer limitedSize ;
        public String maxBuildByteYear ;
        public string preferredLang;
        public string recordType ;
        public string renewalType ;
        public string status  ;
        public boolean subscription ;
        public boolean trial ;
        public string updateChannel ;
    }*/

}