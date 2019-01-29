trigger DraupVerifyContactData on Contact (before update) {
    
    if(Trigger.IsBefore && Trigger.isUpdate)
    {
        list<contact> conlist = new list<contact>();
        
        List<id> accIds = new List<Id>();
        Map<id,Account> accountsList ;
        
        for(Contact c: trigger.new){ 
            if( c.draupApp__IsFromLoader__c == true )
            {
              accIds.add(c.AccountId);
            }
        }
        
        if(accIds.size() > 0){
            
           accountsList = New Map<id,Account>([Select Id,Name,draupApp__Draup_Id__c,draupApp__Draup_Account_Name__c from Account where Id =:accIds]);
            
           if (accountsList.size() > 0){
            
              for(Contact c: trigger.new){ 
                if( c.draupApp__IsFromLoader__c == true )
                {
                    Account acct = accountsList.get(c.accountId);
                    if(acct.draupApp__Draup_Id__c != null && acct.draupApp__Draup_Account_Name__c != null )
                    {
                        c.draupApp__IsFromLoader__c=false;
                    }
                    else
                    {
                       c.draupApp__Draup_Id__c = null;
                       c.draupApp__IsFromLoader__c=false;
                    }
                }
                  
              }
          }
        }
    }
}