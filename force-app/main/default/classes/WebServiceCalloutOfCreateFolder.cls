@isTest
global class WebServiceCalloutOfCreateFolder  implements WebServiceMock{
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
    	wwwTechnomileconnectCom.SP_CreateFolderResponse_element respElement = new wwwTechnomileconnectCom.SP_CreateFolderResponse_element ();
        respElement.SP_CreateFolderResult=true;
        System.assertNotEquals(Null,respElement);
       	response.put('response_x', respElement); 
    }
}