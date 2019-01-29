/**************************************************************************************************************
*   @author         Persistent Systems
*   @date           20/09/2018
*   @description    This wrapper class is used to parse Account suggestion list response 
***************************************************************************************************************/
public with sharing class DraupUniverseWrapper implements Comparable{
    
    @AuraEnabled public String account_id;
    @AuraEnabled public String account_name;
    @AuraEnabled public boolean isSelected =false;
    @AuraEnabled public boolean direct_match;
    @AuraEnabled public String lastModDate;
    @AuraEnabled public Map<string,List<Map<string,string>>> draupDetailMap;
  
    
    public static List<DraupUniverseWrapper> parse(String json) {
        return (List<DraupUniverseWrapper>) System.JSON.deserialize(json, List<DraupUniverseWrapper>.class);
    }
    
    public DraupChild__c draupChild;
   
    public DraupUniverseWrapper(){
        
    }
     // Constructor
    public DraupUniverseWrapper(DraupChild__c dc) {
        draupChild = dc;
    }
    
      // Compare Draup Child based on the order .
    public Integer compareTo(Object compareTo) {
        // Cast argument to OpportunityWrapper
        DraupUniverseWrapper compareToDc = (DraupUniverseWrapper)compareTo;
        
        // The return value of 0 indicates that both elements are equal.
        Integer returnValue = 0;
        if (draupChild.expOrder__c > compareToDc.draupChild.expOrder__c) {
            // Set return value to a positive value.
            returnValue = 1;
        } else if (draupChild.expOrder__c < compareToDc.draupChild.expOrder__c) {
            // Set return value to a negative value.
            returnValue = -1;
        }
        
        return returnValue;       
    }
    
    
}