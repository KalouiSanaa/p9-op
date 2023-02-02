
    @isTest
public  with sharing class OrderTriggerHandlerTest {
    @isTest
    static void testHandleOrderUpdates() {
        // Create an Account
        Account account = new Account(Name = 'Test Account');
        insert account;
        
        // Create a list of Orders
        List<Order> orders = new List<Order>();
        for (Integer i =0; i < 210; i++) {
            Order order = new Order(AccountId = account.Id,TotalAmount__c = 100, ShipmentCost__c = 10);
            orders.add(order);
        }
        
        // Test that an error is thrown when trying to update an Order on an Account with more than 100 Orders
        Test.startTest();
        try {
            OrderTriggerHandler.handleOrderUpdates(orders);
            System.assert(false, 'Expected an exception to be thrown');
        } catch (DmlException e) {
        System.assertEquals('Cannot update Order on account with more than 200 Orders',e.getDmlMessage(0));
        }
        Test.stopTest();
        
        // Test that the Net Amount is correctly calculated and the Orders are updated
        orders.remove(0);
        Test.startTest();
        OrderTriggerHandler.handleOrderUpdates(orders);
        Test.stopTest();
        for (Order o : orders) {
            System.assertEquals(90,o.NetAmount__c);
        }
    }
    
    static testMethod void testUpdateRevenueOnOrderStatusChange() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Order testOrder = new Order(AccountId = testAccount.Id, Status = 'Draft',TotalAmount__c= 100);
        insert testOrder;

        testOrder.Status = 'Ordered';
        update testOrder;

        testAccount = [SELECT AnnualRevenue FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals(100, testAccount.AnnualRevenue);
    }
}