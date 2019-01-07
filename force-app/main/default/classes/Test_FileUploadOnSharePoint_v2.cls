@istest
public class Test_FileUploadOnSharePoint_v2{
    Static testMethod  void  FileUploadOnSharePoint(){
        
        Account acc= new Account ();
        acc.name ='test';
        insert acc;
        System.assertNotEquals(Null,acc);
        
        Folder__c rootFolder = new Folder__c();
        rootFolder.sObject_Record_ID__c = acc.Id;
        rootFolder.name = acc.Name;
        rootFolder.sObject_Type__c ='Account';
        insert rootFolder;
          System.assertNotEquals(Null,rootFolder);
        
        Folder__c folder1 = new Folder__c();
        folder1.sObject_Record_ID__c = acc.Id;
        folder1.parent_folder__c = rootFolder.Id;
        folder1.name ='test1';
        folder1.sObject_Type__c ='Account';
        insert folder1;
          System.assertNotEquals(Null,folder1);
        
         
        File__c   file = new File__c  ();
        file.Name = 'image1'; 
        file.File_Type__c ='jpg';
        file.URL__c = ' https://dev20171.sharepoint.com/Shared%20Documents/Account/test/image1.jpg' ;  
        file.File_Size__c =  200 ;
        file.Folder__c =rootFolder.Id;
        file.File_Source__c='Inline' ;
        insert file;
        System.assertNotEquals(Null,file);
         
        string cv = 'document';
        Blob cvBlob = Blob.valueOf(cv);
         
         SharePonit_File_Upload_Url__c  enpointOfFileUpload =  new SharePonit_File_Upload_Url__c();
         enpointOfFileUpload.name ='test';
         enpointOfFileUpload.SP_File_Upload_EndPoint__c  ='http://54.226.92.191/RESTUploadFile /WCFUploader.svc/StreamFile/';
         enpointOfFileUpload.SP_File_Upload_EndPoint__c ='http://54.226.92.191/RESTUploadFile/WCFUploader.svc/SP_UploadFile';   
         insert enpointOfFileUpload;
         System.assertNotEquals(Null,enpointOfFileUpload);
        
        test.StartTest();
             Apexpages.currentPage().getparameters().put('Id',+folder1.id); 
            ApexPages.StandardController asp = new ApexPages.StandardController(folder1);
            FileUploadOnSharePoint_v2 sfSpFileUplod  = new FileUploadOnSharePoint_v2(asp); 
            
            /*StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('FileUplodStaticresource');
            mock.setStatusCode(200);
            //mock.setHeader('Content-Type', 'application/json');
            Test.setMock(HttpCalloutMock.class, mock);*/
            Test.setMock(HttpCalloutMock.class, new FileUploadHttpCalloutMock ()); 
            
            sfSpFileUplod.fileName='test ';
            sfSpFileUplod.file =cvBlob ; 
            sfSpFileUplod.fileType  ='text';
            sfSpFileUplod.fileSize  =1000;
            sfSpFileUplod.selectedFolderId=folder1.Id;
            sfSpFileUplod.uploadFile();
            
          sfSpFileUplod.fileName='image1';
            sfSpFileUplod.file =cvBlob ; 
            sfSpFileUplod.fileType  ='jpg';
            sfSpFileUplod.fileSize  =2000;
            sfSpFileUplod.selectedFolderId=rootFolder.Id;
            sfSpFileUplod.uploadFile();
            
         
        test.StopTest();
    }
}