@isTest
private class Draup_PostInstallScriptTest {
    static testMethod void installTest()
    {
        CryptoKeys__c oCryptoKeys = new CryptoKeys__c();
        oCryptoKeys.Name = 'Key';
        oCryptoKeys.Key__c='owCTawa3WifoDW4WjIJXLQ==';
        insert oCryptoKeys;
        system.assert(oCryptoKeys != null);
        clientAuthDetails__c oAuth = new clientAuthDetails__c();
        oAuth.Name = 'Auth';
        oAuth.draupApp__clientId__c= 'dfhaklfahglkajglkjg';
        oAuth.draupApp__clientSecret__c='agajgkajglkajglajg';
        insert oAuth;
        system.assert(oAuth != null);
        DraupEndPoints__c recObj;
        recObj = new DraupEndPoints__c();
        recObj.Name = 'DraupAuth';
        recObj.End_Point_Url__c = 'https://qa-platform.draup.com/service/client/token/';
        
        Draup_PostInstallScript postinstall = new Draup_PostInstallScript();
        Test.testInstall(postinstall, new Version(1, 0), true);
    }
}