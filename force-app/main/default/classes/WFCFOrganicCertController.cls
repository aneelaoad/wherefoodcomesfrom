/*
Created By: Syed Fasih Ali
Date: 10-Sep-2020

*/

public class WFCFOrganicCertController{
    
    //Our collection of the class/wrapper objects wrapAccount
    public List<wrapAccountProduct> wrapAccountProductList {get; set;}
    public List<account_products__c> selectedAccountProducts{get;set;}
    public List<wrapSiteAddress> wrapSiteAddressList {get; set;}
    public List<Site_Address__c> selectedSiteAddresses{get;set;}
    List<account_products__c> allAccountProductList {get; set;}
    // public List<wrapAccountContact> wrapAccountContactList {get; set;}
    // public List<Contact> selectedAccountContact {get;set;}



    public List<wrapAccountContact> wrapAccountContactList {get; set;}
    public List<Contact> selectedAccountContact {get; set;}
    public string  currentRecordId {get;set;} 
    Public String documentId {get;set;}
    public list<SelectOption> IDMarks{get;set;}
    public string SelectedIdMark{get;set;}
    private Id m_AccountId;
    
    public String errorMessage {get;set;}
    
    Public Integer totalSize{get; set;} // to store total count of account products

    Public Integer pageNumber{get; set;}
    Public integer pageSize{get; set;}
    public ID accIdForPagination {get; set;}
    public boolean  isShow {get;set;}    
    
    public set<id> selectedRecordsId;
    
    public void displayError(String field){
        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.FATAL, 'Cannot continue because of the Error: \nField is empty: ' + field));
    }
    
    public WFCFOrganicCertController(ApexPages.StandardController controller){
        selectedRecordsId = new set<id>();
        currentRecordId  = ApexPages.CurrentPage().getparameters().get('id');
        string currentRecordTypeId = ((Certificate__c)controller.getRecord()).recordTypeId;
        
        system.debug(currentRecordTypeId);
        
       // pageNumber = test.isRunningTest() ? 1 : Integer.valueOf(Apexpages.currentPage().getparameters().get('pageNumber'));        
        pageNumber = 0;
        system.debug('pageNumber' + pageNumber);
        
        //pageSize =  test.isRunningTest() ? 1 : Integer.valueOf(Apexpages.currentPage().getparameters().get('pageSize'));        
        pageSize = 200;
        system.debug('pageSize' + pageSize);
        isShow = true;

        string h = '';
        h += 'kaldjklsa';
        h += 'kaldjklsa';
        h += 'kaldjklsa';
        h += 'kaldjklsa';
        h += 'kaldjklsa';
        h += 'kaldjklsa';
        h += 'kaldjklsa';
        h += 'kaldjklsa';

        
        //need to change documentId whenever you go to deploy over to production.
        if(currentRecordTypeId == Schema.SObjectType.certificate__c.getRecordTypeInfosByName().get('A Bee Organic').getRecordTypeId()){
            
            documentId = 'a2L1R000002rEwkUAE';
        }
        else if(currentRecordTypeId == Schema.SObjectType.certificate__c.getRecordTypeInfosByName().get('WFCF Organic').getRecordTypeId()){
            documentId = 'a2L7z000004T8KsEAK'; 
        }
        else if(currentRecordTypeId == Schema.SObjectType.certificate__c.getRecordTypeInfosByName().get('ICS').getRecordTypeId()){
            documentId = 'a2L1R000002DgX0UAK';
        }
        
      
      //string accountProductId = [select id,AccountID__c  from Certificate__c where id = :currentRecordId limit 1 ].Account_Products__c;
    //  currentRecordId = 'a0V7z000002D7H3EAK';
      string accountId = [select id,Account_ID__c  from Certificate__c where id = :currentRecordId limit 1 ].Account_ID__c;
        m_AccountId = accountId;
        
        IDMarks = new list<SelectOption>();
        SelectOption so1 = new SelectOption('All Products', 'All Products');
        IDMarks.add(so1);
        for(AggregateResult acc_prod : [SELECT Id_Mark__c FROM Account_Products__c Where Account__c =: accountId group by Id_Mark__c ])
        {
            object idMarkObj = acc_prod.get('Id_Mark__c');
            string idMark = string.valueOf(idMarkObj);
            
            if (string.isEmpty(idMark))
                continue;
            
            SelectOption so = new SelectOption(idMark, idMark);
            IDMarks.add(so);
        }

        
        

        allAccountProductList = [SELECT id,Product__c,Customer_Type__c,Product_status__c,Standard__c,ID_Mark__c,is_Selected__c from account_products__c where Account__c = :accountId];
               
        system.debug(accountId +' '+ allAccountProductList.size());
        accIdForPagination = accountId;
        
        // As each Account is processed we create a new wrapAccount object and add it to the wrapAccountList
        if(wrapAccountProductList == null) {
            
            wrapAccountProductList = new List<wrapAccountProduct>();
            //Integer Offset = (Integer.valueOf(pageNumber)-1) * pageSize;
            totalSize = [SELECT count() FROM account_products__c where Account__c = :accountId];
            System.debug('totalSize\n' + totalSize);
            /*
            for(account_products__c a: [SELECT id,Product__c,Customer_Type__c,Product_status__c,Standard__c,ID_Mark__c from account_products__c where Account__c = :accountId LIMIT : pagesize OFFSET : pageNumber ]) {            
                wrapAccountProductList.add(new wrapAccountProduct(a));
            }
            */
            system.debug('OLD products\n'+wrapAccountProductList);
        }
        
        // As each Account is processed we create a new wrapAccount object and add it to the wrapAccountList
        if(wrapSiteAddressList== null) {
            
            wrapSiteAddressList = new List<wrapSiteAddress>();
            
            Account MailingAddress = [ SELECT shippingStreet,  shippingCity, shippingState, shippingCountry, shippingPostalCode  from Account where id = :accountId LIMIT 1];
            
            for(Site_Address__c a: [SELECT id,Name,Address__c,City__c,State__c,Zip__c,country__c from Site_Address__c where Account__c = :accountId]) 
            {
                if(   a.Address__c == MailingAddress.shippingStreet
                   && a.City__c    == MailingAddress.shippingCity 
                   && a.State__c   == MailingAddress.shippingState
                   && a.country__c == MailingAddress.shippingCountry 
                   && a.Zip__c     == MailingAddress.shippingPostalCode )
                {
                    a.isSame__c = true;
                    a.Blank__c = 'Same As Above';
                }
                else
                {
                    a.isSame__c = False;
                    a.Blank__c = ' ';
                }
                wrapSiteAddress wSA =   new  wrapSiteAddress(a);
                wrapSiteAddressList.add(wSA);
            }
        }
        if (wrapAccountContactList == null) {
            wrapAccountContactList = new List<wrapAccountContact>();
            List<Contact> relatedContacts = [SELECT Id, Name, Email FROM Contact WHERE AccountId = :accountId];
            for (Contact relatedContact : relatedContacts) {
                wrapAccountContact wrapContact = new wrapAccountContact(relatedContact);
                wrapAccountContactList.add(wrapContact);
            }
        }
    
    }

    

    
    public PageReference process(){
        setSelectedRecordId();
        for(wrapAccountProduct wrapAccountProductObj : wrapAccountProductList){
            wrapAccountProductObj.acc.is_Selected__c = wrapAccountProductObj.selected;
            
            system.debug('wrapAccountProductObj.acc.is_Selected__c ==== ' + wrapAccountProductObj.acc.is_Selected__c);
            if(wrapAccountProductObj.acc.is_Selected__c == True){
                if(wrapAccountProductObj.acc.Product_status__c == null || wrapAccountProductObj.acc.Product_status__c == ''){
                    displayError('Product Status');return null;  
                } else {return processSelected(); 
                }
            }
        }
        return null;
        
    }   
    
    
    public void next(){
       system.debug(pageNumber + ' - '+ pageSize + ' - ' + totalSize );
        //if(!((pageNumber + pageSize) > totalSize )){
            isShow = false;
            pageNumber = pageNumber + pageSize;
            system.debug('pageNumber next ' + pageNumber);
            setSelectedRecordId();
            getwrapAccountProductList();
        //}
        
        
    }   
    
    public void prev(){
        
        //if(pageNumber != 0 ){
            isShow = false;
            pageNumber = pageNumber - pageSize;
            system.debug('pageNumber prev ' + pageNumber);
            setSelectedRecordId();
            getwrapAccountProductList();
        //}
        
        
    }   


    public Boolean getPrv(){
        if(pageNumber == 0){return true;}else {return false;}
    }

    public Boolean getNxt(){
        if((pageNumber + pageSize) >= totalSize ){return true;}else {return false;}
    }



    
    // returns a list of wrapper objects for the sObjects in the current page set
    public List<wrapAccountProduct> getwrapAccountProductList() {
        //Integer Offset = (Integ;er.valueOf(pageNumber)-1) * pageSize;
       
        wrapAccountProductList = new List<wrapAccountProduct>();
        system.debug('DEBUG::'+SelectedIdMark);
        List<account_products__c> apList = new List<Account_Products__c>();
        if(SelectedIdMark == 'All Products'){
            apList = [SELECT id,Product__c,Customer_Type__c,Product_status__c,Standard__c,ID_Mark__c from account_products__c where Account__c = :accIdForPagination LIMIT : pagesize OFFSET : pageNumber];    
        }else{
			apList = [SELECT id,Product__c,Customer_Type__c,Product_status__c,Standard__c,ID_Mark__c from account_products__c where Account__c = :accIdForPagination AND ID_Mark__c =: SelectedIdMark  LIMIT : pagesize OFFSET : pageNumber];    
        }
        
        for(account_products__c a: apList) {
            boolean isSelected = false;
            if(selectedRecordsId.contains(a.id)){isSelected = true;
                system.debug('trueasd');
            }
            wrapAccountProductList.add(new wrapAccountProduct(a,isSelected));
        }
        system.debug('New products\n'+wrapAccountProductList);
       isShow = true;
        return wrapAccountProductList;
    }
    
    public void setSelectedRecordId(){
        for(wrapAccountProduct wrapAccountProductObj : wrapAccountProductList) {
            
            wrapAccountProductObj.acc.is_Selected__c = wrapAccountProductObj.selected;
            
            if(wrapAccountProductObj.acc.is_Selected__c == True){selectedRecordsId.add(wrapAccountProductObj.acc.id);
            }else{selectedRecordsId.remove(wrapAccountProductObj.acc.id);}
        }
    }

    
    public PageReference processSelected() {
        
        selectedAccountProducts = new List<account_products__c>();
        string url;
        //PageReference newPage;
        
        set<string> selectedCustomerType = new set<string>();
        
        set<string> selectedProductStatus = new set<string>();
        
        for(wrapAccountProduct wrapAccountProductObj : wrapAccountProductList) {
            if(selectedRecordsId.contains(wrapAccountProductObj.acc.id)){
               
                wrapAccountProductObj.acc.is_Selected__c = wrapAccountProductObj.selected;
            
            if(wrapAccountProductObj.acc.is_Selected__c == True){
                
              
                if(String.isNotBlank(wrapAccountProductObj.acc.Customer_Type__c) ==True){
                    
                    if(wrapAccountProductObj.acc.Customer_Type__c.toLowerCase().contains('crop') || wrapAccountProductObj.acc.Customer_Type__c.toLowerCase().contains('crops')){
                        selectedCustomerType.add('crops');
                    }
                    
                    if(wrapAccountProductObj.acc.Customer_Type__c.toLowerCase().contains('handler')){
                        selectedCustomerType.add('handler');
                    }
                    
                    if(wrapAccountProductObj.acc.Customer_Type__c.toLowerCase().contains('livestock')){
                        selectedCustomerType.add('livestock');
                    }
                    if(wrapAccountProductObj.acc.Customer_Type__c.toLowerCase().contains('wild crop')){
                        selectedCustomerType.add('wild crop');
                    }

                    
                } else{errorMessage = 'error';displayError('Customer Type');
                    system.debug('Field Customer Type is empty');
                }
                
                if(String.isNotBlank(wrapAccountProductObj.acc.Product_status__c) == True || string.isNotEmpty(wrapAccountProductObj.acc.Product_status__c) == True){
                    if(String.isNotBlank(wrapAccountProductObj.acc.Customer_Type__c) ==True &&(wrapAccountProductObj.acc.Customer_Type__c.toLowerCase().contains('crop') || wrapAccountProductObj.acc.Customer_Type__c.toLowerCase().contains('crops'))){
                        selectedProductStatus.add('crops' +' ' + wrapAccountProductObj.acc.Product_status__c.toLowerCase());
                    }
                } else{errorMessage = 'error';displayError('Product Status');
                    system.debug('Field Product Status is empty');
                }
                    
                if(String.isNotBlank(wrapAccountProductObj.acc.Customer_Type__c) ==True&&(wrapAccountProductObj.acc.Customer_Type__c.toLowerCase().contains('handler'))){
                    if(wrapAccountProductObj.acc.Product_status__c != '' || wrapAccountProductObj.acc.Product_status__c != null ){
                        selectedProductStatus.add('handler' +' ' + wrapAccountProductObj.acc.Product_status__c.toLowerCase());
                        /*system.debug('line >>>> 131');*/
                    } else{errorMessage = 'error';displayError('Customer Type');
                        system.debug('line 134 else Product status is empty');
                    }
                } 
                
                if(String.isNotBlank(wrapAccountProductObj.acc.Customer_Type__c) ==True&&(wrapAccountProductObj.acc.Customer_Type__c.toLowerCase().contains('livestock'))){
                    if(wrapAccountProductObj.acc.Product_status__c != '' || wrapAccountProductObj.acc.Product_status__c != null){
                        selectedProductStatus.add('livestock' +' ' + wrapAccountProductObj.acc.Product_status__c.toLowerCase());
                    } 
                }
				if(String.isNotBlank(wrapAccountProductObj.acc.Customer_Type__c) ==True&&(wrapAccountProductObj.acc.Customer_Type__c.toLowerCase().contains('wild crop'))){
                    if(wrapAccountProductObj.acc.Product_status__c != '' || wrapAccountProductObj.acc.Product_status__c != null){
                        selectedProductStatus.add('wild crop' +' ' + wrapAccountProductObj.acc.Product_status__c.toLowerCase());
                    } 
                }
            }
            selectedAccountProducts.add(wrapAccountProductObj.acc);
            }
            
        }
        
        if(errorMessage != 'error'){    
           
            system.debug(allAccountProductList.size()+'Before Update\nselectedRecordsId: '+selectedRecordsId+'\nselectedAccountProducts: '+selectedAccountProducts);
           
            List<account_products__c> SelectedList =new List<account_products__c>();
            List<account_products__c> notSelectedList =new List<account_products__c>();
            for(account_products__c a : allAccountProductList){
                if(selectedRecordsId.contains(a.id)){a.is_Selected__c = true;SelectedList.add(a);                    
                }else
                    a.is_Selected__c = false;
                    notSelectedList.add(a);
            }
            system.debug('SelectedList'+SelectedList.size());
            system.debug('notSelectedList'+notSelectedList.size());
            update notSelectedList;
            update SelectedList;
            
            
        }
        selectedSiteAddresses = new List<Site_Address__c>();
        
        for(wrapSiteAddress wrapSiteAddressObj : wrapSiteAddressList) {
            
            wrapSiteAddressObj.Siteadd.is_Selected__c = wrapSiteAddressObj.selected;
            
            selectedSiteAddresses.add(wrapSiteAddressObj.Siteadd);
            
        }
        
        if(errorMessage != 'error'){
            update selectedSiteAddresses;
        }
        
        string custTypeplValue='';
        
        if(errorMessage != 'error'){
            for(string customerType: selectedCustomerType){custTypeplValue+=  customerType +';';
                
            }    
        }
        
        
        selectedAccountContact = new List<Contact>();
        for (wrapAccountContact wrapAccountContactObj : wrapAccountContactList) {
            wrapAccountContactObj.cc.IsSelected__c = wrapAccountContactObj.selected;
            selectedAccountContact.add(wrapAccountContactObj.cc);
        }

        if (errorMessage != 'error') {
            update selectedAccountContact;
        }
        
        string ProStatplValue='';
        if(errorMessage != 'error'){
            for(string productStatus: selectedProductStatus){ProStatplValue+=  productStatus +';';}
        }
        
        system.debug('line 183 helloowww');
        if( errorMessage != 'error'){
            system.debug('line 182 no error');
            Certificate__c certToUpdate = new Certificate__c(id=currentRecordId);
            certToUpdate.Selected_Customer_Type__c = custTypeplValue;
            certToUpdate.Selected_Product_Status__c = ProStatplValue;
            
            update certToUpdate;
            
            url='/apex/SDOC__SDCreate1?id='+currentRecordId+'&Object=Certificate__c&doclist='+ documentID;
            PageReference newPage = new PageReference(url); // This will be the visualforce page or Url that we want to redirect to
            newPage.setRedirect(true);
            return newPage;
        } else {
            system.debug('line 182 error');
            //displayError('Product Status');
            
            return null;
               
        }
    }
   
    // This is our wrapper/container class. In this example a wrapper class contains both the standard salesforce object Account and a Boolean value
   		public class wrapAccountProduct {
        public account_products__c acc {get; set;}
        public Boolean selected {get; set;}
        
        public wrapAccountProduct(account_products__c a) {
            a.is_Selected__c= false;
            acc = a;
            selected = false;
        }

        public wrapAccountProduct(account_products__c a,boolean isSelected) {
            a.is_Selected__c= isSelected;
            acc = a;
            selected = isSelected;
        }
    }
    public class wrapSiteAddress {
        public Site_Address__c Siteadd {get; set;}
        public Boolean selected {get; set;}
        public Boolean isSame {get; set;}
        public wrapSiteAddress (Site_Address__c a) {
            
             a.is_Selected__c=true;
            Siteadd = a;
            selected = true;
        }
    }
    
    public class wrapAccountContact {
        public Contact cc {get; set;}
        public Boolean selected {get; set;}
        public wrapAccountContact(Contact c) {
            c.IsSelected__c = false;
            cc = c;
            selected = false;
        
    }
    }


   
    
    public PageReference GetAccountProducts()
    {
        system.debug('DEBUG::' + SelectedIdMark);
 		List<Account_Products__c> apList = new List<Account_Products__c>();
        if(SelectedIdMark == 'All Products'){
            System.debug('if'+ SelectedIdMark);
           apList = [SELECT id,Product__c,Customer_Type__c,Product_status__c,Standard__c,ID_Mark__c from account_products__c where Account__c =: m_AccountId 
                                       LIMIT : pagesize OFFSET : pageNumber ];
        }else{
            System.debug('else'+ SelectedIdMark);
           apList = [SELECT id,Product__c,Customer_Type__c,Product_status__c,Standard__c,ID_Mark__c from account_products__c where Account__c =: m_AccountId 
                                        AND ID_Mark__c =: SelectedIdMark LIMIT : pagesize OFFSET : pageNumber ]; 
        }
        for(account_products__c a:apList ) {            
                wrapAccountProductList.add(new wrapAccountProduct(a));
            }
        
        return null;
    }
    
}