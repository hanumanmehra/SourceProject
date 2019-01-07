public class Csvcontroller {

    public String a { get; set; }

    public String Account { get; set; }
    public List<Account> getcsvrecord() {
        return [select id,Name,billingState,Type From Account limit 10];
    }
}