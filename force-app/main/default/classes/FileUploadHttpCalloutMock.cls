@isTest
global class FileUploadHttpCalloutMock implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        String str='<string xmlns="http://schemas.microsoft.com/2003/10/Serialization/">'+
    '{{{C:'+'RESTUploadFile'+'5b10c093-c629-47e7-bd4e-5433c5188718}}}'+'</string>';

        response.setBody(str);
        response.setStatusCode(200);
        return response; 
    }
}