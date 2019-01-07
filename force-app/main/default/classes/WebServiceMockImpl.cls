@isTest
global class WebServiceMockImpl implements WebServiceMock {
   global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
         
            wwwTechnomileconnectCom.GetDataUsingDataContractResponse_element  respElement= new wwwTechnomileconnectCom.GetDataUsingDataContractResponse_element ();
            schemasDatacontractOrg200407Wcfsfsp.CompositeType Test  = New schemasDatacontractOrg200407Wcfsfsp.CompositeType() ;  
            respElement.GetDataUsingDataContractResult =Test;
            respElement.GetDataUsingDataContractResult=New schemasDatacontractOrg200407Wcfsfsp.CompositeType();
            System.assertNotEquals(Null,respElement);
            response.put('response_x', respElement); 
            System.assertNotEquals(Null,response);
   	}
   }