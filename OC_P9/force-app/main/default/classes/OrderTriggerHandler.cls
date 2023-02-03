public with sharing class OrderTriggerHandler {
    
    public static void onBeforeUpdate(List<Order> newOrders) {
    // Boucle dans la liste newOrders
    for (Order newOrder : newOrders) {      
        if (newOrder.ShipmentCost__c != null) {  
    // Calculer le montant net
    newOrder.NetAmount__c = newOrder.TotalAmount - newOrder.ShipmentCost__c;
            }}
        }
    
    
    public static void onAfterUpdate(List<Order> newOrders) {
        
            Map<Id, Account> accountsMap = new Map<Id, Account>();
            List<Account> listAccount = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN :accountsMap.keySet() ];


    for (Order order : newOrders) {
        if (order.TotalAmount != null && order.AccountId != null) {
            if (!accountsMap.containsKey(order.AccountId)) {
                accountsMap.put(order.AccountId, new Account(Id = order.AccountId, Chiffre_d_affaire__c = order.TotalAmount));
            } else {
                Account account = accountsMap.get(order.AccountId);
                account.Chiffre_d_affaire__c += order.TotalAmount;
            }
        }
    }
    update accountsMap.values();
    }}