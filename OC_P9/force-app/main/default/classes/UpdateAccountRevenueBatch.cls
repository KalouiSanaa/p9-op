global class UpdateAccountRevenueBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext bc) {
        // Récupération des comptes qui ont au moins une commande avec le statut 'Commandé'
        String query = 'SELECT Id, (SELECT Amount, Status FROM Orders WHERE Status =\'Ordered\') FROM Account';
        return Database.getQueryLocator(query);
    }
 
    global void execute(Database.BatchableContext bc, List<sObject> scope) {
        // Récupération de toutes les commandes
        List<Order> orders =[SELECT Amount, AccountId FROM Order WHERE Status = 'Ordered'];
 
        // Mise à jour du champ Revenue__c pour chaque compte
        for(sObject s : scope) {
            Account account = (Account)s;
            Decimal totalRevenue = 0;
            for(Order o : orders) {
                if(o.AccountId == account.Id) {
                    totalRevenue += o.TotalAmount__c;
                }
            }
            account.Revenue__c = totalRevenue;
            update account;
        }
    }
 
    global void finish(Database.BatchableContext bc) {
        // Il n'y a pas de code dans cette méthode
    }
}