global class UpdateAccountRevenueBatch implements Database.Batchable<sObject> {
    // Méthode pour définir la requête des enregistrements à traiter en batch
    global Database.QueryLocator start(Database.BatchableContext info) {
        // La requête retourne tous les Comptes où l'Id est présent dans les Commandes avec le statut 'ordered'
        return Database.getQueryLocator([SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN (SELECT AccountId FROM Order WHERE Status = 'Ordered')]);
    }
// Méthode pour traiter les enregistrements en batch
    global void execute(Database.BatchableContext info, List<sObject> scope) {

// Map pour stocker les Comptes à mettre à jour
         Map<Id, Account> accountsToUpdate = new Map<Id, Account>();
// Itérer dans les enregistrements renvoyés par la requête dans la méthode de démarrage
         for (sObject s : scope) {
             Account acc = (Account) s;
             // Ajouter le compte à la carte avec l'identifiant du compte comme clé
             accountsToUpdate.put(acc.Id, acc);
         }
// Requête pour obtenir les commandes des comptes renvoyées par la méthode de démarrag
        List<Order> orders = [SELECT AccountId, TotalAmount FROM Order WHERE AccountId IN :accountsToUpdate.keySet()];
        
        // Itérer dans les commandes
         for(Order o : orders){

            // Obtenir le compte de la commande
            Account acc = accountsToUpdate.get(o.AccountId);
            
         // Si le compte n'est pas trouvé, créez un nouveau compte avec l'identifiant du compte et le montant total de la commande
             if(acc == null){

                 acc = new Account( Id = o.AccountId, Chiffre_d_affaire__c = o.TotalAmount );
             }
             
             else{

          // Si le Compte est trouvé, ajouter le MontantTotal de la Commande dans le champ Chiffre_d_affaire__c
                 acc.Chiffre_d_affaire__c += o.TotalAmount;
             }

            // Ajouter le compte mis à jour à la carte
             accountsToUpdate.put(o.AccountId, acc);

         }

         // Mettre à jour les comptes dans la carte
         update scope;

    }    
     
    global void finish(Database.BatchableContext info) {
    }
}
