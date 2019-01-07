@isTest
private class Test_LoopFileMoveToSharePointTrigger {
 
    static testMethod void linkChatterFiles_Account() {
       
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('FileUplodStaticresource');
            mock.setStatusCode(200);
            mock.setHeader('Content-Type', 'application/json');
            Test.setMock(HttpCalloutMock.class, mock);
         
       
        Account a = new Account(name='test');
        insert a;
         
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
    
        FeedItem contentFI = new FeedItem();
        contentFI.Type = 'ContentPost';
        contentFI.ParentId = a.id; 
        contentFI.RelatedRecordId = cv.id;
        //contentFI.title = 'Content Post';
        contentFI.Body = 'Body of content post';
        test.startTest();
        insert contentFI;
        System.assertNotEquals(Null,contentFI);
         test.stopTest();
    } 
    
}