@isTest
global class technomileComServiceMockupcls implements WebServiceMock
{
    global void doInvoke(
    Object stub,
    Object request,
    map<String,Object> response,
    String endpoint,
    String soapAction,
    String requestName,
    String responseNs,
    String responseName,
    String responseType
    )
    
    
    {
        wwwTechnomileconnectCom.GetDataUsingDataContractResponse_element respElement = new wwwTechnomileconnectCom.GetDataUsingDataContractResponse_element ();
        System.assertNotEquals(Null,respElement);
        response.put('response_x', respElement);
         
    }
    
}