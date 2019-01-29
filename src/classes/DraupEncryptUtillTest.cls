@istest
public class DraupEncryptUtillTest {
    
   static testMethod void testDraupEncryptUtill() {
       
       DraupCryptoKey__c key = new DraupCryptoKey__c();
       key.name = 'Key';
       key.Key__c = 'hjshkashfalskdjfhirutowirutyurie';
       insert key;
       System.assertEquals(key.name, 'Key');
       DraupEncryptUtil.getCryptoKey();
       
   }

}