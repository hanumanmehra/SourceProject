@isTest
global class WebServiceCalloutOfReNameFolder  implements WebServiceMock{
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
       wwwTechnomileconnectCom.SP_RenameFolderResponse_element respElement = 
           new wwwTechnomileconnectCom.SP_RenameFolderResponse_element ();
       respElement.SP_RenameFolderResult=True;
       System.assertNotEquals(Null,respElement);
       response.put('response_x', respElement); 
	}

}