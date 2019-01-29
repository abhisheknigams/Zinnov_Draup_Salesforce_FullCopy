public with sharing class Utility{
    
    /************************************************************************************
    * @description   This method ensures the fields are Createable. Ensuring FLS.
    * @author        Persistent Systems
    * @date          16/11/2017
    * @return        Boolean
    ************************************************************************************/
	public static Boolean isCreateable(List<String> fieldNames, String objName){
		Boolean isValid = false;
		
		Map<String,Schema.SObjectType> sObjectSchemaMap = Schema.getGlobalDescribe();
		SObjectType currentObj = sObjectSchemaMap.get(objName);
		
		if(currentObj.getDescribe().isAccessible() && currentObj.getDescribe().isCreateable()){ 
			for(String fieldName : fieldNames){
				SObjectField currentField = currentObj.getDescribe().fields.getMap().get(fieldName);
				
				if(currentField.getDescribe().isAccessible() && currentField.getDescribe().isCreateable()){
					isValid = true;
				}else{
					isValid = false;
					break;
				} 
			}
		}else{
			isValid = false;
		}
		return isValid;
	}
    
    /***************************************************************************************************
    * @description   This method ensures the fields are Accessible. Ensuring FLS.
    * @author        Persistent Systems
    * @date          16/11/2017
    * @return        Boolean
    ****************************************************************************************************/
    public static Boolean isAccessible(List<String> fieldNames, String objName){
        Boolean isValid = false;
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        SObjectType currentObj = schemaMap.get(objName);
        
        if(currentObj.getDescribe().isAccessible()){ 
            for(String fieldName : fieldNames){
                SObjectField currentField = currentObj.getDescribe().fields.getMap().get(fieldName);
                
                if(currentField.getDescribe().isAccessible()){
                    isValid = true;
                }else{
                    isValid = false;
                    break;
                }    
            }
        }else{
            isValid = false;
        }
        return isValid;
    }
	
	/***************************************************************************************************
    * @description   This method ensures the fields are Deletable. Ensuring FLS.
    * @author        Persistent Systems
    * @date          16/11/2017
    * @return        Boolean
    ****************************************************************************************************/
   public static Boolean isDeletable(List<String> fieldNames, String objName){
        Boolean isValid = false;
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        SObjectType currentObj = schemaMap.get(objName);
        
        if(currentObj.getDescribe().isAccessible() && currentObj.getDescribe().isDeletable()){ 
            for(String fieldName : fieldNames){
                SObjectField currentField = currentObj.getDescribe().fields.getMap().get(fieldName);
                
                if(currentField.getDescribe().isAccessible() ){
                    isValid = true;
                }else{
                    isValid = false;
                    break;
                }    
            }
        }else{
            isValid = false;
        }
        return isValid;
    }

	/***************************************************************************************************
    * @description   This method ensures the fields are Createable and Updateable. Ensuring FLS.
    * @author        Persistent Systems
    * @date          16/11/2017
    * @return        Boolean
    ****************************************************************************************************/
   public static Boolean isUpdateable(List<String> fieldNames, String objName){
        Boolean isValid = false;
        Map<String,Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        SObjectType currentObj = schemaMap.get(objName);
        System.debug(' acsble ' + currentObj.getDescribe().isAccessible() );
        System.debug(' acsble ' + currentObj.getDescribe().isUpdateable() );
        if(currentObj.getDescribe().isAccessible() && currentObj.getDescribe().isUpdateable()){ 
            for(String fieldName : fieldNames){
                SObjectField currentField = currentObj.getDescribe().fields.getMap().get(fieldName);
                System.debug(' currentField *' +currentField);
                System.debug(' fld acc '+ currentField.getDescribe().isAccessible());
                System.debug(' fld upd '+ currentField.getDescribe().isUpdateable());
                if(currentField.getDescribe().isAccessible() && currentField.getDescribe().isUpdateable()){
                    isValid = true;
                }else{
                    isValid = false;
                    break;
                }
                System.debug(' currentField ' +currentField +' ** '+ isValid );
            }
        }else{
            isValid = false;
        }
        return isValid;
    }
    

}