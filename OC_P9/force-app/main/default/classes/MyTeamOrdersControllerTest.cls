@isTest
public class MyTeamOrdersControllerTest {
    // Test pour vérifier la somme des commandes de type "Activé"
@isTest
 static void testSumOrders() {   
    Test.startTest();
    // Insérer des données de test en créant 4 comptes et 4 commandes par compte
    List<Account> accs= DataFactoyTest.createAccounts(4);
    List<Order> ords = DataFactoyTest.createOrdersForAccounts(accs,4,200, 1);

    // Calculer le total attendu en multipliant le nombre de commandes par le prix unitaire
    decimal expectedT = ords.size() * 200;

// Obtenir la somme des commandes avec le statut "Activé" en utilisant le résultat agrégé
List<AggregateResult> results = [SELECT SUM(TotalAmount) total FROM Order WHERE Id IN :ords GROUP BY Status];
  
    decimal totalOrders = (decimal)results[0].get('total');

// Confirmer si le total attendu est égal à la somme calculée des commandes
System.assertEquals(expectedT,totalOrders,'the sum is ');
    Test.stopTest();
}

@isTest
    static void testSumOrdersWithoutOrders() {
        Test.startTest();

        // Crée 4 comptes et 0 commandes
        List<Account> accs= DataFactoyTest.createAccounts(4);
        List<Order> orders =DataFactoyTest.createOrdersForAccounts(accs, 0, 0, 0);

        // Calcule la somme attendue des commandes
        decimal expectedT = null;

        // Vérifie que la somme des commandes est correcte
        List<AggregateResult> resultsT = [SELECT SUM(TotalAmount) total FROM Order WHERE Id IN :orders];
        decimal totalOrders = (decimal)resultsT[0].get('total');
        System.assertEquals(expectedT,totalOrders,'the expecting is null');

        Test.stopTest();
    }

}