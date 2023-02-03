global class UpdateAccountRevenueBatch implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext info) {
        return Database.getQueryLocator([SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN (SELECT AccountId FROM Order WHERE Status = 'Activated')]);
    }

    global void execute(Database.BatchableContext info, List<sObject> scope) {
        
         Map<Id, Account> accountsToUpdate = new Map<Id, Account>();

         for (sObject s : scope) {
             Account acc = (Account) s;
             accountsToUpdate.put(acc.Id, acc);
         }

        List<Order> orders = [SELECT AccountId, TotalAmount FROM Order WHERE AccountId IN :accountsToUpdate.keySet()];
        
         for(Order o : orders){
            Account acc = accountsToUpdate.get(o.AccountId);

             if(acc == null){
                 acc = new Account( Id = o.AccountId, Chiffre_d_affaire__c = o.TotalAmount );
             }else{
                 acc.Chiffre_d_affaire__c += o.TotalAmount;
             }

             accountsToUpdate.put(o.AccountId, acc);

         }

         update scope;

    }    
     
    global void finish(Database.BatchableContext info) {
    }
}
