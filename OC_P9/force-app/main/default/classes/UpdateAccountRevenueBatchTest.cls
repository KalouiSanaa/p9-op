@isTest
public class UpdateAccountRevenueBatchTest {
 private static Integer numOfAccounts =4;
  private static Integer numOfOrders = 10;
  private static Integer orderAmount = 100;
    @isTest
    static void testUpdateAccountRevenueBatch() {
// Insérer les données de test
        List<Account> accounts = DataFactoyTest.createAccounts(numOfAccounts);
       
        List<Order> orders = DataFactoyTest.createOrdersForAccounts(accounts, numOfOrders, orderAmount, 1);
     


     // Met à jour la liste de commandes pour déclencher le trigger
        Test.startTest();
UpdateAccountRevenueBatch batch = new UpdateAccountRevenueBatch();
        Database.executeBatch(batch);
        Test.stopTest();
        // Vérifie que le nombre de commandes créées est égal à 40
        System.assertEquals(orders.size(), 40);
      
    
    }
 @isTest
    static void testUpdateAccountRevenueBatchWithNoOrder() {
// Tester le cas limite : pas de commandes
       
        List<Account>  accounts = DataFactoyTest.createAccounts(numOfAccounts);
       List<Order> orders = DataFactoyTest.createOrdersForAccounts(accounts, 0, 0, 0);
        // Met à jour la liste de commandes pour déclencher le trigger
       // Met à jour la liste de commandes pour déclencher le trigger
        Test.startTest();
UpdateAccountRevenueBatch batch = new UpdateAccountRevenueBatch();
        Database.executeBatch(batch);
        Test.stopTest();

        // Vérifie que le nombre de commandes créées est égal à 0
        System.assertEquals(orders.size(),0);
        List<Id> accountIds = new List<Id>();
for (Account acc : accounts) {
    accountIds.add(acc.Id);
}
List<Account> updatedAccounts = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN :accountIds];
        for (Account acc : updatedAccounts) {
      System.assertEquals(acc.Chiffre_d_affaire__c, 0);
        
        }
    }
    
}