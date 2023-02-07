@isTest
public class MyTeamOrdersControllerSumTest {
    // Test pour vérifier la somme des commandes de type "Activé"
@isTest
 static void testSumOrders() {   
    Test.startTest();
    // Insérer des données de test en créant 4 comptes et 4 commandes par compte
    List<Account> accs= DataFactoyTest.createAccounts(4);
    List<Order> ords = DataFactoyTest.createOrdersForAccounts(accs,4,200,1);

    // Calculer le total attendu en multipliant le nombre de commandes par le prix unitaire
   
  
     for(Order order : ords) {
            order.Status = 'Ordered'; 
        }

        update ords;
     
MyTeamOrdersControllerSum tmcontrol=new MyTeamOrdersControllerSum();
 decimal expectedT = 16*200;
 // Confirmer si le total attendu est égal à la somme calculée des commandes
System.assertEquals(expectedT,tmcontrol.sumOrders);
    Test.stopTest();
}

@isTest
    static void testSumOrdersWithoutOrders() {
        Test.startTest();

        // Crée 4 comptes et 4cmmandes
        List<Account> accs= DataFactoyTest.createAccounts(4);
        List<Order> ords =DataFactoyTest.createOrdersForAccounts(accs,4,200,1);

        // Calcule la somme attendue des commandes
        update ords;
        
     
MyTeamOrdersControllerSum tmcontrol=new MyTeamOrdersControllerSum();
 decimal expectedT = null;
        // Confirmer si le total attendu est égal à la somme calculée des commandes
System.assertEquals(expectedT,tmcontrol.sumOrders);
    Test.stopTest();
}
    }