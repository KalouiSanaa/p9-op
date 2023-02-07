@isTest
public class OrderTriggerHandlerTest {

    // Méthode de test pour vérifier le comportement du déclencheur onBeforeUpdate
    @isTest
    static void testOnBeforeUpdateForMoreThenTwoHanderesOrdersToUpdateAndShipmentCost() {

        // Créer une liste d'enregistrements de compte
        List<Account> accounts = DataFactoyTest.createAccounts(1);

        // Interroger les enregistrements de commande liés aux enregistrements de compte créés
        List<Order> orders = [SELECT Id, TotalAmount,shipmentCost__c, NetAmount__c
                              FROM Order 
                              WHERE Id IN :DataFactoyTest.createOrdersForAccounts(accounts, 1, 201, 1)];

        for (Order order : orders) {

            // Mettre à jour le champ ShipmentCost__c pour tous les enregistrements de commande
            order.ShipmentCost__c = 20;
            
        }

        // Démarre un contexte de test
        Test.startTest();
        // Appel du déclencheur onBeforeUpdate
        OrderTriggerHandler.onBeforeUpdate(orders);

                // Fin du contexte de test
        Test.stopTest();


        for (Order o : orders) {

            // Vérifiez que le champ NetAmount__c est calculé correctement en fonction des champs TotalAmount et ShipmentCost__c
            System.assertEquals(o.TotalAmount - o.ShipmentCost__c, o.NetAmount__c);
        }
    }
    
 @isTest
    static void testOnBeforeUpdateForMoreThenTwoHanderesOrdersWithshipmentCostIsNull() {

        // Créer une liste d'enregistrements de compte
        List<Account> accounts = DataFactoyTest.createAccounts(1);

        // Interroger les enregistrements de commande liés aux enregistrements de compte créés
        List<Order> orders = [SELECT Id, TotalAmount,shipmentCost__c, NetAmount__c
                              FROM Order 
                              WHERE Id IN :DataFactoyTest.createOrdersForAccounts(accounts, 1, 201, 1)];

        for (Order order : orders) {

            // Mettre à jour le champ ShipmentCost__c pour tous les enregistrements de commande
            order.ShipmentCost__c = 0;
            
        }

        // Démarre un contexte de test
        Test.startTest();
        // Appel du déclencheur onBeforeUpdate
        OrderTriggerHandler.onBeforeUpdate(orders);

                // Fin du contexte de test
        Test.stopTest();


        for (Order o : orders) {

            // Vérifiez que le champ NetAmount__c est calculé correctement en fonction des champs TotalAmount et ShipmentCost__c
            System.assertEquals(o.TotalAmount, o.NetAmount__c);
        }
    }
    
    
    
    // Méthode de test pour vérifier le comportement du déclencheur onAfterUpdate
    @isTest
    static void testOnAfterUpdateWithActivatedStaus() {

        // Créer une liste d'enregistrements de compte
        List<Account> accounts = DataFactoyTest.createAccounts(1);

        // Interroger les enregistrements de commande liés aux enregistrements de compte créés
        List<Order> orders =[SELECT Id, TotalAmount, AccountId
                              FROM Order 
                              WHERE Id IN :DataFactoyTest.createOrdersForAccounts(accounts, 1,201, 1)];

       for(Order ord : orders) {
            ord.Status = 'Ordered'; 
        }
        Test.startTest();

        // Appel du déclencheur onAfterUpdate
        OrderTriggerHandler.onAfterUpdate(orders);
        
        Test.stopTest();

        // Crée un ensemble d'ID de compte pour tous les enregistrements de commande qui ont une valeur AccountId
     Set<Id> accountIds = new Set<Id>();
        
       for (Order order : Orders) {
        if (order.AccountId != null) {
        accountIds.add(order.AccountId);
    }

    // Mappez les enregistrements de compte à leur ID
Map<Id, Account> accountsMap = new Map<Id, Account>([SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN :accountIds]);
        

// Vérifier que le champ Chiffre_d_affaire__c des fiches Compte est mis à jour avec le MontantTotal des fiches Commande
            System.assertEquals(accountsMap.get(order.AccountId).Chiffre_d_affaire__c, order.TotalAmount);
        }
    }
    
    @isTest
    static void testOnAfterUpdateWithNoActivatedStatus() {

        // Créer une liste d'enregistrements de compte
        List<Account> accounts = DataFactoyTest.createAccounts(1);

        // Interroger les enregistrements de commande liés aux enregistrements de compte créés
        List<Order> orders =[SELECT Id, TotalAmount, AccountId
                              FROM Order 
                              WHERE Id IN :DataFactoyTest.createOrdersForAccounts(accounts, 1,201, 1)];

       for(Order ord : orders) {
            ord.Status = 'Draft'; 
        }
        Test.startTest();

        // Appel du déclencheur onAfterUpdate
        OrderTriggerHandler.onAfterUpdate(orders);
        
        Test.stopTest();

        // Crée un ensemble d'ID de compte pour tous les enregistrements de commande qui ont une valeur AccountId
     Set<Id> accountIds = new Set<Id>();
        
       for (Order order : Orders) {
        if (order.AccountId != null) {
        accountIds.add(order.AccountId);
    }

    // Mappez les enregistrements de compte à leur ID
Map<Id, Account> accountsMap = new Map<Id, Account>([SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN :accountIds]);
        

// Vérifier que le champ Chiffre_d_affaire__c des fiches Compte est mis à jour avec le MontantTotal des fiches Commande
            System.assertEquals(accountsMap.get(order.AccountId).Chiffre_d_affaire__c,null);
        }
    }
}