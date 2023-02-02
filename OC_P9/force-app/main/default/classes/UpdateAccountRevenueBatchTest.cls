@isTest
public class UpdateAccountRevenueBatchTest {
    static void testUpdateAccountRevenueBatch() {
        // Create test data
            List<Account> accounts = DataFactory.createAccounts(5);
           

        Test.startTest();
        System.assertEquals(5, accounts.size());
        UpdateAccountRevenueBatch batch = new UpdateAccountRevenueBatch();
        Id batchId = Database.executeBatch(batch, 2);
        Test.stopTest();

        // Verify that the batch job has been executed
        System.assertEquals(2, [SELECT COUNT() FROM AsyncApexJob WHERE Id = :batchId][0].get('expr0'));
        // Verify that the revenue of the accounts has been increased by 10%
        System.assertEquals(1100, [SELECT Revenue__c FROM Account WHERE Id = :testAccount1.Id][0].Revenue__c);
        System.assertEquals(2200, [SELECT Revenue__c FROM Account WHERE Id = :testAccount2.Id][0].Revenue__c);
    }
}
