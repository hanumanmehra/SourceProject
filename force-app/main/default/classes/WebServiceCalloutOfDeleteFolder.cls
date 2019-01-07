@isTest
global class WebServiceCalloutOfDeleteFolder  implements WebServiceMock{
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
       wwwTechnomileconnectCom.SP_DeleteFolderResponse_element respElement = 
           new wwwTechnomileconnectCom.SP_DeleteFolderResponse_element ();
       respElement.SP_DeleteFolderResult=True;
       System.assertNotEquals(Null,respElement);
       response.put('response_x', respElement); 
}

}