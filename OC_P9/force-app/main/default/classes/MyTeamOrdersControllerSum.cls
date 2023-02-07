public  class MyTeamOrdersControllerSum{
    public decimal sumOrders {
           // requête pour récupérer la somme de TotalAmount de toutes les commandes activées
           get {
               AggregateResult groupedResults = [SELECT SUM(TotalAmount) total FROM Order WHERE Status = 'Ordered'];
               // On convertit le résultat en décimal et on le retourne
               return (decimal)groupedResults.get('total');
           }
           set;
       }
   }