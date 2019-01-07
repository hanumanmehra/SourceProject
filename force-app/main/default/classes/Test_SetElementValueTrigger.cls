@IsTest
public class Test_SetElementValueTrigger {
    Static testMethod  void  SetElementValue(){
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
         
        Folder__c folder2= new Folder__c();
        folder2.sObject_Record_ID__c = acc.Id;
        folder2.parent_folder__c = rootFolder.Id;
        folder2.name ='test2';
        folder2.sObject_Type__c ='Account';
        insert folder2;
        System.assertNotEquals(Null,folder2);
        
        Folder__c fold = new Folder__c();
        fold.sObject_Record_ID__c = acc.Id;
        fold.parent_folder__c = folder1.Id;
        fold.name ='test1.1';
        fold.sObject_Type__c ='Account';
        insert fold;
        System.assertNotEquals(Null,fold);
        
        Folder__c fold2 = new Folder__c();
        fold2.sObject_Record_ID__c = acc.Id;
        fold2.parent_folder__c = folder2.Id;
        fold2.name ='test2.1';
        fold2.sObject_Type__c ='Account';
        insert fold2;
        System.assertNotEquals(Null,fold2);
        SetElementValueBreakRecursive.run=true;
    }
    Static testMethod  void  SetElementValue2(){
    	Account acc= new Account ();
        acc.name ='test';
        insert acc;
       Folder__c rootFolder =  new Folder__c();
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
        folder2.parent_folder__c = rootFolder.Id;
        folder2.name ='test2';
        folder2.sObject_Type__c ='Account';
        insert folder2;
        System.assertNotEquals(Null,folder2);
        
        SetElementValueBreakRecursive.run=true;
		folder2.Parent_Folder__c = folder1.id;
        update folder2;
        System.assertNotEquals(Null,folder2);
    }
}