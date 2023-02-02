public with sharing class DataFactoyTest {

    
       public static List<Account> createAccounts(Integer nbAccount) {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < nbAccount; i++) {
            accounts.add(createAccount('Test Account ' + i));
        }
        return accounts;
    }

    public static Account createAccount(String name) {
        Account account = new Account(Name = name);
        insert account;
        return account;
    }
    public static List<Order> createOrdersForAccounts(List<Account> accs, Integer nbOr, Integer unitPrice, Integer quantity) {
        List<Contract> contrct = new List<Contract>();
        List<Order> orders = new List<Order>();
        for(Account acc : accs) {
            Contract cont = new Contract(
                AccountId=acc.Id, 
                Status='Draft',
                ContractTerm=5
            );
contrct.add(cont);
            for(Integer i = 0; i < nbOr; i++) {
                Order o = new Order();
                o.AccountId = acc.Id;
                    o.ContractId=cont.id;
                    o.Status='Draft';
                    o.EffectiveDate=Date.today();
                    o.Pricebook2Id=Test.getStandardPricebookId();
                o.UnitPrice__c = unitPrice;
                o.Quantity__c = quantity;
                orders.add(o);
            }
        }
        insert orders;
        insert contrct;
       
    
    Product2 p= new Product2(Name = 'Chemise Verte longue XYX', Family = 'Chemise');
        insert p;
    //Create the PricebookEntry
    PricebookEntry pbe = new PricebookEntry(
        Pricebook2Id = Test.getStandardPricebookId(),
        Product2Id = p.Id,
        UnitPrice = unitPrice,
        IsActive = true
    );
    Insert pbe;   
    List<OrderItem> oi = new List<OrderItem>();
    for (Order o : orders) {
        OrderItem oit=new OrderItem();
        oit.OrderId = o.Id;
        oit.PricebookEntryId = pbe.Id;
        oit.Quantity=quantity;
        oit.unitPrice=unitPrice;
        oi.add(oit);
}
insert oi;
return orders;
}

}