/**************************************************************************************************************
*   @author         Persistent Systems
*   @date           13/09/2018
*   @description    This class is used for parsing json response for universe draup 
***************************************************************************************************************/
public with sharing class DraupAccountResponseParser {
    public static String draupId,recordId;
/*************************************************************************
* @description   Method to parse the universe draup json response based on recordType
* @author        Persistent Systems
* @date          13/09/2018
* @parameter     String jsonResponse,List<DraupHeader__c> draupHeaderList,String recordId,String draupId
* @return        Map<Id,List<DraupChild__c>>
**************************************************************************/
    public static Map<Id,List<DraupChild__c>> parseJsonResponseForAccount(String jsonResponse,List<DraupHeader__c> draupHeaderList,String recordId,String draupId){
        try{
            
            //Map<Id,List<DraupChild__c>> map1 = new Map<Id,List<DraupChild__c>>();
            boolean headerInsertvalid =  Utility.isUpdateable(getDraupHeaderFieldList(),'draupApp__DraupHeader__c');
            boolean childInsertvalid =  Utility.isCreateable(getDraupChildFieldList(),'draupApp__DraupChild__c');
            if(headerInsertvalid == true && childInsertvalid == true )
            {
            transient Map<String,Object> obj= (Map<String,Object>)JSON.deserializeUntyped(jsonResponse); 
            List<DraupChild__c> draupChildList;
            Id devRecordTypeId ;
            Map<Id,List<DraupChild__c>> draupHeaderChildMap = new Map<Id,List<DraupChild__c>>();
            // check for 'hiring' node in json 
            if(obj.containsKey('hiring')){                
                draupChildList = new List<DraupChild__c>(); 
                List<Object> hiringList = DraupConstants.HIRING;
                Map<String,Object>  tempMap = (Map<String, Object>)obj.get('hiring');
                devRecordTypeId = Schema.SObjectType.DraupHeader__c.getRecordTypeInfosByName().get(String.valueOf(hiringList.get(0))).getRecordTypeId();
                //system.debug('rec id::'+devRecordTypeId);
                DraupHeader__c dh = new DraupHeader__c(RecordTypeId = devRecordTypeId,Draup_Id__c=draupId,Account__c=recordId,Type__c='Universe',displayOrder__c=Integer.valueOf(hiringList.get(1)));
                draupHeaderList.add(dh);
                
                if(tempMap!=null){
                    
                    for(String loc : tempMap.keySet()){
                        Map<String,Object> temp1 = ( Map<String, Object>)tempMap.get(loc);
                        List<String> skillList = new List<String>();
                        DraupChild__c dc = new DraupChild__c(TopLocations__c=loc);
                        dc.KeySkillsHired__c = '';
                        dc.TopTitles__c ='';
                        Map<String,Object> temp2 = ( Map<String, Object>)temp1.get('skills');
                       	Map<String,Integer> sortedSkills = new Map<String,Integer>();
                        list<DraupHiringSortWrapper> skillsList = new List<DraupHiringSortWrapper>();
                        list<DraupHiringSortWrapper> titleList = new List<DraupHiringSortWrapper>();
                        integer j = 0;
                        if(temp2!=null){
                        for(string key: temp2.keyset())
                        {
                            
                            skillsList.add(new DraupHiringSortWrapper(key,(Integer)temp2.get(key)));
                        
                        }
                        
                        //System.debug('skillsList @@@@ '+skillsList);
                        skillsList.sort();
                      
                        integer i = 0;
                        for(DraupHiringSortWrapper ds : skillsList){
                            if(i==10){
                                break;
                            }
                            dc.KeySkillsHired__c += ds.hiringData+', ';
                            i++;
                        }
                        //system.debug('value of skill list is @@@@@'+skillsList);
                        }
                        integer i = 0;
                       
                        Map<String,Object> temp3 = ( Map<String, Object>)temp1.get('titles');
                        i = 0;
                        if(temp3!=null){
                             for(string key: temp3.keyset())
                        {
                            
                            titleList.add(new DraupHiringSortWrapper(key,(Integer)temp3.get(key)));
                        
                        }
                             titleList.sort();
                            i = 0;
                        for(DraupHiringSortWrapper ds : titleList){
                            if(i==10){
                                break;
                            }
                            dc.TopTitles__c += ds.hiringData+', ';
                            i++;
                        }
                      
                        }
                        dc.KeySkillsHired__c = ((dc.KeySkillsHired__c !='')?dc.KeySkillsHired__c.removeEnd(', '):'');
                        dc.TopTitles__c = ((dc.TopTitles__c !='')?dc.TopTitles__c.removeEnd(', '):'');
                        draupChildList.add(dc);
                    }
                    draupHeaderChildMap.put(devRecordTypeId,draupChildList);
                   
                }
            }
            // check for 'startegic_signals' node in json
            if(obj.containsKey('startegic_signals')){
                draupChildList = new List<DraupChild__c>();
                List<Object> signalList = DraupConstants.STARTEGIC_SIGNALS;
                devRecordTypeId = Schema.SObjectType.DraupHeader__c.getRecordTypeInfosByName().get(String.valueOf(signalList.get(0))).getRecordTypeId();
                DraupHeader__c dh = new DraupHeader__c(RecordTypeId = devRecordTypeId,Draup_Id__c=draupId,Account__c=recordId,Type__c='Universe',displayOrder__c=Integer.valueOf(signalList.get(1)));
                draupHeaderList.add(dh);
                integer order = 0;
                // insert(dh);
                List<Object> signals = (List<Object>)obj.get('startegic_signals');
                for(Object signal: signals ){
                    
                    Map<String,Object> value = (Map<String,Object>)signal;
                    
                    //  system.debug('value: '+value);
                    String dateCaptured = (String)value.get('date_captured');
                    String strategicDate = formatDate(Date.valueOf(dateCaptured));
                    DraupChild__c dc = new DraupChild__c(StrategicDate__c= strategicDate,StrategicSignalTitle__c=(String)value.get('news_title'),Tag__c=(String)value.get('signal_type'),Link__c=(String)value.get('news_url'),expOrder__c = order,DraupHeader__c=dh.Id);
                    draupChildList.add(dc);
                    order++;
                }
                draupHeaderChildMap.put(devRecordTypeId,draupChildList);
            }
             // check for 'outsourcing' node in json
            if(obj.containsKey('outsourcing')){
                draupChildList = new List<DraupChild__c>();
                List<Object> outsourcingList = DraupConstants.OUTSOURCING;
                devRecordTypeId = Schema.SObjectType.DraupHeader__c.getRecordTypeInfosByName().get(String.valueOf(outsourcingList.get(0))).getRecordTypeId();
                DraupHeader__c dh = new DraupHeader__c(RecordTypeId = devRecordTypeId,Draup_Id__c=draupId,Account__c=recordId,Type__c='Universe',displayOrder__c=Integer.valueOf(outsourcingList.get(1)));
                draupHeaderList.add(dh);
                Map<String,Object> outsourcing = (Map<String,Object>)obj.get('outsourcing');
                DraupChild__c dc = new DraupChild__c();
                
                List<Object> subVerticals = (List<Object>)outsourcing.get('subverticals');
                dc.KeySubVerticals__c ='';
                
                for(Object str : subVerticals)
                {
                    String subverticle =(String) str;
                    dc.KeySubVerticals__c += subverticle + ', ' ;
                    
                }
                
                dc.KeySubVerticals__c = ((dc.KeySubVerticals__c !='')?dc.KeySubVerticals__c.removeEnd(', '):'');
                List<Object> vendors = (List<Object>)outsourcing.get('vendors');
                Boolean bVendorsCheck = true ;
                String vendor = '';
                for(Object str : vendors)
                {
                    if(!bVendorsCheck)
                    {
                        vendor +=', ';
                    }
                    vendor += (String) str;
                    bVendorsCheck = false;
                    //String vendor =(String) str;
                   
                }
                dc.KeyVendors__c =vendor;
                
                //dc.KeyVendors__c = ((dc.KeyVendors__c !='')?dc.KeyVendors__c.removeEnd(', '):'');
                List<Object> locations = (List<Object>)outsourcing.get('locations');
                dc.KeyLocations__c ='';
                
                for(Object str : locations)
                {
                    String loc =(String) str;
                    dc.KeyLocations__c += loc.replace(',', ':') + ', ' ;
                    
                }
                
                dc.KeyLocations__c = ((dc.KeyLocations__c !='')?dc.KeyLocations__c.removeEnd(', '):'');
                draupChildList.add(dc);
                draupHeaderChildMap.put(devRecordTypeId,draupChildList);
            }
            // check for 'executive_movement' node in json
            if(obj.containsKey('executive_movement')){
                draupChildList = new List<DraupChild__c>();
                List<Object> movementList =  DraupConstants.EXECUTIVE_MOVEMENT;
                devRecordTypeId = Schema.SObjectType.DraupHeader__c.getRecordTypeInfosByName().get(String.valueOf(movementList.get(0))).getRecordTypeId();
                DraupHeader__c dh = new DraupHeader__c(RecordTypeId = devRecordTypeId,Draup_Id__c=draupId,Account__c=recordId,Type__c='Universe',displayOrder__c=Integer.valueOf(movementList.get(1)));
                draupHeaderList.add(dh);
                List<Object> exeMovements = (List<Object>)obj.get('executive_movement');
                for(Object exeMovement: exeMovements ){
                    
                    Map<String,Object> value = (Map<String,Object>)exeMovement;
                    //system.debug('value: '+value);
                    String fluxdate = (String)value.get('flux_date');
                    system.debug('fluxdate : '+fluxdate);
                    Date d = Date.valueOf(fluxdate.substring(0,fluxdate.indexOf('T')));
                    //Date pd = date.parse(fluxdate);
                    //System.debug(' Pd '+ pd);
                    system.debug('d : '+ d);
                    DraupChild__c dc = new DraupChild__c(MovementDate__c=d,type__c=(String)value.get('flux_type'),ExecutiveMovementTitle__c=(String)value.get('from_title'),To_Title__c=(String)value.get('to_title'),ExecutiveName__c=(String)value.get('executive_name'),DraupHeader__c=dh.Id);
                    draupChildList.add(dc);
                }
                    draupHeaderChildMap.put(devRecordTypeId,draupChildList); 
            }
            // check for 'overview' node in json
            if(obj.containsKey('overview')){
                draupChildList = new List<DraupChild__c>();
                List<Object> overviewList = DraupConstants.OVERVIEW;
                devRecordTypeId = Schema.SObjectType.DraupHeader__c.getRecordTypeInfosByName().get(String.valueOf(overviewList.get(0))).getRecordTypeId();
               
                DraupHeader__c dh = new DraupHeader__c(RecordTypeId = devRecordTypeId,Draup_Id__c=draupId,Account__c=recordId,Type__c='Universe',displayOrder__c=Integer.valueOf(overviewList.get(1)));
                draupHeaderList.add(dh);
                
                Map<String,Object> overview = (Map<String,Object>)obj.get('overview');
                if(overview!=null){
                    //supriya :: RDSpendGrowth__c to be decimal
                    string rdSpendGrowth= ((overview.get('rnd_spend_growth') != null)?string.valueOf(overview.get('rnd_spend_growth')):'0');
                    //system.debug('RDSpendGrowth***'+RDSpendGrowth);
                    DraupChild__c dc = new DraupChild__c(OpportunityIndex__c=Double.valueOf(overview.get('opportunity_index')),RDSpend__c=Integer.valueOf(overview.get('rnd_spend')),RDSpendGrowth__c=Decimal.valueOf(rdSpendGrowth),TotalRDWorkforce__c=Integer.valueOf(overview.get('total_rnd_workforce')),TotalITWorkforce__c=Integer.valueOf(overview.get('total_it_workforce')),Headquarters__c=String.valueOf(overview.get('headquarters')).replace(',',';'),DraupHeader__c=dh.Id);
                    draupChildList.add(dc);
                    draupHeaderChildMap.put(devRecordTypeId,draupChildList);
                }
            }
            // check for 'techstack' node in json
            if(obj.containsKey('techstack')){
                draupChildList = new List<DraupChild__c>();
                List<Object> stackList = DraupConstants.TECHSTACK;
                devRecordTypeId = Schema.SObjectType.DraupHeader__c.getRecordTypeInfosByName().get(String.valueOf(stackList.get(0))).getRecordTypeId();
                DraupHeader__c dh = new DraupHeader__c(RecordTypeId = devRecordTypeId,Draup_Id__c=draupId,Account__c=recordId,Type__c='Universe',displayOrder__c=Integer.valueOf(stackList.get(1)));
                draupHeaderList.add(dh);
                // insert dh;
                Map<String,Object> techstack = (Map<String,Object>)obj.get('techstack');
                for(String category : techstack.keySet()){
                    DraupChild__c dc = new DraupChild__c(Categories__c=String.valueOf(category),DraupHeader__c=dh.Id);
                    
                    List<object> techStackList = (List<object>)techstack.get(category);
                    dc.TechStack__c ='';
                    
                    for(Object str : techStackList)
                    {
                        String tech =(String) str;
                        dc.TechStack__c += tech + ', ' ;
                        
                    }
                    //system.debug('techStackStr***'+dc.TechStack__c); 
                    dc.TechStack__c = ((dc.TechStack__c !='')?dc.TechStack__c.removeEnd(', '):'');
                    
                    //System.debug('str**'+techStackList);
                    Map<integer, string> mapTechList = new Map<integer, string>();
                    
                    draupChildList.add(dc);
                }
                
                
                draupHeaderChildMap.put(devRecordTypeId,draupChildList);
            }
            // check for 'globalization' node in json
            if(obj.containsKey('globalization')){
                draupChildList = new List<DraupChild__c>();
                List<Object> globalRecords = DraupConstants.GLOBALIZATION;
                devRecordTypeId = Schema.SObjectType.DraupHeader__c.getRecordTypeInfosByName().get(String.valueOf(globalRecords.get(0))).getRecordTypeId();
                
                DraupHeader__c dh = new DraupHeader__c(RecordTypeId = devRecordTypeId,Draup_Id__c=draupId,Account__c=recordId,Type__c='Universe',displayOrder__c=Integer.valueOf(globalRecords.get(1)));
                draupHeaderList.add(dh);
                
                Map<String,Object> globalization = (Map<String,Object>)obj.get('globalization');
                if(globalization!=null){
                    for(String type : globalization.keySet()){
                        List<Object> globalList = ( List<Object>)globalization.get(type);
                        for(Object globalObj:globalList){
                            Map<String,Object> globalMap = (Map<String,Object>)globalObj;
                            //  system.debug('globalMap::'+globalMap);
                            DraupChild__c dc = new DraupChild__c(Vendors__c=String.valueOf(globalMap.get('vendors')),Country__c=String.valueOf(globalMap.get('country')),Type__c=String.valueOf(globalMap.get('site_class')),Location__c=String.valueOf(globalMap.get('location')),LocationClass__c=String.valueOf(globalMap.get('location_class')),headcount__c=Integer.valueOf(globalMap.get('headcount')),DraupHeader__c=dh.Id);
                            dc.SubVerticalsAccount__c = '';
                            dc.Vendors__c ='';
                            List<Object> verticles = (List<Object>)globalMap.get('subverticals');
                            for(Object oVerticle : verticles){
                                String verticle = (String)oVerticle;
                                dc.SubVerticalsAccount__c += verticle +', ';
                            }
                            List<Object> vendors = (List<Object>)globalMap.get('vendors');
                            for(Object oVendor: vendors){
                                String vendor = (String)oVendor;
                                dc.Vendors__c += vendor +', ';
                            }
                            dc.SubVerticalsAccount__c = ((dc.SubVerticalsAccount__c !='')?dc.SubVerticalsAccount__c.removeEnd(', '):'');
                            dc.Vendors__c = ((dc.Vendors__c !='')?dc.Vendors__c.removeEnd(', '):'');
                            
                            draupChildList.add(dc);
                        }
                        
                    }
                    
                    draupHeaderChildMap.put(devRecordTypeId,draupChildList);
                }
                //System.debug(' draupHeaderChildMap '+ draupHeaderChildMap);
            
            }            
            return draupHeaderChildMap;
            }
        	else
            {
              return null;   
            }
        }catch(Exception ex){
            System.debug('Message '+ ex.getMessage()+'line number '+ex.getLineNumber());
            ExceptionHandler.logApexError('DraupAccountResponseParser', 'parseJsonResponseForAccount', String.valueOf(ex.getLineNumber()) , ex.getStackTraceString());
            return null;
        }
        }
/*************************************************************************
* @description   Method to format date in MMM dd YYYY format for startegeic date
* @author        Persistent Systems
* @date          29/09/2018
* @parameter     Date dt
* @return        String
**************************************************************************/

    public static String formatDate(Date dt) {
        Datetime dt1 = datetime.newInstance(dt.year(), dt.month(),dt.day());
        String formattedDate = dt1.format('MMM dd yyyy');
        return  formattedDate;
    }
    
/***************************************************************************************************
    * @description   This method is used get the DraupHeader fieldList for FLS
    * @author        Persistent Systems
    * @param         ------
    * @date          20/09/2018
    * @return        List<string>
    ***************************************************************************************************/
    public static List<String> getDraupHeaderFieldList()
    {
        Map<String, Schema.SObjectField> schemaFieldMap = Schema.SObjectType.draupApp__DraupHeader__c.fields.getMap();
        
        List<String> fieldList = new List<String>();
        for(String field :schemaFieldMap.keyset()){
            if(field.contains('__c'))
              fieldList.add(field);
        }
        system.debug('fieldList DH**'+fieldList);
        return fieldList;
    }
   /***************************************************************************************************
    * @description   This method is used get the DraupChild fieldList for FLS
    * @author        Persistent Systems
    * @param         ------
    * @date          20/09/2018
    * @return        List<string>
    ***************************************************************************************************/
    public static List<String> getDraupChildFieldList()
    {
        Map<String, Schema.SObjectField> schemaFieldMap = Schema.SObjectType.draupApp__DraupChild__c.fields.getMap();
        List<String> fieldList = new List<String>();
        for(String field :schemaFieldMap.keyset()){
            if(field.contains('__c'))
           	 fieldList.add(field);
        }
        return fieldList;
    }
    
}