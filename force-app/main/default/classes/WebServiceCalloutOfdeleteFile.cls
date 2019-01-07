@isTest
global class WebServiceCalloutOfdeleteFile  implements WebServiceMock{
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
                   wwwTechnomileconnectCom.SP_DeleteFileResponse_element respElement = new wwwTechnomileconnectCom.SP_DeleteFileResponse_element ();
                   respElement.SP_DeleteFileResult='Account/test/test1.1';
                   System.assertNotEquals(Null,respElement);
                   response.put('response_x', respElement); 
            }
}