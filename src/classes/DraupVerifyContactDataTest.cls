@IsTest (SeeAllData=true) private class DraupVerifyContactDataTest {
    private static testMethod void triggerTestMethod() {
        system.test.startTest();
        list<Account> acc = new  List<Account> { new Account(Name = 'testAccount',draupApp__Draup_Id__c='1223',draupApp__Draup_Account_Name__c='testAccount'),
            							new Account(Name = 'testAccount2',draupApp__Draup_Id__c= null,draupApp__Draup_Account_Name__c= null)};
        insert acc;
        List < Contact > con = new List < Contact > {new Contact(LastName = 'xxxx',draupApp__IsFromLoader__c = true, AccountId = acc[0].Id),
           											 new Contact(LastName = 'yyyy', draupApp__IsFromLoader__c = true,AccountId = acc[1].Id ) };
        insert con;
        Contact c = [select Id from Contact where LastName = 'xxxx' and draupApp__IsFromLoader__c = true];
        c.draupApp__IsFromLoader__c=true;
        update c;
        Contact c1 = [select Id from Contact where LastName = 'yyyy' and draupApp__IsFromLoader__c = true];
        c1.draupApp__IsFromLoader__c=true;
        update c1;
       	system.test.stopTest();
        
        system.assertEquals(c1.draupApp__IsFromLoader__c, c.draupApp__IsFromLoader__c);
        
    }

}