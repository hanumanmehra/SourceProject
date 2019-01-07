@istest
public class Test_WS_SharePointToSFActionController {
	static testMethod  void  WS_SP_ToSFActionCont(){
    	Account acc= new Account(); 
        acc.name = 'Test';
        insert acc;
        
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
        
        
        File__c   files = new File__c  ();
        files.Name = 'image2'; 
        files.URL__c = 'https://dev20171.sharepoint.com/Shared%20Documents/Account/test/test1/image2.pdf' ;
        files.File_Path__c =folder1.Folder_Path__c ;  
        files.File_Size__c =  100 ;
        files.Folder__c =folder1.Id;
        files.File_Type__c ='pdf';
        files.File_Source__c='Inline' ;
        insert files;
        System.assertNotEquals(Null,files);
        
        WS_SharePointToSFActionController.createFolder('Test2',rootFolder.id); 
        //WS_SharePointToSFActionController.moveFolder();
        WS_SharePointToSFActionController.createFile('img.pdf','https://dev20171.sharepoint.com/Shared%20Documents/Account/test/test1/img.pdf',100,rootFolder.id);
        WS_SharePointToSFActionController.deleteFile('https://dev20171.sharepoint.com/Shared%20Documents/Account/test/test1/image2.pdf');
        WS_SharePointToSFActionController.deleteFolder(folder1.Id);
    }
    static testMethod  void  WS_SP_ToSFActionCont2(){
        Account acc= new Account(); 
        acc.name = 'Test';
        insert acc;
        
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
        
         Folder__c folder3 = new Folder__c();
        folder3.sObject_Record_ID__c = acc.Id;
        folder3.parent_folder__c = rootFolder.Id;
        folder3.name ='test3';
        folder3.sObject_Type__c ='Account';
        insert folder3;
        System.assertNotEquals(Null,folder3);
        
        Folder__c folder4 = new Folder__c();
        folder4.sObject_Record_ID__c = acc.Id;
        folder4.parent_folder__c = folder1.Id;
        folder4.name ='test1.1';
        folder4.sObject_Type__c ='Account';
        insert folder4;
        System.assertNotEquals(Null,folder4);
        
        Folder__c folder5 = new Folder__c();
        folder5.sObject_Record_ID__c = acc.Id;
        folder5.parent_folder__c = folder4.Id;
        folder5.name ='test1.2';
        folder5.sObject_Type__c ='Account';
        insert folder5;
        System.assertNotEquals(Null,folder5);
        
        Folder__c folder6 = new Folder__c();
        folder6.sObject_Record_ID__c = acc.Id;
        folder6.parent_folder__c = folder4.Id;
        folder6.name ='test3';
        folder6.sObject_Type__c ='Account';
        insert folder6;
        System.assertNotEquals(Null,folder6);
             
        File__c   files = new File__c  ();
        files.Name = 'image2'; 
        files.URL__c = 'https://dev20171.sharepoint.com/Shared%20Documents/Account/test/test1/image2.pdf' ;
        files.File_Path__c =folder1.Folder_Path__c ;  
        files.File_Size__c =  100 ;
        files.Folder__c =folder1.Id;
        files.File_Type__c ='pdf';
        files.File_Source__c='Inline' ;
        insert files;
        System.assertNotEquals(Null,files);
        
        File__c   files3 = new File__c  ();
        files3.Name = 'image3'; 
        files3.URL__c = 'https://dev20171.sharepoint.com/Shared%20Documents/Account/test/test1/image3.pdf' ;
        files3.File_Path__c =folder1.Folder_Path__c ;  
        files3.File_Size__c =  100 ;
        files3.Folder__c =folder4.Id;
        files3.File_Type__c ='pdf';
        files3.File_Source__c='Inline' ;
        insert files3;
        System.assertNotEquals(Null,files3);
        
        File__c   files4 = new File__c  ();
        files4.Name = 'image4'; 
        files4.URL__c = 'https://dev20171.sharepoint.com/Shared%20Documents/Account/test/test1/image4.pdf' ;
        files4.File_Path__c =folder1.Folder_Path__c ;  
        files4.File_Size__c =  100 ;
        files4.Folder__c =folder3.Id;
        files4.File_Type__c ='pdf';
        files4.File_Source__c='Inline' ;
        insert files4;
        System.assertNotEquals(Null,files4);
        
        WS_SharePointToSFActionController.createFolder('Test2',rootFolder.id); 
        WS_SharePointToSFActionController.createFolder('',rootFolder.id); 
        WS_SharePointToSFActionController.createFolder('Tst',''); 
        WS_SharePointToSFActionController.createFolder('Test3',rootFolder.id);
        WS_SharePointToSFActionController.movefile('',folder3.id,'https://dev20171.sharepoint.com/Shared%20Documents/Account/test/test1/image2.pdf','image2.pdf');
        WS_SharePointToSFActionController.movefile(folder1.Id,'','https://dev20171.sharepoint.com/Shared%20Documents/Account/test/test1/image2.pdf','image2.pdf');
        WS_SharePointToSFActionController.movefile(folder1.Id,folder3.id,'https://dev20171.sharepoint.com/Shared%20Documents/Account/test/test1/image2.pdf','image2.pdf');
        WS_SharePointToSFActionController.moveFolder('', folder3.id);
        WS_SharePointToSFActionController.moveFolder(folder4.Id, '');
        WS_SharePointToSFActionController.moveFolder(folder6.Id, folder3.id);
        WS_SharePointToSFActionController.moveFolder(folder4.Id,folder3.id);
        WS_SharePointToSFActionController.moveFolder(folder4.Id, rootFolder.id);
         WS_SharePointToSFActionController.createFile('','https://dev20171.sharepoint.com/Shared%20Documents/Account/test/test1/image.pdf',100,folder1.id);
         //WS_SharePointToSFActionController.createFile('image2.pdf','',100,folder1.id);
         //WS_SharePointToSFActionController.createFile('image.pdf','https://dev20171.sharepoint.com/Shared%20Documents/Account/test/test2/image.pdf',0,folder1.id);
         WS_SharePointToSFActionController.createFile('image2.pdf','https://dev20171.sharepoint.com/Shared%20Documents/Account/test/test1/image2.pdf',100,folder1.id);
        WS_SharePointToSFActionController.createFile('image.pdf','https://dev20171.sharepoint.com/Shared%20Documents/Account/test/test2/image.pdf',100,folder1.id);
        WS_SharePointToSFActionController.deleteFile('');
        WS_SharePointToSFActionController.deleteFile('https://dev20171.sharepoint.com/Shared%20Documents/Account/test/test1/image.pdf');
        WS_SharePointToSFActionController.deleteFolder('');
        WS_SharePointToSFActionController.deleteFolder(folder4.Id);
        WS_SharePointToSFActionController.reNameFolder('',folder3.Id);
        WS_SharePointToSFActionController.reNameFolder('Test','');
        WS_SharePointToSFActionController.reNameFolder('test1',folder3.Id);
        WS_SharePointToSFActionController.reNameFolder('Test',folder3.Id);
    }
}