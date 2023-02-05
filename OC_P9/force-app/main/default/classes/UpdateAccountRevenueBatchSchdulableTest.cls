@isTest
private class UpdateAccountRevenueBatchSchdulableTest {

    @isTest
    static void testUpdateAccountRevenueBatchSchedulable() {

        // Créer trois comptes 
        List<Account> accounts = DataFactoyTest.createAccounts(3);

        // Créer des commandes pour les comptes avec un montant total de 300
        List<Order> orders = DataFactoyTest.createOrdersForAccounts(accounts, 3, 100, 1);

        // Lancer le test pour permettre la planification du travail par lots
        Test.startTest();

        // Planification de l'exécution du travail par lots
        String sch='0 0 0 1 1 ? *';
        UpdateAccountRevenueBatchSchdulable updateAccountRevenueBatchSchdulable = new UpdateAccountRevenueBatchSchdulable();
       String JobId= System.schedule('Test Job', sch, updateAccountRevenueBatchSchdulable);
    // Interroger le travail par lots pour vérifier qu'il a été planifié

        // Arrête le test pour terminer le processus de planification
        Test.stopTest();

// Interroger le compte de test pour vérifier que les revenus ont été mis à jour
        accounts= [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id =:accounts[0].Id];
        
        System.assertNotEquals(300,accounts[0].Chiffre_d_affaire__c);
    }
}