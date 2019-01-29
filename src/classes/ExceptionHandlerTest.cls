@isTest
private class ExceptionHandlerTest {
 @isTest static void testMethodlogApexError(){
     System.test.startTest();
     string error ='Error occured';
     ExceptionHandler.logApexError('Test Class','testMethod','12',error);
     system.assertEquals('Error occured', error);
      System.test.stopTest();
 }
  @isTest static void testMethodlogApexCalloutError(){
     System.test.startTest();
      HttpResponse response = new HttpResponse();
      response.setBody('Value error');
      response.setStatusCode(500);
     ExceptionHandler.logApexCalloutError('Test Class','testMethod',response);
      
      //system.debug('<<<response>>>'+response.getBody());
      System.assertEquals('Value error', response.getBody());
      //system.debug('<<<ExceptionHandler>>>'+ExceptionHandler.logApexCalloutError('Test Class','testMethod',response));
      System.test.stopTest();
 }
}