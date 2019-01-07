@IsTest
public class Test_UploadLoopFileToSharePoint {
    	static testMethod void UploadLoopFileToSharePoint() {
       
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('FileUplodStaticresource');
            mock.setStatusCode(200);
            mock.setHeader('Content-Type', 'application/json');
            Test.setMock(HttpCalloutMock.class, mock);
         
       
        Account a = new Account(name='test');
        insert a;
       	System.assertNotEquals(Null,a);
         
        ContentVersion cv = new ContentVersion(); 
        cv.Origin = 'H';
        cv.PathOnClient='Snapshot.txt';
        cv.Title ='Snapshot'; 
        cv.VersionData = Blob.valueOf('I am a file posting to Chatter');
        insert cv;
     System.assertNotEquals(Null,cv);
        
        SharePoint_File_Source__c spFileSource =  new SharePoint_File_Source__c();
        spFileSource.name = 'test';
        spFileSource.Chatter_File_Name__c ='Snapshot';
        spFileSource.Chatter_Files__c = true;
        spFileSource.Chatter_and_Direct_Upload__c = true;
        insert spFileSource;
            
       System.assertNotEquals(Null,spFileSource);
        
         SharePonit_File_Upload_Url__c  enpointOfFileUpload =  new SharePonit_File_Upload_Url__c();
         enpointOfFileUpload.name ='test';
         enpointOfFileUpload.SP_File_Upload_EndPoint__c  ='http://54.226.92.191/RESTUploadFile /WCFUploader.svc/StreamFile/';
         enpointOfFileUpload.SP_File_Upload_EndPoint__c ='http://54.226.92.191/RESTUploadFile/WCFUploader.svc/SP_UploadFile';   
         insert enpointOfFileUpload;
         System.assertNotEquals(Null,enpointOfFileUpload);
            
                Folder__c rootFolder = new Folder__c();
                rootFolder.sObject_Record_ID__c = a.Id;
                rootFolder.name = a.Name;
                rootFolder.sObject_Type__c ='Account';
                insert rootFolder;
          System.assertNotEquals(Null,rootFolder);
            
             Folder__c folder1 = new Folder__c();
                folder1.sObject_Record_ID__c = a.Id;
                folder1.parent_folder__c = rootFolder.Id;
                folder1.name ='test1';
                folder1.sObject_Type__c ='Account';
                insert folder1;
                System.assertNotEquals(Null,folder1);
       
		Set<id> setOfCvId= New Set<id> () ;
        List<String>  listOfFileName = new List<String> ();
        Map<Id,Id> mapOfContenVerParent = new  Map<Id,Id>();
        setOfCvId.add(cv.id);
       	 listOfFileName.add('Snapshot');
        listOfFileName.add('tree');
        listOfFileName.add('image');
        listOfFileName.add('test');
        mapOfContenVerParent.put(cv.Id,a.id);
            test.starttest();
           	 UploadLoopFileToSharePoint.uploadFileToSharePoint(rootFolder.Id,folder1.Id,setOfCvId,listOfFileName,mapOfContenVerParent);
           test.stoptest();
        }
}