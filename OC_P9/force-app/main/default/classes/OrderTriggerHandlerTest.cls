@isTest
public class OrderTriggerHandlerTest {
    @isTest
    static void testOnBeforeUpdate() {
        List<Account> accounts = DataFactoyTest.createAccounts(1);
        List<Order> orders = [SELECT Id, TotalAmount,shipmentCost__c, NetAmount__c
                              FROM Order 
                              WHERE Id IN :DataFactoyTest.createOrdersForAccounts(accounts, 1, 100, 1)];

        for (Order order : orders) {
            order.ShipmentCost__c = 20;
            
        }
        Test.startTest();
        OrderTriggerHandler.onBeforeUpdate(orders);
        Test.stopTest();
        for (Order o : orders) {
            System.assertEquals(o.TotalAmount - o.ShipmentCost__c, o.NetAmount__c);
        }
    }

    @isTest
    static void testOnAfterUpdate() {
        List<Account> accounts = DataFactoyTest.createAccounts(1);
        List<Order> orders =[SELECT Id, TotalAmount, AccountId
                              FROM Order 
                              WHERE Id IN :DataFactoyTest.createOrdersForAccounts(accounts, 1, 100, 1)];

       
        Test.startTest();
        OrderTriggerHandler.onAfterUpdate(orders);
        Test.stopTest();
     Set<Id> accountIds = new Set<Id>();
        
       for (Order order : Orders) {
        if (order.AccountId != null) {
        accountIds.add(order.AccountId);
    }

Map<Id, Account> accountsMap = new Map<Id, Account>([SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN :accountIds]);
        
            System.assertEquals(accountsMap.get(order.AccountId).Chiffre_d_affaire__c, order.TotalAmount);
        }
    }
}