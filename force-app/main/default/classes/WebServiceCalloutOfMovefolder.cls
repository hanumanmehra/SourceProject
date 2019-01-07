@isTest
global class WebServiceCalloutOfMovefolder  implements WebServiceMock{
	global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) 
	{
    	wwwTechnomileconnectCom.SP_MoveFolderResponse_element respElement = 
        new wwwTechnomileconnectCom.SP_MoveFolderResponse_element ();
        respElement.SP_MoveFolderResult=True;
        System.assertNotEquals(Null,respElement);
        response.put('response_x', respElement); 
    }
}