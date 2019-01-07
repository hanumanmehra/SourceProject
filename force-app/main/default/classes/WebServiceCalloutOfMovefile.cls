@isTest
global class WebServiceCalloutOfMovefile implements WebServiceMock{
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
                wwwTechnomileconnectCom.SP_MoveFileResponse_element respElement = new wwwTechnomileconnectCom.SP_MoveFileResponse_element ();
                respElement.SP_MoveFileResult='https://technomileusa.sharepoint.com/Shared Documents/Account/Test Hanu 26 apr/Test Hanu 26 apr 2/800px-Pizigani_1367_Chart_10MB image.jpg';
                System.assertNotEquals(Null,respElement);
                response.put('response_x', respElement); 
            }

}