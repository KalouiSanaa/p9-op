public  with sharing class OrderTriggerHandler {
    public static void handleOrderUpdates(List<Order> orders) {
        // Get the list of Accounts that the Orders are associated with
        Set<Id> accountIds = new Set<Id>();
        for (Order o : orders) {
            accountIds.add(o.AccountId);
        }
        Map<Id, Account> accounts = new Map<Id, Account>([SELECT Id, (SELECT Id FROM Orders) FROM Account WHERE Id IN :accountIds]);
        
        // Create a list to store the Orders that will be updated
        List<Order> ordersToUpdate = new List<Order>();
        
        // Iterate over the list of Orders that are being updated
        for (Order o : orders) {
            // Check if the associated Account has more than 100 Orders
            if (accounts.get(o.AccountId).Orders.size() > 200) {
                // Add an error to the Order to prevent it from being updated
                o.addError('Cannot update Order on account with more than 200 Orders');
            } else {
                // Calculate the Net Amount
                o.NetAmount__c = o.TotalAmount -o.ShipmentCost__c;
                // Add the Order to the list of Orders to be updated
                ordersToUpdate.add(o);
            }
        }
        
        // Update the Orders in the database
        update ordersToUpdate;
    }
     public static void updateRevenueOnOrderStatusChange(List<Order> newOrders, List<Order> oldOrders) {
        Map<Id, Account> accountMap = new Map<Id, Account>();
        for (Integer i = 0; i < newOrders.size(); i++) {
            Order newOrder = newOrders[i];
            Order oldOrder = oldOrders[i];
            if (newOrder.Status == 'Ordered' && newOrder.AccountId != null && newOrder.AccountId != oldOrder.AccountId) {
                if (!accountMap.containsKey(newOrder.AccountId)) {
                    accountMap.put(newOrder.AccountId, new Account(Id = newOrder.AccountId));
                }
                accountMap.get(newOrder.AccountId).AnnualRevenue += newOrder.TotalAmount;
            }
        }
        update accountMap.values();
    }
    }