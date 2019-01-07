@isTest
private class Test_technomileCom{
   
   static testMethod void myUnitTest() { 
        Test.setMock(WebServiceMock.class, new technomileComServiceMockupcls());
        
        Account ac = new Account();
        ac.Name = 'TestHM';
        insert ac;
       System.assertNotEquals(Null,ac);
        
        String accID = ac.id;
        
        Folder__c rootFolder = new Folder__c();
        rootFolder.sObject_Record_ID__c = ac.Id;
        rootFolder.name = ac.Name;
        rootFolder.sObject_Type__c ='Account';
        insert rootFolder;
       System.assertNotEquals(Null,rootFolder);
        
        wwwTechnomileconnectCom.GetDataUsingDataContractResponse_element recordCreationObj = new  wwwTechnomileconnectCom.GetDataUsingDataContractResponse_element ();
        
        
        wwwTechnomileconnectCom.SP_MoveFolder_element spfolder = new wwwTechnomileconnectCom.SP_MoveFolder_element ();
        spfolder.FolderString = 'test';
        spfolder.newFolderstring = 'test2';
        spfolder.AccountID =ac.id;
        spfolder.FolderID =rootFolder.id;
        
        wwwTechnomileconnectCom.GetData_element delement = new wwwTechnomileconnectCom.GetData_element();
        delement.value = 3;
        
        wwwTechnomileconnectCom.SP_DeleteFile_element spDelete = new wwwTechnomileconnectCom.SP_DeleteFile_element();
        spDelete.filename = 'test.txt';
        spDelete.FolderString = rootFolder.Name; 
        
        wwwTechnomileconnectCom.SP_CreateFolderResponse_element spCreatefolder  = new wwwTechnomileconnectCom.SP_CreateFolderResponse_element();
        spCreatefolder.SP_CreateFolderResult = true;
        
        wwwTechnomileconnectCom.SP_MoveFolderResponse_element spMoveFolder = new wwwTechnomileconnectCom.SP_MoveFolderResponse_element();
        spMoveFolder.SP_MoveFolderResult = true;
        
        
        wwwTechnomileconnectCom.SP_MoveFile_element spMoveElement = new wwwTechnomileconnectCom.SP_MoveFile_element();
        spMoveElement.fileName = 'test.txt';
        spMoveElement.FolderString = 'test'; 
        spMoveElement.newFolderString = 'test2'; 
        spMoveElement.AccountID = ac.id; 
        spMoveElement.FolderID =  rootFolder.id;
        
        wwwTechnomileconnectCom.SP_CreateFolder_element spCreateFolderElem = new wwwTechnomileconnectCom.SP_CreateFolder_element ();
        spCreateFolderElem.FolderString = 'test';
        spCreateFolderElem.AccountID = ac.id;
        spCreateFolderElem.FolderID = rootFolder.id;
       
    }
}