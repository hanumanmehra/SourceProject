global with sharing class WarehouseUtilsNew {
public WarehouseUtilsNew(ApexPages.StandardSetController controller) { }
// findNearbyWarehouses method goes here
// Find warehouses nearest a geolocation
@RemoteAction
global static List<Merchandise__c> findNearbyWarehouses(String lat, String lon) {
// Initialize results to an empty list
List<Merchandise__c> results = new List<Merchandise__c>();
// SOQL query to get the nearest warehouses
String queryString =
'SELECT Id, Name, Location__Longitude__s, Location__Latitude__s, ' +
'Street_Address__c, Phone__c, City__c ' +
'FROM Warehouse__c ' +
'WHERE DISTANCE(Location__c, GEOLOCATION('+lat+','+lon+'), \'mi\') < 20 ' +
'ORDER BY DISTANCE(Location__c, GEOLOCATION('+lat+','+lon+'), \'mi\') ' +
'LIMIT 10';
// Run the query
results = database.Query(queryString);
return(results);
}

}