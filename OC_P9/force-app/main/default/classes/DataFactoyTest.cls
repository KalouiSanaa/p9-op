/**
 * Cette classe est responsable de la création des données de test pour l'application.
 * Il inclut des méthodes de création d'enregistrements "Compte" et "Commande" à des fins de test.
 * De plus, il crée les enregistrements `Product` et `PricebookEntry` requis pour créer un enregistrement `Order`.
 *
 * @author [kaloui sanaa]
 *
 */

public with sharing class DataFactoyTest {

    // Cette méthode crée une liste de comptes.
       public static List<Account> createAccounts(Integer nbAccount) {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < nbAccount; i++) {

            // Les comptes sont créés en appelant la méthode createAccount et en lui passant le nom 'Test Account ' + i.
            accounts.add(createAccount('Test Account ' + i));
        }

        // The method returns the list of created accounts
        return accounts;
    }

// Cette méthode crée un compte et l'insère dans la base de données.
    public static Account createAccount(String name) {
        // Il prend un argument de chaîne 'name' qui représente le nom du compte à créer.
        Account account = new Account(Name = name);
        insert account;
        return account;
    }

    // Cette méthode crée des commandes pour une liste de comptes.
    public static List<Order> createOrdersForAccounts(List<Account> accs, Integer nbOr, Integer unitPrice, Integer quantity) {
       
        // crée une liste de contrats, les insère dans la base de données et associe chaque contrat à un compte.
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
       
    //crée un produit. 
    Product2 p= new Product2(Name = 'Chemise Verte longue XYX', Family = 'Chemise');
        insert p;

    //Creer PricebookEntry
    PricebookEntry pbe = new PricebookEntry(
        Pricebook2Id = Test.getStandardPricebookId(),
        Product2Id = p.Id,
        UnitPrice = unitPrice,
        IsActive = true
    );
    Insert pbe;
    //crée une liste d'articles de commande,    
    List<OrderItem> oi = new List<OrderItem>();

    //associe chaque article de commande à une commande
    for (Order o : orders) {
        OrderItem oit=new OrderItem();
        oit.OrderId = o.Id;
        oit.PricebookEntryId = pbe.Id;
        oit.Quantity=quantity;
        oit.unitPrice=unitPrice;
        oi.add(oit);
}
//insère les articles de commande dans la base de données.
insert oi;

//renvoie la liste des commandes créées.
return orders;
}

}