/**
 * OrderTriggerHandler est une classe Apex qui implémente la logique des déclencheurs de mise à jour avant et après sur les objets Order dans Salesforce.
 *
 * La méthode onBeforeUpdate(List<Order> newOrders) calcule le montant net pour chaque commande de la liste en soustrayant le coût d'expédition du montant total.
 *
 * La méthode onAfterUpdate(List<Order> newOrders) met à jour le revenu (Chiffre_d_affaire__c) pour chaque compte associé à une commande dans la liste en ajoutant le montant total de la commande au revenu existant du compte.
 */

public with sharing class OrderTriggerHandler {
    
    //onBeforeUpdate calcule le montant net pour chaque commande de la liste en soustrayant le coût d'expédition du montant total.
    public static void onBeforeUpdate(List<Order> newOrders) {
    // Boucle dans la liste newOrders
    for (Order newOrder : newOrders) {      
        if (newOrder.ShipmentCost__c != null) {  
    // Calculer le montant net
    newOrder.NetAmount__c = newOrder.TotalAmount - newOrder.ShipmentCost__c;
            }
            else {
                // Si l'un des champs est null, le montant net est égal au montant total
                newOrder.NetAmount__c = newOrder.TotalAmount;
            }
            }
        }
    
    //onAfterUpdate met à jour les revenus (Chiffre_d_affaire__c) pour chaque compte associé à une commande dans la liste en ajoutant le montant total de la commande aux revenus existants du compte.
    
    public static void onAfterUpdate(List<Order> newOrders) {

        // Mappez pour stocker les comptes avec leurs identifiants associés
            Map<Id, Account> accountsMap = new Map<Id, Account>();

        // Requête pour récupérer les comptes de la base de données
            List<Account> listAccount = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN :accountsMap.keySet() ];

// Boucle dans la liste newOrders
    for (Order order : newOrders) {
        // Vérifiez si le statut de la commande est modifié à "Ordered"
            if (order.Status == 'Ordered') {
        if (order.TotalAmount != null && order.AccountId != null) {
            if (!accountsMap.containsKey(order.AccountId)) {
                accountsMap.put(order.AccountId, new Account(Id = order.AccountId, Chiffre_d_affaire__c = order.TotalAmount));
            } }else {
                Account account = accountsMap.get(order.AccountId);
                account.Chiffre_d_affaire__c += order.TotalAmount;
            }
        }
    }
    // Mettre à jour les comptes dans la base de données
    update accountsMap.values();
    }}