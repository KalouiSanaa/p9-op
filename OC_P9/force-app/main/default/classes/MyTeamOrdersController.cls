public without sharing class MyTeamOrdersController {

    // propriété pour stocker la somme de toutes les commandes activées
    public decimal sumOrders {
        // requête pour récupérer la somme de TotalAmount de toutes les commandes activées
        get {
            AggregateResult groupedResults = [SELECT SUM(TotalAmount) total FROM Order WHERE Status = 'Activated'];
            // On convertit le résultat en décimal et on le retourne
            return (decimal)groupedResults.get('total');
        }
        set;
    }
}