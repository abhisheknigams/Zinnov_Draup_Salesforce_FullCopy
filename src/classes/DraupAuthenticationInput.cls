/**************************************************************************************************************
*   @author         Persistent Systems
*   @date           28/10/2018
*   @description    This class is used for Stroring and displaying client details entered by user in vf page
***************************************************************************************************************/
public with sharing class DraupAuthenticationInput {
    public string clientId{get;set;}
    public string clientSecret{get;set;}
    public string superUserProfiles {get;set;}
    public Boolean status{get;set;}
    public Boolean authExists{get;set;}
    public Integer selectedSyncHour{get;set;}
    
    /*************************************************************************************************************
* @description Constructor to display user details if already stored in custom setting
* @author      Persistent Systems
* @param       -
* @date        28/10/2018
* @return      None
**************************************************************************************************************/
    
    public DraupAuthenticationInput()
    {   
        try{
            clientAuthDetails__c clntAuthDetails = clientAuthDetails__c.getValues('Auth');
            System.debug(' clntAuthDetails '+ clntAuthDetails);
            
            if(clntAuthDetails != null/* && clntAuthDetails.draupApp__clientId__c != null && clntAuthDetails.draupApp__clientSecret__c != null*/) 
            {
                authExists = true;
                clientId = (clntAuthDetails.draupApp__clientId__c != null) ?clntAuthDetails.draupApp__clientId__c : null;
                clientSecret = (clntAuthDetails.draupApp__clientSecret__c != null)?clntAuthDetails.draupApp__clientSecret__c: null ;
                superUserProfiles = (clntAuthDetails.draupApp__SuperUserProfile__c !=null)?clntAuthDetails.draupApp__SuperUserProfile__c:null;
                selectedSyncHour = (clntAuthDetails.draupApp__SyncHour__c !=null)?Integer.valueof(clntAuthDetails.draupApp__SyncHour__c):null;
            }
        }
        catch(exception ex)
        {
            System.debug('Message '+ ex.getMessage()+'line number '+ex.getLineNumber());
            ExceptionHandler.logApexError('DraupAuthenticationInput', 'DraupAuthenticationInput', String.valueOf(ex.getLineNumber()) , ex.getStackTraceString());
        }
        
    }
    
    /*************************************************************************************************************
* @description Method to insert or Update Client details enterd by User
* @author      Persistent Systems
* @param       -
* @date        28/10/2018
* @return      None
**************************************************************************************************************/
    public void insertClientDetails()
    {
        //boolean clientAuthDetailsvalid = Utility.isCreateable(getClientAuthDetailsList(),'draupApp__ClientAuthDetails__c');
       // Boolean clientAuthDetailsAccessible = Utility.isAccessible(getClientAuthDetailsList(),'draupApp__ClientAuthDetails__c');
        //Boolean clientAuthDetailsUpdatable = Schema.sObjectType.draupApp__ClientAuthDetails__c.fields.Name.isUpdateable() && Schema.sObjectType.draupApp__ClientAuthDetails__c.fields.draupApp__clientId__c.isUpdateable() && Schema.sObjectType.draupApp__ClientAuthDetails__c.fields.draupApp__clientSecret__c.isUpdateable() && Schema.sObjectType.draupApp__ClientAuthDetails__c.fields.draupApp__SuperUserProfile__c.isUpdateable() && Schema.sObjectType.draupApp__ClientAuthDetails__c.fields.draupApp__SyncHour__c.isUpdateable();
        LIst<clientAuthDetails__c> lClntAuth  = new LIst<clientAuthDetails__c>();
        try{
            if( Schema.sObjectType.draupApp__clientAuthDetails__c.fields.name.isAccessible()== true)
            {
                lClntAuth = [Select id,name from clientAuthDetails__c where Name ='Auth' limit 1];
            }
            clientAuthDetails__c oClntAuth = new clientAuthDetails__c();
            if(lClntAuth != null && lClntAuth.size()>0 && Schema.sObjectType.draupApp__clientAuthDetails__c.fields.draupApp__clientId__c.isUpdateable() == true && 
               Schema.sObjectType.draupApp__clientAuthDetails__c.fields.draupApp__clientSecret__c.isUpdateable() == true &&
               Schema.sObjectType.draupApp__clientAuthDetails__c.fields.draupApp__SuperUserProfile__c.isUpdateable() == true &&
               Schema.sObjectType.draupApp__clientAuthDetails__c.fields.draupApp__SyncHour__c.isUpdateable() == true ) 
            {
                oClntAuth.id=lClntAuth.get(0).id;
                oClntAuth.draupApp__clientId__c = clientId.trim();
                oClntAuth.draupApp__clientSecret__c=clientSecret.trim();
                oClntAuth.draupApp__SuperUserProfile__c = superUserProfiles.trim();
                oClntAuth.draupApp__SyncHour__c = String.valueOf(selectedSyncHour);
                Database.update(oClntAuth);
                status = true;
            }    
            else 
            {
                if(Schema.sObjectType.draupApp__clientAuthDetails__c.fields.Name.isCreateable() == true && 
                   Schema.sObjectType.draupApp__clientAuthDetails__c.fields.draupApp__clientId__c.isCreateable() == true && 
                   Schema.sObjectType.draupApp__clientAuthDetails__c.fields.draupApp__clientSecret__c.isCreateable() == true &&
                   Schema.sObjectType.draupApp__clientAuthDetails__c.fields.draupApp__SuperUserProfile__c.isCreateable() == true &&
                   Schema.sObjectType.draupApp__clientAuthDetails__c.fields.draupApp__SyncHour__c.isCreateable() == true  )
                {
                    oClntAuth.Name = 'Auth';
                    oClntAuth.draupApp__clientId__c = clientId;
                    oClntAuth.draupApp__clientSecret__c=clientSecret;
                    oClntAuth.draupApp__SuperUserProfile__c = superUserProfiles.trim();
                    oClntAuth.draupApp__SyncHour__c = String.valueOf(selectedSyncHour);
                    Database.insert(oClntAuth); 
                    status = true;
                }
            }
        }
        catch(Exception ex)
        {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, ex.getMessage());
            ApexPages.addMessage(msg);
            System.debug('Message '+ ex.getMessage()+'line number '+ex.getLineNumber());
            ExceptionHandler.logApexError('DraupAuthenticationInput', 'insertClientDetails', String.valueOf(ex.getLineNumber()) , ex.getStackTraceString());
        }
    }
    public static List<String> getClientAuthDetailsList()
    {
        Map<String, Schema.SObjectField> schemaFieldMap = Schema.SObjectType.draupApp__ClientAuthDetails__c.fields.getMap();
        List<String> fieldList = new List<String>();
        for(String field :schemaFieldMap.keyset()){
            if(field.contains('__c'))
                fieldList.add(field);
        }
        return fieldList;
    }
    
}