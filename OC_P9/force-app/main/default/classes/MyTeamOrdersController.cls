public without sharing class MyTeamOrdersController {

    public decimal sumOrders {
        get{
			AggregateResult groupedResults = [SELECT SUM(TotalAmount) total FROM Order WHERE Status = 'Activated'];
			return (decimal)groupedResults.get('total');

        }
        set;
    }
}