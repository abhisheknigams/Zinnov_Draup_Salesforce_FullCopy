public class DraupConvertLead {

    public static void getLeadAccountDetails(list<Lead> NewLeads,List<Lead> OldLeads){
           //system.debug('***NewLeads**'+NewLeads+'***OldLeads****'+OldLeads);
            boolean isNewAccount = false;
            Account acc ;
            String recordId = NewLeads[0].id;
            // checking for Is lead conversion done and is Lead linked with Draup
            if (OldLeads[0].isConverted == false && NewLeads[0].isConverted == true && NewLeads[0].draupApp__Draup_Id__c != null) {
                
                // If an account created
                if (NewLeads[0].ConvertedAccountId != null && (NewLeads[0].draupApp__AccDraupId__c != '' || NewLeads[0].draupApp__AccDraupId__c !=null)) {
                    
                    // Update the converted account with AccDraupId from the lead,when there is no manual Draup Link before.
                    
                    acc = [Select a.Id, a.draupApp__Draup_Id__c, a.CreatedDate From Account a Where a.Id = :NewLeads[0].ConvertedAccountId];
                    //system.debug('account created Date:' + acc.CreatedDate );
                    //system.debug('Lead Converted/Modified Date:' + NewLeads[0].LastModifiedDate);
                    
                    DateTime createdDate=acc.CreatedDate;
                   	createdDate= DateTime.newInstance(createdDate.Year(),createdDate.Month() , createdDate.Day(), createdDate.hour(), createdDate.minute(),0);
                    
                    DateTime lastModifiedDate=NewLeads[0].LastModifiedDate;
                    lastModifiedDate =DateTime.newInstance(lastModifiedDate.Year(),lastModifiedDate.Month() , lastModifiedDate.Day(), lastModifiedDate.hour(), lastModifiedDate.minute(),0);
                   	system.debug(' Account created Date:' + createdDate );
                    system.debug(' Account Last Modified Date:' + lastModifiedDate);
                    // checking Lead lastmodified datetime and Account created datetime are equal, then copy lead AccDraupId to Account's DraupId
                    if((acc.draupApp__Draup_Id__c == '' || acc.draupApp__Draup_Id__c == null) && createdDate == lastModifiedDate){
                        //system.debug('account created Date:' + acc.CreatedDate );
                        //system.debug('Lead Converted/Modified Date:' + NewLeads[0].LastModifiedDate);
                        
                        acc.draupApp__Draup_Id__c = NewLeads[0].draupApp__AccDraupId__c;
                        acc.draupApp__Draup_Account_Name__c = NewLeads[0].draupApp__draupAccName__c;
                        isNewAccount = true;
                        //Future call to insert drop Universe info on new converted account
                       // ConvertedDraupAccount.insertUniverseData(a.Id, a.Draup_Id__c);
    
                    }
                    
                }          
                
                // If a new contact was created
                if (NewLeads[0].ConvertedContactId != null && NewLeads[0].ConvertedAccountId != null && (NewLeads[0].draupApp__Draup_Id__c != '' || NewLeads[0].draupApp__Draup_Id__c !=null)) {
                    
                    // Update the converted contact with Draup_Id from the lead,,when there is no manual Draup Link before.
                    Contact c = [Select c.Id, c.draupApp__Draup_Id__c, c.AccountId,c.Account.CreatedDate, c.CreatedDate From Contact c Where c.Id = :NewLeads[0].ConvertedContactId];
                    //system.debug('Contact created Date:' + c.CreatedDate );
                    //system.debug('Lead Converted/Modified Date:' + NewLeads[0].LastModifiedDate );
                    
                    DateTime createdDate=c.CreatedDate;
                   	createdDate= DateTime.newInstance(createdDate.Year(),createdDate.Month() , createdDate.Day(), createdDate.hour(), createdDate.minute(),0);
                    
                    DateTime accountCreatedDate= c.Account.CreatedDate;
                    accountCreatedDate=DateTime.newInstance(accountCreatedDate.Year(),accountCreatedDate.Month() , accountCreatedDate.Day(), accountCreatedDate.hour(), accountCreatedDate.minute(),0);
                    
                    DateTime lastModifiedDate=NewLeads[0].LastModifiedDate;
                    lastModifiedDate =DateTime.newInstance(lastModifiedDate.Year(),lastModifiedDate.Month() , lastModifiedDate.Day(), lastModifiedDate.hour(), lastModifiedDate.minute(),0);
                   	
                    system.debug('Contact created Date:' + createdDate );
                    system.debug('Account created Date:' + accountCreatedDate );
                    system.debug('Contact Last Modified Date:' + lastModifiedDate);
                    // checking Lead lastmodified datetime and Contact created datetime are equal, then copy lead DraupId to Contact's DraupId
                     if((c.draupApp__Draup_Id__c == '' || c.draupApp__Draup_Id__c == null) && (createdDate == lastModifiedDate) && (accountCreatedDate == lastModifiedDate) && (c.AccountId == NewLeads[0].ConvertedAccountId) && isNewAccount) {
                        c.draupApp__Draup_Id__c = NewLeads[0].draupApp__Draup_Id__c;
                        String draupId = c.draupApp__Draup_Id__c;
                        System.debug(' draupId '+ draupId);
                       //Future call to insert drop Universe info on new converted account and new Contact 
                        ConvertedDraupAccount.insertUniverseData(acc.Id, acc.draupApp__Draup_Id__c,acc.draupApp__Draup_Account_Name__c);
						ConvertedDraupAccount.insertRolodexData(c.Id, draupId);
                         
                    }
                    
                }   
            }
    }
}