@istest
public class Test_SFSPConnector_V2  {
    Static testMethod  void  SFSPConnector_V2(){
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl()); 
        Test.setMock(WebServiceMock.class, new WebServiceCalloutOfCreateFolder());  
        Account acc= new Account ();
        acc.name ='test';
        insert acc;
        System.assertNotEquals(Null,acc);
        
        Sharpoint_Soap_Callout_End_Point_Url__c spSoapEpoint =  new Sharpoint_Soap_Callout_End_Point_Url__c();
        spSoapEpoint.name ='test';
        spSoapEpoint.Sharpoint_End_point__c ='https://www.technomileconnect.com/WcfSFSPServiceSecurePublish/Service1.svc';
        insert spSoapEpoint;
        System.assertNotEquals(Null,spSoapEpoint);
        
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
        
        Folder__c folder2= new Folder__c();
        folder2.sObject_Record_ID__c = acc.Id;
        folder2.parent_folder__c = folder1.Id;
        folder2.name ='test1.1';
        folder2.sObject_Type__c ='Account';
        insert folder2;
        System.assertNotEquals(Null,folder2);
        
        Test.startTest();
            Test.setCurrentPageReference(new PageReference('Page.myPage')); 
            Apexpages.currentPage().getparameters().put('Id',+acc.id); 
            ApexPages.StandardController asp = new ApexPages.StandardController(acc);
            SFSPConnector_V2 sfSpConnector  = new SFSPConnector_V2 (asp); 
            sfSpConnector.pageName=ApexPages.currentPage().getUrl().substringBetween('apex/','?');
            sfSpConnector.createRootFolder();
            sfSpConnector.selectedFolderId =rootFolder.id;
            sfSpConnector.newFolder.Name='test1';
            sfSpConnector.createNewFolder();            
        Test.stopTest();
    }
    
      Static testMethod  void  SFSPConnector_V2MoveFile(){
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl()); 
        Test.setMock(WebServiceMock.class, new WebServiceCalloutOfMovefile());
       
        Account acc= new Account ();
        acc.name ='test';
        insert acc;
        System.assertNotEquals(Null,acc);
       
        Sharpoint_Soap_Callout_End_Point_Url__c spSoapEpoint =  new Sharpoint_Soap_Callout_End_Point_Url__c();
        spSoapEpoint.name ='test';
        spSoapEpoint.Sharpoint_End_point__c ='https://www.technomileconnect.com/WcfSFSPServiceSecurePublish/Service1.svc';
        insert spSoapEpoint;
        System.assertNotEquals(Null,spSoapEpoint);
         
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
        
        Folder__c newFolder = new Folder__c();
        
        File__c   file = new File__c  ();
        file.Name = 'image1'; 
        file.File_Type__c ='jpg';
        file.URL__c = ' https://dev20171.sharepoint.com/Shared%20Documents/Account/test/image1.jpg' ;  
        file.File_Size__c =  200 ;
        file.Folder__c =rootFolder.Id;
        file.File_Source__c='Inline' ;
        insert file;
        System.assertNotEquals(Null,file);
        
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
        
        File__c   file3 = new File__c  ();
        file3.Name = 'image3'; 
        file3.File_Path__c =folder1.Folder_Path__c ;  
        file3.URL__c = 'https://dev20171.sharepoint.com/Shared%20Documents/Account/test/test1/image3.jpg' ;
        file3.File_Size__c =  200 ;
        file3.Folder__c =folder1.Id;
        file3.File_Type__c ='jpg';
        file3.File_Source__c='Inline' ;
        insert file3;   
        System.assertNotEquals(Null,file3);
        
        Test.startTest();
            Test.setCurrentPageReference(new PageReference('Page.myPage')); 
            Apexpages.currentPage().getparameters().put('Id',+acc.id); 
            ApexPages.StandardController asp = new ApexPages.StandardController(acc);
            SFSPConnector_V2 sfSpConnector  = new SFSPConnector_V2 (asp); 
            sfSpConnector.pageName=ApexPages.currentPage().getUrl().substringBetween('apex/','?');
            sfSpConnector.selectedFolderId =folder1.id;
            sfSpConnector.openFilesFoldersForMove();
            System.debug('test sfSpConnector.listOfMoveFold_Wr'+sfSpConnector.listOfMoveFold_Wr);
            sfSpConnector.selectedFolderToMoveIn =rootFolder.id;
            System.debug('listOf move'+sfSpConnector.listOfMoveFold_Wr +'listSize'+sfSpConnector.listOfMoveFold_Wr.size());
            sfSpConnector.listOfMoveFold_Wr[0].isSelected = true;
            sfSpConnector.moveFolder();  
        Test.stopTest();
    }
    
     Static testMethod  void  SFSPConnector_V2MoveFolder(){
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl()); 
        Test.setMock(WebServiceMock.class, new WebServiceCalloutOfMovefolder());
    
        Account acc= new Account ();
        acc.name ='test';
        insert acc;
        System.assertNotEquals(Null,acc);
        
        Sharpoint_Soap_Callout_End_Point_Url__c spSoapEpoint =  new Sharpoint_Soap_Callout_End_Point_Url__c();
        spSoapEpoint.name ='test';
        spSoapEpoint.Sharpoint_End_point__c ='https://www.technomileconnect.com/WcfSFSPServiceSecurePublish/Service1.svc';
        insert spSoapEpoint;
        System.assertNotEquals(Null,spSoapEpoint);
         
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
        
        Folder__c folder2= new Folder__c();
        folder2.sObject_Record_ID__c = acc.Id;
        folder2.parent_folder__c = folder1.Id;
        folder2.name ='test1.1';
        folder2.sObject_Type__c ='Account';
        insert folder2;
        System.assertNotEquals(Null,folder2);
        
        Folder__c folder3= new Folder__c();
        folder3.sObject_Record_ID__c = acc.Id;
        folder3.parent_folder__c = rootFolder.Id;
        folder3.name ='test2';
        folder3.sObject_Type__c ='Account';
        insert folder3;
        System.assertNotEquals(Null,folder3);
        
        Folder__c folder4= new Folder__c();
        folder4.sObject_Record_ID__c = acc.Id;
        folder4.parent_folder__c = folder3.Id;
        folder4.name ='test 2.1';
        folder4.sObject_Type__c ='Account';
        insert folder4;
        System.assertNotEquals(Null,folder4);
        
        Folder__c newFolder = new Folder__c();
        
        File__c   file = new File__c  ();
        file.Name = 'image1'; 
        file.File_Type__c ='jpg';
        file.URL__c = ' https://dev20171.sharepoint.com/Shared%20Documents/Account/test/image1.jpg' ;  
        file.File_Size__c =  200 ;
        file.Folder__c =rootFolder.Id;
         file.File_Source__c='Inline' ;
        insert file;
        System.assertNotEquals(Null,file);
        
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
        
        File__c   file3 = new File__c  ();
        file3.Name = 'image3'; 
        file3.File_Path__c =folder1.Folder_Path__c ;  
        file3.URL__c = 'https://dev20171.sharepoint.com/Shared%20Documents/Account/test/test1/image3.jpg' ;
        file3.File_Size__c =  200 ;
        file3.Folder__c =folder1.Id;
        file3.File_Type__c ='jpg';
        file3.File_Source__c='Inline' ;
        insert file3;   
        System.assertNotEquals(Null,file3);                                   
        
        File__c   file2 = new File__c  ();
        file2.Name = 'image4';
        file2.File_Path__c =rootFolder.Folder_Path__c ;  
        file2.URL__c = 'https://dev20171.sharepoint.com/Shared%20Documents/Account/test/image4.pdf';
        file2.File_Size__c =  1000 ;
        file2.Folder__c =rootFolder.Id;
        file2.File_Type__c ='pdf';
        file2.File_Source__c='Inline' ;
        insert file2;
        System.assertNotEquals(Null,file2);
        
        File__c   file4= new File__c  ();
        file4.Name = 'test image5'; 
        file4.File_Path__c =folder2.Folder_Path__c ;  
        file4.URL__c = 'https://dev20171.sharepoint.com/Shared%20Documents/Account/test/test1/test1.1/test image5.pdf' ;
        file4.File_Size__c =  1000 ;
        file4.Folder__c =folder2.Id;
        file4.File_Type__c ='pdf';
        file4.File_Source__c='Inline' ;
        insert file4;
        System.assertNotEquals(Null,file4);
        
        Test.startTest();
            Test.setCurrentPageReference(new PageReference('Page.myPage')); 
            Apexpages.currentPage().getparameters().put('Id',+acc.id); 
            ApexPages.StandardController asp = new ApexPages.StandardController(acc);
            SFSPConnector_V2 sfSpConnector  = new SFSPConnector_V2 (asp); 
            sfSpConnector.pageName=ApexPages.currentPage().getUrl().substringBetween('apex/','?');
            sfSpConnector.selectedFolderId =folder1.id;
            sfSpConnector.openFilesFoldersForMove();
            System.debug('test sfSpConnector.listOfMoveFold_Wr'+sfSpConnector.listOfMoveFold_Wr);
            sfSpConnector.selectedFolderToMoveIn =rootFolder.id;
            sfSpConnector.selectedFolderId =folder1.id;
            System.debug('listOf move'+sfSpConnector.listOfMoveFold_Wr +'listSize'+sfSpConnector.listOfMoveFold_Wr.size());
            sfSpConnector.listOfMoveFold_Wr[0].isSelected = true;
            sfSpConnector.moveFolder();   
        Test.stopTest();
    }
    
    Static testMethod  void  SFSPConnector_V2DeleteFile(){
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl()); 
        Test.setMock(WebServiceMock.class, new WebServiceCalloutOfdeleteFile());
       
        Account acc= new Account ();
        acc.name ='test';
        insert acc;
        System.assertNotEquals(Null,acc);
        
        Sharpoint_Soap_Callout_End_Point_Url__c spSoapEpoint =  new Sharpoint_Soap_Callout_End_Point_Url__c();
        spSoapEpoint.name ='test';
        spSoapEpoint.Sharpoint_End_point__c ='https://www.technomileconnect.com/WcfSFSPServiceSecurePublish/Service1.svc';
        insert spSoapEpoint;
        System.assertNotEquals(Null,spSoapEpoint);
        
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
        
        Folder__c newFolder = new Folder__c();
        
        File__c   file = new File__c  ();
        file.Name = 'image1'; 
        file.File_Type__c ='jpg';
        file.URL__c = ' https://dev20171.sharepoint.com/Shared%20Documents/Account/test/image1.jpg' ;  
        file.File_Size__c =  200 ;
        file.Folder__c =rootFolder.Id;
         file.File_Source__c='Inline' ;
        insert file;
        System.assertNotEquals(Null,file);
        
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
        
        File__c   file3 = new File__c  ();
        file3.Name = 'image3'; 
        file3.File_Path__c =folder1.Folder_Path__c ;  
        file3.URL__c = 'https://dev20171.sharepoint.com/Shared%20Documents/Account/test/test1/image3.jpg' ;
        file3.File_Size__c =  200 ;
        file3.Folder__c =folder1.Id;
        file3.File_Type__c ='jpg';
        file3.File_Source__c='Inline' ;
        insert file3;   
        System.assertNotEquals(Null,file3);
        
        Test.startTest();
            Test.setCurrentPageReference(new PageReference('Page.myPage')); 
            Apexpages.currentPage().getparameters().put('Id',+acc.id); 
            ApexPages.StandardController asp = new ApexPages.StandardController(acc);
            SFSPConnector_V2 sfSpConnector  = new SFSPConnector_V2 (asp); 
            sfSpConnector.pageName=ApexPages.currentPage().getUrl().substringBetween('apex/','?');
            sfSpConnector.selectedFolderId =folder1.id;
            sfSpConnector.openOfThisFolder();
            sfSpConnector.listOfDelFile_Wr[1].isSelected = true;
            sfSpConnector.deleteFolder();
            sfSpConnector.uploadFile();
        Test.stopTest();
    }
    
      Static testMethod  void  SFSPConnector_V2DeleteFolder(){
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl()); 
        Test.setMock(WebServiceMock.class, new WebServiceCalloutOfDeleteFolder());
       
        Account acc= new Account ();
        acc.name ='test';
        insert acc;
        System.assertNotEquals(Null,acc);
        
        Sharpoint_Soap_Callout_End_Point_Url__c spSoapEpoint =  new Sharpoint_Soap_Callout_End_Point_Url__c();
        spSoapEpoint.name ='test';
        spSoapEpoint.Sharpoint_End_point__c ='https://www.technomileconnect.com/WcfSFSPServiceSecurePublish/Service1.svc';
        insert spSoapEpoint;
        System.assertNotEquals(Null,spSoapEpoint);
        
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
        
        Folder__c folder2= new Folder__c();
        folder2.sObject_Record_ID__c = acc.Id;
        folder2.parent_folder__c = folder1.Id;
        folder2.name ='test1.1';
        folder2.sObject_Type__c ='Account';
        insert folder2;
        System.assertNotEquals(Null,folder2);
        
        Folder__c folder3= new Folder__c();
        folder3.sObject_Record_ID__c = acc.Id;
        folder3.parent_folder__c = rootFolder.Id;
        folder3.name ='test2';
        folder3.sObject_Type__c ='Account';
        insert folder3;
        System.assertNotEquals(Null,folder3);
        
        Folder__c folder4= new Folder__c();
        folder4.sObject_Record_ID__c = acc.Id;
        folder4.parent_folder__c = folder3.Id;
        folder4.name ='test 2.1';
        folder4.sObject_Type__c ='Account';
        insert folder4;
        System.assertNotEquals(Null,folder4);
        
        Folder__c newFolder = new Folder__c();
        
        File__c   file = new File__c  ();
        file.Name = 'image1'; 
        file.File_Type__c ='jpg';
        file.URL__c = ' https://dev20171.sharepoint.com/Shared%20Documents/Account/test/image1.jpg' ;  
        file.File_Size__c =  200 ;
        file.Folder__c =rootFolder.Id;
        file.File_Source__c='Inline' ;
        insert file;
        System.assertNotEquals(Null,file);
        
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
        
        File__c   file3 = new File__c  ();
        file3.Name = 'image3'; 
        file3.File_Path__c =folder1.Folder_Path__c ;  
        file3.URL__c = 'https://dev20171.sharepoint.com/Shared%20Documents/Account/test/test1/image3.jpg' ;
        file3.File_Size__c =  200 ;
        file3.Folder__c =folder1.Id;
        file3.File_Type__c ='jpg';
        file3.File_Source__c='Inline' ;
        insert file3;   
        System.assertNotEquals(Null,file3);                                   
        
        File__c   file2 = new File__c  ();
        file2.Name = 'image4';
        file2.File_Path__c =rootFolder.Folder_Path__c ;  
        file2.URL__c = 'https://dev20171.sharepoint.com/Shared%20Documents/Account/test/image4.pdf';
        file2.File_Size__c =  1000 ;
        file2.Folder__c =rootFolder.Id;
        file2.File_Type__c ='pdf';
        file2.File_Source__c='Inline' ;
        insert file2;
        System.assertNotEquals(Null,file2);
        
        File__c   file4= new File__c  ();
        file4.Name = 'test image5'; 
        file4.File_Path__c =folder2.Folder_Path__c ;  
        file4.URL__c = 'https://dev20171.sharepoint.com/Shared%20Documents/Account/test/test1/test1.1/test image5.pdf' ;
        file4.File_Size__c =  1000 ;
        file4.Folder__c =folder2.Id;
        file4.File_Type__c ='pdf';
        file4.File_Source__c='Inline' ;
        insert file4;
        System.assertNotEquals(Null,file4);
        
        Test.startTest();
            Test.setCurrentPageReference(new PageReference('Page.myPage')); 
            Apexpages.currentPage().getparameters().put('Id',+acc.id); 
            ApexPages.StandardController asp = new ApexPages.StandardController(acc);
            SFSPConnector_V2 sfSpConnector  = new SFSPConnector_V2 (asp); 
            sfSpConnector.pageName=ApexPages.currentPage().getUrl().substringBetween('apex/','?');
            sfSpConnector.selectedFolderId =rootFolder.id;
            sfSpConnector.openOfThisFolder();
            sfSpConnector.listOfDelFile_Wr[1].isSelected = true;
            sfSpConnector.deleteFolder();     
        Test.stopTest();
    }
    
    Static testMethod  void  SFSPConnector_V2ReNameFolder(){
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl()); 
        Test.setMock(WebServiceMock.class, new WebServiceCalloutOfReNameFolder());
       
        Account acc= new Account ();
        acc.name ='test';
        insert acc;
        System.assertNotEquals(Null,acc);
        
        Sharpoint_Soap_Callout_End_Point_Url__c spSoapEpoint =  new Sharpoint_Soap_Callout_End_Point_Url__c();
        spSoapEpoint.name ='test';
        spSoapEpoint.Sharpoint_End_point__c ='https://www.technomileconnect.com/WcfSFSPServiceSecurePublish/Service1.svc';
        insert spSoapEpoint;
        System.assertNotEquals(Null,spSoapEpoint);
        
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
        
        Folder__c newFolder = new Folder__c();
        
        File__c   file = new File__c  ();
        file.Name = 'image1'; 
        file.File_Type__c ='jpg';
        file.URL__c = ' https://dev20171.sharepoint.com/Shared%20Documents/Account/test/image1.jpg' ;  
        file.File_Size__c =  200 ;
        file.Folder__c =rootFolder.Id;
        file.File_Source__c='Inline' ;
        insert file;
        System.assertNotEquals(Null,file);
        
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
        
        File__c   file3 = new File__c  ();
        file3.Name = 'image3'; 
        file3.File_Path__c =folder1.Folder_Path__c ;  
        file3.URL__c = 'https://dev20171.sharepoint.com/Shared%20Documents/Account/test/test1/image3.jpg' ;
        file3.File_Size__c =  200 ;
        file3.Folder__c =folder1.Id;
        file3.File_Type__c ='jpg';
        file3.File_Source__c='Inline' ;
        insert file3;   
        System.assertNotEquals(Null,file3);
        
        Test.startTest();
            Test.setCurrentPageReference(new PageReference('Page.myPage')); 
            Apexpages.currentPage().getparameters().put('Id',+acc.id); 
            ApexPages.StandardController asp = new ApexPages.StandardController(acc);
            SFSPConnector_V2 sfSpConnector  = new SFSPConnector_V2 (asp); 
            sfSpConnector.pageName=ApexPages.currentPage().getUrl().substringBetween('apex/','?');
            sfSpConnector.selectedFolderId =folder1.id;
            sfSpConnector.NewLableFolder ='ReName';
            sfSpConnector.changeFolderLabel();
            sfSpConnector.selectedFolderId ='';
            sfSpConnector.uploadFile();
        Test.stopTest();
    }
    Static testMethod  void  SFSPConnector_V2RootFolder(){
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl()); 
        Test.setMock(WebServiceMock.class, new WebServiceCalloutOfCreateFolder());   
        Account acc= new Account ();
        acc.name ='test';
        insert acc;
        System.assertNotEquals(Null,acc);
        
        Sharpoint_Soap_Callout_End_Point_Url__c spSoapEpoint =  new Sharpoint_Soap_Callout_End_Point_Url__c();
        spSoapEpoint.name ='test';
        spSoapEpoint.Sharpoint_End_point__c ='https://www.technomileconnect.com/WcfSFSPServiceSecurePublish/Service1.svc';
        insert spSoapEpoint;
        System.assertNotEquals(Null,spSoapEpoint);
        
        Test.startTest();
            Test.setCurrentPageReference(new PageReference('Page.myPage')); 
            Apexpages.currentPage().getparameters().put('Id',+acc.id); 
            ApexPages.StandardController asp = new ApexPages.StandardController(acc);
            SFSPConnector_V2 sfSpConnector  = new SFSPConnector_V2 (asp); 
            sfSpConnector.pageName=ApexPages.currentPage().getUrl().substringBetween('apex/','?');
            sfSpConnector.createRootFolder();
            sfSpConnector.NewLableFolder ='ReName';
            sfSpConnector.changeFolderLabel();
            sfSpConnector.openFilesFoldersForMove();
            sfSpConnector.openOfThisFolder();
        Test.stopTest();
    }
    
     Static testMethod  void  SFSPConnector_V2withoutSelectFolder(){
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl()); 
        Test.setMock(WebServiceMock.class, new WebServiceCalloutOfCreateFolder());   
        Account acc= new Account ();
        acc.name ='test';
        insert acc;
        System.assertNotEquals(Null,acc);
        
        Sharpoint_Soap_Callout_End_Point_Url__c spSoapEpoint =  new Sharpoint_Soap_Callout_End_Point_Url__c();
        spSoapEpoint.name ='test';
        spSoapEpoint.Sharpoint_End_point__c ='https://www.technomileconnect.com/WcfSFSPServiceSecurePublish/Service1.svc';
        insert spSoapEpoint;
        System.assertNotEquals(Null,spSoapEpoint);
         
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
        
        Folder__c folder2 = new Folder__c();
        folder2.sObject_Record_ID__c = acc.Id;
        folder2.parent_folder__c = rootFolder.Id;
        folder2.name ='test2';
        folder2.sObject_Type__c ='Account';
        insert folder2;
        System.assertNotEquals(Null,folder2);
        
        Test.startTest();
            Test.setCurrentPageReference(new PageReference('Page.myPage')); 
            Apexpages.currentPage().getparameters().put('Id',+acc.id); 
            ApexPages.StandardController asp = new ApexPages.StandardController(acc);
            SFSPConnector_V2 sfSpConnector  = new SFSPConnector_V2 (asp); 
            sfSpConnector.pageName=ApexPages.currentPage().getUrl().substringBetween('apex/','?');
            sfSpConnector.selectedFolderId=' ';
            sfSpConnector.createNewFolder();
            sfSpConnector.openFilesFoldersForMove();
            sfSpConnector.openOfThisFolder();
            sfSpConnector.selectedFolderId=rootFolder.Id;
            sfSpConnector.NewLableFolder ='test1';
            sfSpConnector.createNewFolder();
            sfSpConnector.selectedFolderId=folder2.Id;
            sfSpConnector.NewLableFolder ='test1';
            sfSpConnector.changeFolderLabel();
        Test.stopTest();
    }
    
    Static testMethod  void  SFSPConnector_V2ReNameAccount(){
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl()); 
        Test.setMock(WebServiceMock.class, new WebServiceCalloutOfCreateFolder());   
        Account acc= new Account ();
        acc.name ='test';
        insert acc;
        System.assertNotEquals(Null,acc);
         
        Sharpoint_Soap_Callout_End_Point_Url__c spSoapEpoint =  new Sharpoint_Soap_Callout_End_Point_Url__c();
        spSoapEpoint.name ='test';
        spSoapEpoint.Sharpoint_End_point__c ='https://www.technomileconnect.com/WcfSFSPServiceSecurePublish/Service1.svc';
        insert spSoapEpoint;
        System.assertNotEquals(Null,spSoapEpoint);
         
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
        
        Folder__c folder2 = new Folder__c();
        folder2.sObject_Record_ID__c = acc.Id;
        folder2.parent_folder__c = rootFolder.Id;
        folder2.name ='test2';
        folder2.sObject_Type__c ='Account';
        insert folder2;
        System.assertNotEquals(Null,folder2);
        
        acc.Name ='Test Rename';
        update acc;
        System.assertNotEquals(Null,acc);
       
        
        Test.startTest();
            Test.setCurrentPageReference(new PageReference('Page.myPage')); 
            Apexpages.currentPage().getparameters().put('Id',+acc.id); 
            ApexPages.StandardController asp = new ApexPages.StandardController(acc);
            SFSPConnector_V2 sfSpConnector  = new SFSPConnector_V2 (asp); 
            sfSpConnector.pageName=ApexPages.currentPage().getUrl().substringBetween('apex/','?');
        Test.stopTest();
    }
}