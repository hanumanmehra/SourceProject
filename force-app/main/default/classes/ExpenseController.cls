public class ExpenseController {
    @AuraEnabled
    public static List<Expense__c> getexpense(){
        return [Select Name,Id,Amount__c, Client__c, Date__c,
        Reimbursed__c, CreatedDate FROM Expense__c];
    }

}