public class OpportunityBuilderController {

    public final Integer relatedLimit = 200;
    
    private String RecordTypeId, RecordTypeName;
    public Integer relatedCount = 0;

    public OpportunityBuilderController(ApexPages.StandardController controller) {
                
        //Create holder for new Opportunity
        thisOpp = new OpportunityWrapper();
        //Assign Opportunity
        if(controller.getId()!=null){
            Id oppId = controller.getId();
            //Opportunity thisOpportunity = [Select Id, Name, RecordType.Name, StageName, AccountId, CloseDate FROM Opportunity WHERE ID = :oppId];
            String query =' SELECT Id, Name, RecordType.Name, StageName, AccountId, CloseDate,'; 
            query += '(SELECT Id FROM fields__r),'; 
            query += '(SELECT Id FROM livestock__r),'; 
            query += '(SELECT Id FROM feeds__r),'; 
            query += '(SELECT Id FROM storage__r),'; 
            query += '(SELECT Id FROM materials__r),'; 
            query += '(SELECT Id FROM seeds__r),';         
            query += '(SELECT Id FROM products__r)';             
            query +=' FROM Opportunity WHERE ID = :oppId';
            Opportunity thisOpportunity = Database.query(query);  

            relatedCount = thisOpportunity.fields__r.size() + thisOpportunity.livestock__r.size() + thisOpportunity.feeds__r.size() 
                + thisOpportunity.storage__r.size()
                + thisOpportunity.materials__r.size() + thisOpportunity.seeds__r.size() + thisOpportunity.products__r.size(); 

            thisOpp.opp = thisOpportunity;
            RecordTypeName = thisOpportunity.RecordType.Name;
            showOppFields = false;
        } else {            
            thisOpp.opp = new Opportunity();
            //Make this page only show for ICS record type
            RecordTypeId = System.currentPageReference().getParameters().get('RecordType');
            RecordTypeName = '';
            for(RecordType rt:[select id,name from recordtype where id = :recordtypeid]){
                RecordTypeName = rt.name;
            }
            thisOpp.opp.RecordTypeId = RecordTypeId;
            showOppFields = true;
        }
        
        
        thisOpp.opp.AccountId = ApexPages.currentPage().getParameters().get('accid');

        init();
    }
    
    public boolean getRedirect()
    {	
        if(RecordTypeName=='ICS')
            return false;
        return true;
    }
    public string getRecordTypeId()
    {
        return RecordTypeId;
    }
    
    //Wrapper class to hold all Opportunity data
    public class OpportunityWrapper{
        public Opportunity opp {get;set;}
        public List<OptionWrapper> modules{get;set;}
        public List<OptionWrapper> objects{get;set;}
        public List<Field__c> fields{get;set;}   
        public List<Livestock__c> livestock{get;set;} 
        public List<Feeds__c> feeds{get;set;} 
        public List<Storage__c> storage{get;set;} 
        public List<Material__c> materials{get;set;} 
        public List<Seeds__c> seeds{get;set;}          
        public List<Product__c> products{get;set;} 
        
        public OpportunityWrapper(){
            opp = new Opportunity();
            modules = new List<OptionWrapper>();
            objects = new List<OptionWrapper>();
            fields = new List<Field__c>();
            livestock = new List<Livestock__c>();
            feeds = new List<Feeds__c>();
            storage = new List<Storage__c>();
            materials = new List<Material__c>();
            seeds = new List<Seeds__c>();
            products = new List<Product__c>();
        }
    }
    
    public class OptionWrapper{
        public String name{get;set;}
        public Boolean isSelected{get;set;}
        public String oType {get;set;}
        
        public optionWrapper(){
            name = '';
            isSelected = false;
            oType='';
        }
        
        public OptionWrapper(String oname, Boolean selected, String ot){
            name = oname;
            isSelected = selected;
            oType = ot;
        }
        public OptionWrapper(String oname, Boolean selected){
            name = oname;
            isSelected = selected;
            oType = '';
        }
    }
    
    public OpportunityWrapper thisOpp{get;set;}
    
    //Show/Hide instructions
    public Boolean showWindow1{get;set;}
    public Boolean showWindow2{get;set;}
    public Boolean showWindow3{get;set;}
    public Boolean showOppFields{get;set;}
    
    //Window 1
    public void init(){
        showWindow1 = true;
        showWindow2 = false;
        showWindow3 = false;

        if(relatedCount>=relatedLimit){
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.Error, 'You have hit the max of ' + relatedLimit + ' related items and can not add more modules.');
            ApexPages.addMessage(errorMessage);
            showWindow1 = false;
            return;
        }
        
        //Create list of options for window 1
        OptionWrapper newModule = new OptionWrapper('Organic Livestock/Crops', false);
        OptionWrapper newModule2 = new OptionWrapper('Organic Handler', false);
        List<OptionWrapper> moduleList = new List<OptionWrapper>();
        moduleList.add(newModule);
		moduleList.add(newModule2);        
        thisOpp.modules = moduleList;
        
    }
	
    
    public OpportunityWrapper getthisOpp(){
        return thisOpp;
    }
    
    //Window 2
    public void goToModuleOptions(){
        //Create list of objects for window 2
        
        //Find which modules are selected and make corresponding object checkboxes
        for(OptionWrapper ow : thisOpp.modules){
            //Create list of organic objects
            if(ow.isSelected && ow.name == 'Organic Livestock/Crops'){
                OptionWrapper newObject = new OptionWrapper('Field', true, 'Organic Livestock/Crops');
                OptionWrapper newObject2 = new OptionWrapper('Livestock', true, 'Organic Livestock/Crops');
                OptionWrapper newObject3 = new OptionWrapper('Feeds', true, 'Organic Livestock/Crops');
                OptionWrapper newObject4 = new OptionWrapper('Storage', true, 'Organic Livestock/Crops');
                OptionWrapper newObject5 = new OptionWrapper('Material', true, 'Organic Livestock/Crops');                
                OptionWrapper newObject6 = new OptionWrapper('Seeds', true, 'Organic Livestock/Crops');
                List<OptionWrapper> ObjectList = new List<OptionWrapper>();
                ObjectList.add(newObject); 
                ObjectList.add(newObject2); 
                ObjectList.add(newObject3); 
                ObjectList.add(newObject4); 
                ObjectList.add(newObject5); 
                ObjectList.add(newObject6); 
                thisOpp.objects = ObjectList;
            }
            if(ow.isSelected && ow.name == 'Organic Handler'){
                OptionWrapper newObject = new OptionWrapper('Products', true, 'Organic Handler');
                List<OptionWrapper> ObjectList = thisOpp.objects;
                ObjectList.add(newObject);
                thisOpp.objects = ObjectList;
            }
        }
        
        
        showWindow1 = false;
        showWindow2 = true;
        showWindow3 = false;
    }
    
    //Window 3
    public PageReference goToInputFields(){
        for(OptionWrapper ow : thisOpp.objects){
            //Create list of organic objects
            if(ow.isSelected && ow.name == 'Field'){
                relatedCount++;
                Field__c newField = new Field__c();
                newField.Name = thisOpp.opp.Name + ' Field';
                thisOpp.fields.add(newField);
            } else if(ow.isSelected && ow.name == 'Livestock'){                
                relatedCount++;
                Livestock__c newLivestock = new Livestock__c();
                newLivestock.Name = thisOpp.opp.Name + ' Livestock';
                thisOpp.livestock.add(newLivestock);
            } else if(ow.isSelected && ow.name == 'Feeds'){
                relatedCount++;
                Feeds__c newFeeds = new Feeds__c();
                newFeeds.Name = thisOpp.opp.Name + ' Feeds';
                thisOpp.Feeds.add(newFeeds);
            }  else if(ow.isSelected && ow.name == 'Storage'){
                relatedCount++;
                Storage__c newStorage = new Storage__c();
                newStorage.Name = thisOpp.opp.Name + ' Storage';
                thisOpp.Storage.add(newStorage);
            } else if(ow.isSelected && ow.name == 'Material'){
                relatedCount++;
                Material__c newMaterial = new Material__c();
                newMaterial.Name = thisOpp.opp.Name + ' Material';
                thisOpp.Materials.add(newMaterial);
            }  else if(ow.isSelected && ow.name == 'Seeds'){
                relatedCount++;
                Seeds__c newSeeds = new Seeds__c();
                newSeeds.Name = thisOpp.opp.Name + ' Seeds';
                thisOpp.Seeds.add(newSeeds);
            }   else if(ow.isSelected && ow.name == 'Products'){
                relatedCount++;
                Product__c newProduct = new Product__c();
                newProduct.Name = thisOpp.opp.Name + ' Products';
                thisOpp.Products.add(newProduct);
            } 
        }

        if(relatedCount>=relatedLimit){
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.Error, 'You have hit the max of ' + relatedLimit + ' related items and can not add more modules.');
            ApexPages.addMessage(errorMessage);
            showWindow1 = false;
            showWindow2 = false;
            showWindow3 = false;
            return null;
        }

        return save();
    }
    
    public PageReference save(){
        try {
            if(thisOpp.opp.Id==null){
                insert thisOpp.opp;
            }
            
            
            //Fields
            if(thisOpp.fields.size() > 0){
                for(field__c field : thisOpp.fields){
                    field.Opportunity__c = thisOpp.opp.Id;
                }
                insert thisOpp.fields;
            }
            
            //Livestock
            if(thisOpp.Livestock.size() > 0){
                for(Livestock__c Livestock : thisOpp.Livestock){
                    Livestock.Opportunity__c = thisOpp.opp.Id;
                }
                insert thisOpp.Livestock;
            }
            
            //Feeds
            if(thisOpp.Feeds.size() > 0){
                for(Feeds__c Feeds : thisOpp.Feeds){
                    Feeds.Opportunity__c = thisOpp.opp.Id;
                }
                insert thisOpp.Feeds;
            }
            
             //Storage
            if(thisOpp.Storage.size() > 0){
                for(Storage__c Storage : thisOpp.Storage){
                    Storage.Opportunity__c = thisOpp.opp.Id;
                }
                insert thisOpp.Storage;
            }
            
             //Material
            if(thisOpp.Materials.size() > 0){
                for(Material__c Material : thisOpp.Materials){
                    Material.Opportunity__c = thisOpp.opp.Id;
                }
                insert thisOpp.Materials;
            }
            
             //Seeds
            if(thisOpp.Seeds.size() > 0){
                for(Seeds__c Seeds : thisOpp.Seeds){
                    Seeds.Opportunity__c = thisOpp.opp.Id;
                }
                insert thisOpp.Seeds;
            }
            
            //Products
            if(thisOpp.Products.size() > 0){
                for(Product__c Product : thisOpp.Products){
                    Product.Opportunity__c = thisOpp.opp.Id;
                }
                insert thisOpp.Products;
            }
            
            PageReference pageRef = new PageReference('/'+thisOpp.opp.Id);

            return pageRef;

            
        } catch (Exception e){
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.Confirm, e.getMessage() + e.getStackTraceString());
            ApexPages.addMessage(errorMessage);
            return null;
        }
        
    }
}