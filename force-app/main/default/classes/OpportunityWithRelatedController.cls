public class OpportunityWithRelatedController {

    public final Integer relatedLimit = 200;
    
    public Opportunity thisOpportunity{get;set;}
    public Boolean showFields{get;set;}
    public Boolean showMaterials{get;set;}
    public Boolean showFeeds{get;set;}
    public Boolean showSeeds{get;set;}
    public Boolean showStorage{get;set;}
    public Boolean showLivestock{get;set;}    
    public Boolean showProduct{get;set;}
    public ID selectedId {get;set;}
    public Boolean editMode {get;set;}
    public Integer relatedCount {get;set;}
    public Boolean showOrganicHeader {get;set;}

    public String modToDelete {
        get;
        // *** setter is NOT being called ***
        set {
            modToDelete = value;
        }
    }

    public ID itemIDToDelete {
        get;
        // *** setter is NOT being called ***
        set {
            itemIDToDelete = value;
        }
    }
    
    public OpportunityWithRelatedController(ApexPages.StandardController controller) {                
        //Assign Opportunity
        Id oppId = controller.getId();
        showFields = false;
        showMaterials = false;
        showFeeds = false;
        showSeeds = false;
        showStorage = false;
        showLivestock = false;
        showProduct = false;
        editMode = false;
        showOrganicHeader = false;
        relatedCount = 0;
        
        reQueryOpp(oppId);
            
    }

    public void reQueryOpp(Id oppId){
        //Info for Opp query
        /*DescribeSObjectResult oppdescribeResult = Opportunity.getSObjectType().getDescribe();       
        List<String> oppfieldNames = new List<String>( oppdescribeResult.fields.getMap().keySet() );*/  
        
        //Info for field query
        DescribeSObjectResult fielddescribeResult = Field__c.sObjectType.getDescribe();     
        List<String> fieldfieldNames = new List<String>( fielddescribeResult.fields.getMap().keySet() ); 
        
        //Info for livestock query
        DescribeSObjectResult livestockdescribeResult = livestock__c.sObjectType.getDescribe();     
        List<String> livestockfieldNames = new List<String>( livestockdescribeResult.fields.getMap().keySet() ); 
        
        //Info for feeds query
        DescribeSObjectResult feedsdescribeResult = feeds__c.sObjectType.getDescribe();     
        List<String> feedsfieldNames = new List<String>( feedsdescribeResult.fields.getMap().keySet() ); 
        
        //Info for storage query
        DescribeSObjectResult storagedescribeResult = storage__c.sObjectType.getDescribe();     
        List<String> storagefieldNames = new List<String>( storagedescribeResult.fields.getMap().keySet() ); 
        
        //Info for material query
        DescribeSObjectResult materialdescribeResult = material__c.sObjectType.getDescribe();       
        List<String> materialfieldNames = new List<String>( materialdescribeResult.fields.getMap().keySet() ); 
        
        //Info for seeds query
        DescribeSObjectResult seedsdescribeResult = seeds__c.sObjectType.getDescribe();     
        List<String> seedsfieldNames = new List<String>( seedsdescribeResult.fields.getMap().keySet() ); 

        //Info for products query
        DescribeSObjectResult productsdescribeResult = product__c.sObjectType.getDescribe();     
        List<String> productsfieldNames = new List<String>( productsdescribeResult.fields.getMap().keySet() ); 
        
        
        String query =' SELECT ID, Name, '/* + String.join( oppfieldNames, ',' ) +  ','*/; 
        query += '(SELECT ' + String.join( fieldfieldNames, ',' ) + ' FROM fields__r),'; 
        query += '(SELECT ' + String.join( livestockfieldNames, ',' ) + ' FROM livestock__r),'; 
        query += '(SELECT ' + String.join( feedsfieldNames, ',' ) + ' FROM feeds__r),'; 
        query += '(SELECT ' + String.join( storagefieldNames, ',' ) +   ' FROM storage__r),'; 
        query += '(SELECT ' + String.join( materialfieldNames, ',' ) +  ' FROM materials__r),'; 
        query += '(SELECT ' + String.join( seedsfieldNames, ',' ) + ' FROM seeds__r),';         
        query += '(SELECT ' + String.join( productsfieldNames, ',' ) + ' FROM products__r)'; 
        
        query +=' FROM Opportunity WHERE ID = :oppId';
        thisOpportunity = Database.query(query);  

        relatedCount = thisOpportunity.fields__r.size() + thisOpportunity.livestock__r.size() + thisOpportunity.feeds__r.size() 
        + thisOpportunity.storage__r.size()
        + thisOpportunity.materials__r.size() + thisOpportunity.seeds__r.size();
        if(relatedCount > 0){
            showOrganicHeader = true;
        }

        relatedCount = relatedCount + thisOpportunity.products__r.size();  
    }
    
    public Opportunity getthisOpportunity(){
        return thisOpportunity;
    }  
    
    public void setEdit(){
        editMode = true;
        return;
    }

    public void cancel(){
        editMode = false;
        selectedId = null;
    }
    
    public void save(){
        try{
            String sObjName = selectedId.getSObjectType().getDescribe().getName();
            if(sObjName == 'field__c'){
                update thisOpportunity.fields__r; 
            } else if(sObjName == 'livestock__c'){
                update thisOpportunity.livestock__r; 
            } else if(sObjName == 'feeds__c'){
                update thisOpportunity.feeds__r; 
            } else if(sObjName == 'storage__c'){
                update thisOpportunity.storage__r; 
            } else if(sObjName == 'material__c'){
                update thisOpportunity.materials__r; 
            } else if(sObjName == 'seeds__c'){
                update thisOpportunity.seeds__r; 
            }  else if(sObjName == 'product__c'){
                update thisOpportunity.products__r; 
            }
            editMode = false;
        }catch (Exception e){
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.Confirm, e.getMessage() + e.getStackTraceString());
            ApexPages.addMessage(errorMessage);
        }
    }

    public void newFeed(){
        if(relatedCount>=relatedLimit){
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.Error, 'You have hit the max of ' + relatedLimit + ' related items.');
            ApexPages.addMessage(errorMessage);
            return;
        }

        Feeds__c newFeed = new Feeds__c();
        newFeed.Name = thisOpportunity.Name + ' Feeds';
        newFeed.Opportunity__c = thisOpportunity.Id;
        insert newFeed;
        relatedCount++;

        reQueryOpp(thisOpportunity.Id);
        selectedId = newFeed.Id;
        showFeeds = true;
        editMode = true;

        showFields = false;
        showMaterials = false;       
        showSeeds = false;
        showStorage = false;
        showLivestock = false;
        showProduct = false;
    }

    public void newField(){
        if(relatedCount>=relatedLimit){
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.Error, 'You have hit the max of ' + relatedLimit + ' related items.');
            ApexPages.addMessage(errorMessage);
            return;
        }

        Field__c newField = new Field__c();
        newField.Name = thisOpportunity.Name + ' Field';
        newField.Opportunity__c = thisOpportunity.Id;
        insert newField;
        relatedCount++;

        reQueryOpp(thisOpportunity.Id);
        selectedId = newField.Id;
        showFields = true;
        editMode = true;

        showMaterials = false;
        showFeeds = false;
        showSeeds = false;
        showStorage = false;
        showLivestock = false;
        showProduct = false;
    }

    public void newMaterial(){
        if(relatedCount>=relatedLimit){
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.Error, 'You have hit the max of ' + relatedLimit + ' related items.');
            ApexPages.addMessage(errorMessage);
            return;
        }
        Material__c newMaterial = new Material__c();
        newMaterial.Name = thisOpportunity.Name + ' Material';
        newMaterial.Opportunity__c = thisOpportunity.Id;
        insert newMaterial;
        relatedCount++;

        reQueryOpp(thisOpportunity.Id);
        selectedId = newMaterial.Id;
        showMaterials = true;
        editMode = true;

        showFields = false;
        showFeeds = false;
        showSeeds = false;
        showStorage = false;
        showLivestock = false;
        showProduct = false;
    }

    public void newStorage(){
        if(relatedCount>=relatedLimit){
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.Error, 'You have hit the max of ' + relatedLimit + ' related items.');
            ApexPages.addMessage(errorMessage);
            return;
        }

        Storage__c newStorage = new Storage__c();
        newStorage.Name = thisOpportunity.Name + ' Storage';
        newStorage.Opportunity__c = thisOpportunity.Id;
        insert newStorage;
        relatedCount++;

        reQueryOpp(thisOpportunity.Id);
        selectedId = newStorage.Id;
        showStorage = true;
        editMode = true;

        showFields = false;
        showMaterials = false;
        showFeeds = false;
        showSeeds = false;
        showLivestock = false;
        showProduct = false;
    }

    public void newSeeds(){
        if(relatedCount>=relatedLimit){
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.Error, 'You have hit the max of ' + relatedLimit + ' related items.');
            ApexPages.addMessage(errorMessage);
            return;
        }

        Seeds__c newSeeds = new Seeds__c();
        newSeeds.Name = thisOpportunity.Name + ' Seeds';
        newSeeds.Opportunity__c = thisOpportunity.Id;
        insert newSeeds;
        relatedCount++;

        reQueryOpp(thisOpportunity.Id);
        selectedId = newSeeds.Id;
        showSeeds = true;
        editMode = true;

        showFields = false;
        showMaterials = false;
        showFeeds = false;
        showStorage = false;
        showLivestock = false;
        showProduct = false;
    }

    public void newLivestock(){
        if(relatedCount>=relatedLimit){
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.Error, 'You have hit the max of ' + relatedLimit + ' related items.');
            ApexPages.addMessage(errorMessage);
            return;
        }

        Livestock__c newLivestock = new Livestock__c();
        newLivestock.Name = thisOpportunity.Name + ' Livestock';
        newLivestock.Opportunity__c = thisOpportunity.Id;
        insert newLivestock;
        relatedCount++;

        reQueryOpp(thisOpportunity.Id);
        selectedId = newLivestock.Id;
        showLivestock = true;
        editMode = true;

        showFields = false;
        showMaterials = false;
        showFeeds = false;
        showSeeds = false;
        showStorage = false;
        showProduct = false;
    }

    public void newProduct(){
        if(relatedCount>=relatedLimit){
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.Error, 'You have hit the max of ' + relatedLimit + ' related items.');
            ApexPages.addMessage(errorMessage);
            return;
        }

        Product__c newProduct = new Product__c();
        newProduct.Name = thisOpportunity.Name + ' Product';
        newProduct.Opportunity__c = thisOpportunity.Id;
        insert newProduct;
        relatedCount++;

        reQueryOpp(thisOpportunity.Id);
        selectedId = newProduct.Id;
        showProduct = true;
        editMode = true;

        showFields = false;
        showMaterials = false;
        showFeeds = false;
        showSeeds = false;
        showStorage = false;
        showLivestock = false;
    }

    public void expandAll() {
        showFields = true;
        showMaterials = true;
        showFeeds = true;
        showSeeds = true;
        showStorage = true;
        showLivestock = true;
        showProduct = true;
    }

    public void collapseAll(){
        showFields = false;
        showMaterials = false;
        showFeeds = false;
        showSeeds = false;
        showStorage = false;
        showLivestock = false;
        showProduct = false;
    }
    
    public void toggleFields() {
        if(showFields){
            showFields = false;
        } else {
            showFields = true;
        }

        showMaterials = false;
        showFeeds = false;
        showSeeds = false;
        showStorage = false;
        showLivestock = false;
        showProduct = false;
    }
    public void toggleMaterials() {
        if(showMaterials){
            showMaterials = false;
        } else {
            showMaterials = true;
        }

        showFields = false;
        showFeeds = false;
        showSeeds = false;
        showStorage = false;
        showLivestock = false;
        showProduct = false;
    }
    public void toggleSeeds() {
        if(showSeeds){
            showSeeds = false;
        } else {
            showSeeds = true;
        }

        showFields = false;
        showMaterials = false;
        showFeeds = false;
        showStorage = false;
        showLivestock = false;
        showProduct = false;
    }
    public void toggleFeeds() {
        if(showFeeds){
            showFeeds = false;
        } else {
            showFeeds = true;
        }

        showFields = false;
        showMaterials = false;
        showSeeds = false;
        showStorage = false;
        showLivestock = false;
        showProduct = false;
    }
    public void toggleStorage() {
        if(showStorage){
            showStorage = false;
        } else {
            showStorage = true;
        }

        showFields = false;
        showMaterials = false;
        showFeeds = false;
        showSeeds = false;
        showLivestock = false;
        showProduct = false;
    }
    public void toggleLivestock() {
        if(showLivestock){
            showLivestock = false;
        } else {
            showLivestock = true;
        }

        showFields = false;
        showMaterials = false;
        showFeeds = false;
        showSeeds = false;
        showStorage = false;
        showProduct = false;
    }

    public void toggleProducts() {
        if(showProduct){
            showProduct = false;
        } else {
            showProduct = true;
        }

        showFields = false;
        showMaterials = false;
        showFeeds = false;
        showSeeds = false;
        showStorage = false;
        showLivestock = false;
    }

    public PageReference removeModule() {
        if(modToDelete=='Product'){
            delete thisOpportunity.Products__r;
        } else if(modToDelete=='Field'){
            delete thisOpportunity.Fields__r;
        } else if(modToDelete=='Livestock'){
            delete thisOpportunity.Livestock__r;
        } else if(modToDelete=='Feed'){
            delete thisOpportunity.Feeds__r;
        } else if(modToDelete=='Storage'){
            delete thisOpportunity.Storage__r;
        } else if(modToDelete=='Material'){
            delete thisOpportunity.Materials__r;
        } else if(modToDelete=='Seed'){
            delete thisOpportunity.Seeds__r;
        } 
        PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
        pageRef.setRedirect(true);
        return pageRef;
    }

    public PageReference removeItem() {
        Schema.SObjectType sobjectType = itemIDToDelete.getSObjectType();
        String sobjectName = sobjectType.getDescribe().getName();

        SObject record = Database.query('Select Id, Name From ' + sobjectName + ' Where Id = :itemIDToDelete');
        delete record;

        PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
        pageRef.setRedirect(true);
        return pageRef;
    }
}