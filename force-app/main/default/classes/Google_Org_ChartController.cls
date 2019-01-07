public  with sharing class Google_Org_ChartController{
    //public String selectedNodeId{get;set;}
    public list<wr_OrganizationChartController> contactsChart{get;set;}
    //public list<wr_DegreeNetworkGraph> wr_degreeNetworkGraphList{get;set;}
    public list<opportunity> listOfAccountOpp;
    public Integer totalOpportunities;
    public Google_Org_ChartController(ApexPages.standardController controller){
        totalOpportunities =0;
        contactsChart =  new list<wr_OrganizationChartController>();
        listOfAccountOpp =  new list<opportunity> ();
        //wr_degreeNetworkGraphList = new list<wr_DegreeNetworkGraph>();
        list<Contact> contactList =  new list<Contact>();
        id accId = ApexPages.currentPage().getParameters().get('id');
        if(Schema.sObjectType.Contact.isAccessible() && Schema.sObjectType.Contact.isAccessible()&& Schema.sObjectType.contact.fields.name.isAccessible() &&  Schema.sObjectType.contact.fields.title.isAccessible() && Schema.sObjectType.contact.fields.accountId.isAccessible() && Schema.sObjectType.contact.fields.OwnerId.isAccessible() && Schema.sObjectType.contact.fields.Reporting_Manager__c.isAccessible() && Schema.sObjectType.contact.fields.Image_Url__c.isAccessible() && Schema.sObjectType.contact.fields.Relationship_Strengths__c.isAccessible() && Schema.sObjectType.Task.isAccessible() && Schema.sObjectType.Task.fields.Subject.isAccessible() && Schema.sObjectType.Opportunity.isAccessible() && Schema.sObjectType.Opportunity.fields.AccountId.isAccessible()){
            contactList = [SELECT id, name,title,Reporting_Manager__c,Image_Url__c,OwnerId,Owner.Name,Relationship_Strengths__c,Account.name,Account.ParentId,(SELECT Id,Name FROM contacts__r),(SELECT Id, Subject FROM Tasks) FROM contact WHERE accountId  =: accId];
            listOfAccountOpp  = [select id,name from opportunity Where AccountId =:accId];
        }
        
        if(listOfAccountOpp  != null && listOfAccountOpp.size() > 0 ){
            totalOpportunities= listOfAccountOpp.size();
        }
        //System.debug('Task' +contactList[0].Tasks +'Task size' +contactList[0].Tasks.size());
        map<Id,List<String>> mapOfContactOpportunity =  new map<Id,List<String>>(); 
        List<String> listOfContactOpp = new List<String>();
        if(Schema.sObjectType.OpportunityContactRole.isAccessible() && Schema.sObjectType.OpportunityContactRole.fields.IsPrimary.isAccessible() && Schema.sObjectType.OpportunityContactRole.fields.Role.isAccessible() &&  Schema.sObjectType.OpportunityContactRole.fields.ContactId.isAccessible() &&  Schema.sObjectType.OpportunityContactRole.fields.OpportunityId.isAccessible()){
            for(OpportunityContactRole oppContRole : [SELECT Id,IsPrimary,Role,ContactId,Contact.AccountId,OpportunityId,Opportunity.Name FROM OpportunityContactRole where ContactId IN:contactList] ){
                if(mapOfContactOpportunity.containsKey(oppContRole.ContactId)) {
                    String opportunityNameIds = oppContRole.OpportunityId+':'+oppContRole.Opportunity.Name; 
                    listOfContactOpp.add(opportunityNameIds);
                    //System.debug('listOfContactOpp in if ::::'+listOfContactOpp);
                } 
                else{
                    listOfContactOpp = new List<String>();
                    String opportunityNameIds= oppContRole.OpportunityId+':'+oppContRole.Opportunity.Name; 
                    listOfContactOpp.add(opportunityNameIds);
                }           
                mapOfContactOpportunity.put(oppContRole.ContactId,listOfContactOpp);             
            }
        }
        
        if(contactList.size() > 0) {
            /*if(contactList[0].Account.ParentId != null){
                degreeOfAccount(contactList[0].Account.ParentId,contactList[0].AccountId);
            }*/
            integer i=0;
            for(contact con : contactList){
                wr_OrganizationChartController wr_node = new wr_OrganizationChartController();
                if(con.Reporting_Manager__c ==null) {
                    wr_node.Name =con.Name;
                    if(con.Relationship_Strengths__c =='Strong'){
                        wr_node.rating ='green';
                    }
                    else if(con.Relationship_Strengths__c =='Moderate'){
                        wr_node.rating ='orange';
                    }
                    else if(con.Relationship_Strengths__c =='Weak'){
                        wr_node.rating ='red';
                    }
                    if(mapOfContactOpportunity.keyset().size() > 0 && mapOfContactOpportunity.containsKey(con.Id)){
                        Decimal opporPercentage;
                        wr_node.listOfOpportunity = mapOfContactOpportunity.get(con.Id);
                        System.debug('size if '+mapOfContactOpportunity.get(con.Id).size());
                        opporPercentage = (mapOfContactOpportunity.get(con.Id).size()/totalOpportunities) * 100;
                        
                        System.debug('opporPercentage if'+opporPercentage );
                        if(opporPercentage > 0 && opporPercentage < 50){
                            wr_node.CommunicationScore ='yellow';
                        } 
                        else if(opporPercentage >= 50) {
                             wr_node.CommunicationScore ='green';
                        }
                        System.debug('CommunicationScore'+wr_node.CommunicationScore );
                    }
                    else{
                        wr_node.CommunicationScore ='red';
                    }
                    
                    if(con.Tasks != null && con.Tasks.size() > 0){
                        if(con.Tasks.size() > 0 && con.Tasks.size() <11){
                            wr_node.activityScore='Red';
                        }
                        else if(con.Tasks.size() >10 && con.Tasks.size() <31){
                            wr_node.activityScore='orange';
                        }
                        else if(con.Tasks.size() >30){
                            wr_node.activityScore='green';
                        } 
                    }
                    else{
                        wr_node.activityScore='Red';
                    }
                    wr_node.isChild =con.Contacts__r.size() > 0?true:false; 
                    wr_node.node_Contact_Id = con.Id;
                    //wr_node.node_id = integer.valueof(con.Node__c);
                    //wr_node.parent = null;
                    wr_node.title = con.title;
                    wr_node.description  = con.title;
                    wr_node.image_URL =con.Image_Url__c != null?con.Image_Url__c:'https://cdn0.iconfinder.com/data/icons/users-android-l-lollipop-icon-pack/24/user-128.png'; 
                    wr_node.accountName =con.Account.Name;
                    wr_node.accountIds = con.AccountId;
                    wr_node.ownerName =con.Owner.Name;
                    wr_node.ownerIds =con.OwnerId;
                    wr_node.parentContact =con.Reporting_Manager__c;
                }
                else {
                    wr_node.Name =con.Name;
                    if(con.Relationship_Strengths__c =='Strong'){
                        wr_node.rating ='green';
                    }
                    else if(con.Relationship_Strengths__c =='Moderate'){
                        wr_node.rating ='orange';
                    }
                    else if(con.Relationship_Strengths__c =='Weak'){
                        wr_node.rating ='red';
                    }
                    
                    if(mapOfContactOpportunity.keyset().size() > 0 && mapOfContactOpportunity.containsKey(con.Id)){
                        Double opporPercentage;
                        integer contactOpp=0;
                        wr_node.listOfOpportunity = mapOfContactOpportunity.get(con.Id);
                        contactOpp = mapOfContactOpportunity.get(con.Id).size();
                        opporPercentage = (contactOpp *100/totalOpportunities); 
                        
                        if(opporPercentage > 0 && opporPercentage < 50){
                            wr_node.CommunicationScore ='orange';
                        } 
                        else if(opporPercentage >= 50) {
                             wr_node.CommunicationScore ='green';
                        }
                        System.debug('CommunicationScore'+wr_node.CommunicationScore);
                    }
                    else{
                        wr_node.CommunicationScore ='red';
                    }
                    
                    //For Activity
                    if(con.Tasks!= null && con.Tasks.size() > 0){
                        if(con.Tasks.size() > 0 && con.Tasks.size() <11){
                            wr_node.activityScore='Red';
                        }
                        else if(con.Tasks.size() >10 && con.Tasks.size() <31){
                            wr_node.activityScore='orange';
                        }
                        else if(con.Tasks.size() >30){
                            wr_node.activityScore='green';
                        } 
                    }
                    else{
                         wr_node.activityScore='Red';
                    }
                    wr_node.isChild =con.Contacts__r.size() > 0?true:false; 
                    wr_node.node_Contact_Id = con.Id;
                    //wr_node.node_id =integer.valueof(con.Node__c);
                    //wr_node.parent =integer.valueof(con.Parent_Node__c);
                    wr_node.title = con.title;
                    wr_node.description  = con.title;
                    wr_node.image_URL =con.Image_Url__c != null?con.Image_Url__c:'https://cdn0.iconfinder.com/data/icons/users-android-l-lollipop-icon-pack/24/user-128.png'; 
                    wr_node.accountName =con.Account.Name;
                    wr_node.accountIds = con.AccountId;
                    wr_node.ownerName =con.Owner.Name;
                    wr_node.ownerIds =con.OwnerId;
                    wr_node.parentContact =con.Reporting_Manager__c; 
                }
                i++;
                contactsChart.add(wr_node);
            }
        }
    }
    
   /* public void degreeOfAccount(Id mainAccount,Id acctId){
       if(acctId != null && mainAccount != null){
           Set<Id> setOfAccountIds =  new Set<Id> ();
           Account acc =[Select Id,Name,ParentId From Account Where Id =:mainAccount limit 1];  
           setOfAccountIds.add(mainAccount);
           if(acc != null && acc.ParentId != null ){
               setOfAccountIds.add(acc.ParentId); 
           }
           if(setOfAccountIds != null && setOfAccountIds.size() > 0 ){
               map<Id,List<String>> mapOfContactParAccount = new map<Id,List<String>>();
               List<String> parentAccContactList = new list<String>();
               for(Contact cont :[SELECT id, name,title,Node__c,Parent_Node__c,Reporting_Manager__c,AccountId,Image_Url__c,OwnerId,Owner.Name,Relationship_Strengths__c,Account.name,Account.ParentId FROM contact WHERE accountId  =: mainAccount or  accountId  =:acctId]){
                    System.debug('Account ::::'+cont.AccountId);
                    if(mapOfContactParAccount.containsKey(cont.AccountId)){
                        String contactNameIds = cont.Id+':'+cont.Name; 
                        parentAccContactList.add(contactNameIds );
                        System.debug('parentAccContactList in if ::::'+parentAccContactList);
                    } 
                    else{
                        parentAccContactList = new List<String>();
                        String contactNameIds = cont.Id+':'+cont.Name; 
                        parentAccContactList.add(contactNameIds);
                        System.debug('parentAccContactList in else ::::'+parentAccContactList);
                        mapOfContactParAccount.put(cont.AccountId,parentAccContactList);
                    }           
                    mapOfContactParAccount.put(cont.AccountId,parentAccContactList);
                    System.debug('mapOfContactParAccount1 ::::'+mapOfContactParAccount);  
               }
               map<Id,List<String>> mapOfContactOpportunity =  new map<Id,List<String>>(); 
               List<String> listOfContactOpp = new List<String>();
               for(Opportunity opp : [SELECT Id,AccountId,Name FROM Opportunity where AccountId IN:setOfAccountIds] ){
                    if(mapOfContactOpportunity.containsKey(opp.AccountId)) {
                        String opportunityNameIds = opp.Id+':'+opp.Name; 
                        listOfContactOpp.add(opportunityNameIds);
                        System.debug('listOfContactOpp in if ::::'+listOfContactOpp);
                    } 
                    else{
                        listOfContactOpp = new List<String>();
                        String opportunityNameIds= opp.Id+':'+opp.Name; 
                        listOfContactOpp.add(opportunityNameIds);
                        System.debug('listOfContactOpp in else ::::'+listOfContactOpp);
                    }           
                    mapOfContactOpportunity.put(opp.AccountId,listOfContactOpp);            
                }
                
                for(Account ac: [Select Id,name,parentId,Parent.Name,OwnerId,Owner.Name from Account Where Id In:setOfAccountIds]){
                    wr_DegreeNetworkGraph wr_netNode = new wr_DegreeNetworkGraph();
                    if(ac.Id == mainAccount){
                        wr_netNode.degreeOfGraph =2;
                        wr_netNode.parentAccountName =ac.Parent.Name;
                        wr_netNode.parentAccount =ac.ParentId; 
                        wr_netNode.ownerIds =ac.OwnerId; 
                        wr_netNode.ownerName= ac.Owner.Name;
                        wr_netNode.accountIds =ac.id;
                        wr_netNode.accountName=ac.Name;
                        
                        if(mapOfContactParAccount != null && mapOfContactParAccount.keyset().size() > 0){
                            wr_netNode.contactList = mapOfContactParAccount.get(acctId);
                            System.debug('else condition of  this:::'+mapOfContactParAccount.get(acctId)+ 'AccounId::'+acctId);
                        }
                        if(mapOfContactOpportunity.keyset().size() > 0 && mapOfContactOpportunity.containsKey(ac.Id)){
                            wr_netNode.listOfOpportunity = mapOfContactOpportunity.get(ac.Id);
                        }
                        wr_degreeNetworkGraphList.add(wr_netNode);
                    }
                    else if(acc !=null && acc.ParentId !=null&& ac.Id == acc.ParentId){
                        wr_netNode.degreeOfGraph =3;
                        wr_netNode.parentAccountName =ac.Parent.Name;
                        wr_netNode.parentAccount =ac.ParentId; 
                        wr_netNode.ownerIds =ac.OwnerId; 
                        wr_netNode.ownerName= ac.Owner.Name;
                        wr_netNode.accountIds =ac.id;
                        wr_netNode.accountName=ac.Name;
                        
                        if(mapOfContactOpportunity.keyset().size() > 0 && mapOfContactOpportunity.containsKey(ac.Id)){
                            wr_netNode.listOfOpportunity = mapOfContactOpportunity.get(ac.Id);
                        }
                        if(mapOfContactParAccount != null && mapOfContactParAccount.keyset().size() > 0){
                            wr_netNode.contactList = mapOfContactParAccount.get(mainAccount);
                        }
                        wr_degreeNetworkGraphList.add(wr_netNode);
                        //System.debug('else condition of  this:::');
                   }
               }
               System.debug('wr_degreeNetworkGraphList:::'+wr_degreeNetworkGraphList);
           }   
       }    
    }*/
    
    //Wrapper class for network graph 
   /* public class wr_DegreeNetworkGraph{
        public integer degreeOfGraph{get;set;}
        public String parentAccountName{get;set;}
        public String parentAccount{get;set;}
        public String accountIds{get;set;}
        public list<string> listOfOpportunity{get;set;}
        Public List<String> contactList{get;set;}
        public String ownerIds{get;set;}
        public String ownerName{get;set;}
        public String accountName{get;set;}  
    }*/
    
    //Wrapper class for organisation chart 
    public with sharing class wr_OrganizationChartController{
        public String accountName{get;set;}
        public String accountIds{get;set;}
        public String ownerName{get;set;}
        public String ownerIds{get;set;}
        public list<string> listOfOpportunity{get;set;}
        public string Name{get;set;}
        Public String rating{get;set;}
        public integer node_id{get;set;}
        public integer parent{get;set;}
        public String parentContact{get;set;}
        public String title{get;set;}
        public String description{get;set;}
        public String image_URL{get;set;}
        public string node_Contact_Id{get;set;}
        public String activityScore{get;set;}
        public String CommunicationScore{get;set;}
        public Boolean isChild{get;set;}
    }
}