global class skedLocationServices{
    
    //public static final String OBJ_LOCATION     = 'sked__Location__c';
    public static final String OBJ_JOB          = 'sked__Job__c';
    //public static final String OBJ_RESOURCE     = 'sked__Resource__c';
    //public static final String OBJ_ACTIVITY     = 'sked__Activity__c';
    public static final String OBJ_OPPORTUNITY  = 'Opportunity';
    public static final String OBJ_ACCOUNT      = 'Account';
    public static final String GOO_END_POINT    = 'https://maps.googleapis.com/maps/api';

    public static String GEOCODE_DATA = '{"results":[{"address_components":[{"long_name":"StationStreet","short_name":"StationSt","types":["route"]},{"long_name":"Sunbury","short_name":"Sunbury","types":["locality","political"]},{"long_name":"HumeCity","short_name":"Hume","types":["administrative_area_level_2","political"]},{"long_name":"Victoria","short_name":"VIC","types":["administrative_area_level_1","political"]},{"long_name":"Australia","short_name":"AU","types":["country","political"]},{"long_name":"3429","short_name":"3429","types":["postal_code"]}],"formatted_address":"StationSt&EvansSt,SunburyVIC3429,Australia","geometry":{"location":{"lat":-37.58204540000001,"lng":144.7276305},"location_type":"APPROXIMATE","viewport":{"northeast":{"lat":-37.58069641970851,"lng":144.7289794802915},"southwest":{"lat":-37.58339438029151,"lng":144.7262815197085}}},"place_id":"EjJTdGF0aW9uIFN0ICYgRXZhbnMgU3QsIFN1bmJ1cnkgVklDIDM0MjksIEF1c3RyYWxpYQ","types":["intersection"]}],"status":"OK"}';

    public static Integer BATCH_SIZE            = 50;

    public static Map<String,String> ADDR_FIELD_MAP = new Map<String,String>{
        //OBJ_LOCATION    => 'sked__Address__c',
        OBJ_JOB         => 'sked__Address__c',
        //OBJ_RESOURCE    => 'sked__Home_Address__c',
        //OBJ_ACTIVITY    => 'sked__Address__c',
        OBJ_OPPORTUNITY => 'Physical_Address__c',
        OBJ_ACCOUNT     => 'BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry'
    };

    

    /*
    * Populate Location Geocode when address is changed
    */
    public static void updateLocationGeocode(list<sObject> oldList, Map<Id, sObject> newMap, String objectType){
        if(System.isFuture()) return;
        if(!ADDR_FIELD_MAP.containsKey(objectType)) return;

        Set<Id> locationIDs = new Set<Id>();
        String addressField = ADDR_FIELD_MAP.get(objectType);
        if(oldList == null){//Insert
            locationIDs = newMap.keySet();
        }else{//Update
            sObject newLoc;
            for(sObject oldLoc : oldList){
                newLoc = newMap.get(oldLoc.Id);
                if( getAddress(newLoc, addressField) != getAddress(oldLoc, addressField) ){
                    locationIDs.add(newLoc.Id);
                }
            }
        }
        if(locationIDs==null || locationIDs.isEmpty()) return;
        list<Id> idList = new list<Id>(locationIDs);
        if(idList.size() > BATCH_SIZE){//Process in batch to avoid callout limit
            skedBatchProcessor batch = new skedBatchProcessor(String.join(idList,';'), objectType);
            Database.executeBatch(batch, BATCH_SIZE);
        }else updateGeoLocationAsync(String.join(idList,';'), objectType);
    }

    /*
    *
    */
    public static String getAddress(sObject rec, String fieldName){
        if(!fieldName.contains(',')) return rec.get(fieldName)==null?'':String.valueOf(rec.get(fieldName) );
        String addr = '';
        for(String f : fieldName.split(',')){
            if(rec.get(f) != null) addr += ' ' + rec.get(f);
        }
        return addr;
    }

    /*
    * Update geolocation for a list of record
    */
    global static void updateGeoLocation(list<String> recordIds, string objectType) {
        if(!ADDR_FIELD_MAP.containsKey(objectType)) return;
        
        String query = 'Select Id, ' + ADDR_FIELD_MAP.get(objectType)  + '  from ' + objectType + ' where Id IN :recordIds';
       
         List<sObject> records = Database.query(query);
        String addressField = ADDR_FIELD_MAP.get(objectType);
        for (sObject record : records) {
            
            Location geoData = skedLocationServices.getGeolocationGoogleAPI( getAddress(record, addressField) );
            system.debug(geoData);
            if (geoData != null) {
                if(objectType == OBJ_ACCOUNT){
                    record.put('GeoLocation__latitude__s', geoData.getLatitude());
                    record.put('GeoLocation__longitude__s', geoData.getLongitude());
                }else{
                    record.put('sked__GeoLocation__latitude__s', geoData.getLatitude());
                    record.put('sked__GeoLocation__longitude__s', geoData.getLongitude());  
                }
            }
        }
        update records;
    }

    /*
    * Asynchronously update geolocation for a list of record
    */
    @future(callout=true)
    global static void updateGeoLocationAsync(String idList, string objectType) {
        if(!System.isFuture() || System.isBatch()) return;//cannot call a future method from a future or batch context
        string[] recordIds = idList.split(';');
        updateGeoLocation(recordIds, objectType);
    }
    
    /*get GeoLocation using Google API*/
    public static Location getGeolocationGoogleAPI(string address){
        
        address = EncodingUtil.urlEncode(address, 'UTF-8');
        // build callout
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        STRING endPointString = GOO_END_POINT + '/geocode/json?address='+address+'&key=' + skedConfigs.GOOGLE_API_KEY;
        
        req.setEndpoint(endPointString);
        req.setMethod('GET');
        req.setTimeout(10000);
        
        try{
            // callout
            String body;
            if(Test.isRunningTest()){
                body = GEOCODE_DATA;
            }else{
                HttpResponse res = h.send(req);
                body = res.getBody();
            }
            
            // parse coordinates from response
            JSONParser parser = JSON.createParser(body);
            double lat = null;
            double lon = null;
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
                    (parser.getText() == 'location')){
                        parser.nextToken(); // object start
                        while (parser.nextToken() != JSONToken.END_OBJECT){
                            String txt = parser.getText();
                            parser.nextToken();
                            if (txt == 'lat')
                                lat = parser.getDoubleValue();
                            else if (txt == 'lng')
                                lon = parser.getDoubleValue();
                        }
                        
                    }
            }
            Location obj =  Location.newInstance(lat,lon);
            return obj;
        
        } catch (Exception e) {}
        
        return null;
    }
}