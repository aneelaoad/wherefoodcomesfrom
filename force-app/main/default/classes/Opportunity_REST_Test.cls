@isTest
public class Opportunity_REST_Test {
    
    public static Account acc;
    public static Prime_Pursuits_API_Subscription__c api;
    
    public static void initializeTestEnvironment()
    {        
        acc = new Account();
        acc.Name = 'test123123123';
        acc.BillingState = 'PK';
        insert acc;
        
        api = new Prime_Pursuits_API_Subscription__c();
        api.Account__c = acc.id;
        api.Active__c = true;
        insert api;
        
        api = [SELECT Id, Active__c, Account__c, Client_Secret__c FROM Prime_Pursuits_API_Subscription__c WHERE Account__c =: acc.Id];
        
        Contact cont = new Contact();
        cont.LastName = 'testContact';
        cont.AccountId = acc.Id;
        insert cont;
        
        acc.Primary_Contact2__c = cont.Id;
        update acc;
        
        Opportunity opty = new Opportunity();
        opty.AccountId = acc.Id;
        opty.Name = 'test';
        opty.StageName = 'New';
        opty.CloseDate = Date.today();
        opty.Opportunity_Status__c = 'New';
        opty.Programs_Claims_Umbrella__c = 'Prime Pursuits';
        opty.Release_Form_on_File__c = 'Yes';
        opty.Stage_of_Work_Umbrella__c = 'pre-review';
        insert opty;    
        
        Certificate__c cert = new Certificate__c();
        cert.Name = 'tttt';
        cert.Opportunity_Name__c = opty.Id;
        insert cert;
        
        Product2 prod = new Product2();
        prod.Name = 'testProd';
        insert prod;
        
        Id devRecordTypeId = Schema.SObjectType.Tag_Order__c.getRecordTypeInfosByName().get('Tag Order').getRecordTypeId();
         Tag_Order__c tagorder = new Tag_Order__c(
            Name = 'CS Production Test Order3234243',                        // Tag Order Name
            Opportunity__c = opty.id,                          // Opportunity
            Vendor__c = 'AllFlex',                                       // Vendor
            Tags_Ordered__c = Date.today(),                            // AllFlex Sync Message
            Status__c = 'Ready to Send' ,
            recordTypeId = devRecordTypeId// Status
        );
        insert tagorder;
        
        TagOrderLineItem__c line = new TagOrderLineItem__c(
            Name = 'test line2324',             // Tag Order Line Item Name
            Product__c = prod.id,   // Products
            Quantity__c = 1000,               // Quantity
            Unit_Price__c = 2.25,             // Unit Price
            TagOrder__c = tagorder.Id  // Tag Order
        );
        insert line;
        
        TagOrderLineTag__c tag = new TagOrderLineTag__c(
            EID__c = '911234',                           // EID
            SerialNumber__c = '234230',                    // Serial Number
            Management__c = 'MN9',                    // Management
            TagOrderLineItem__c = line.id,  // Tag Order Line Item
            ContainerId__c = 'case',                  // ContainerId
            InnerContainerId__c = 'B1'               // InnerContainerId
        );
        insert tag;
    }
    
    @isTest(seealldata=true) //for recordtype
    public static void testOpportunityRESTExceptions()
    {
        initializeTestEnvironment();
        
        string prefix = '';
        
        Opportunity_REST.unittesting_clientSecret = null;
        Opportunity_REST.getOpportunity();
        
        Opportunity_REST.unittesting_clientSecret = api.Client_Secret__c;
        Opportunity_REST.unittesting_fromDate = 'dummydate';
        Opportunity_REST.getOpportunity();
        
        //testing Opportunity_RESTv2
        Opportunity_RESTv2.unittesting_clientSecret = null;
        Opportunity_RESTv2.getOpportunity();
        
        Opportunity_RESTv2.unittesting_clientSecret = api.Client_Secret__c;
        Opportunity_RESTv2.unittesting_fromDate = 'dummydate';
        Opportunity_RESTv2.getOpportunity();
                
        /* //can't test in proper RestContext way, as during the deployment, the Opportunity_REST class won't deployed on the SITE.
        Site site = [SELECT GuestUserId, Name, Subdomain, UrlPathPrefix FROM Site WHERE Name = :'Prime_Pursuits_API'];
        Organization org = [SELECT InstanceName, IsSandbox, OrganizationType FROM Organization WHERE isSandBox =: true];
    
        if (org.issandbox == true)
            prefix = '4wavesdev-';
        
        String siteFullUrl = 'https://' + prefix + site.Subdomain + '.';
        siteFullUrl += (org.IsSandbox || org.OrganizationType == 'Developer Edition' ? (org.InstanceName.toLowerCase() + '.') : '') + 'force.com';
        siteFullUrl += '/' + site.UrlPathPrefix;
        
        RestRequest req = new RestRequest(); 
        req.requestURI = siteFullUrl + '/services/apexrest/opportunities';  // sample Endpoint
    	req.httpMethod = 'GET';
        req.addParameter('clientSecret', api.Client_Secret__c);
        req.addParameter('fromDate', 'invaliddateformat');
        
        RestResponse res = new RestResponse();
        
        RestContext.request = req;
   		RestContext.response= res;
        
        system.debug('JMA::DEBUG::URI --> ' + req.requestURI );
        system.debug('JMA::DEBUG::Client Secret (TEST) --> ' + api.Client_Secret__c );

 		Opportunity_REST.getOpportunity();
        */
       
        
    }
    
    @isTest(seealldata=true) //for recordype
    public static void testOpportunityREST()
    {
        initializeTestEnvironment();
                
        Opportunity_REST.unittesting_clientSecret = api.Client_Secret__c;
        Opportunity_REST.unittesting_fromDate = string.valueOf(date.today());
        Opportunity_REST.getOpportunity();
        
        Opportunity_REST.unittesting_clientSecret = 'invalid_secret_key';
        Opportunity_REST.unittesting_fromDate = string.valueOf(date.today());
        Opportunity_REST.getOpportunity();
        
        //test Opportunity_RESTv2
        Opportunity_RESTv2.unittesting_clientSecret = api.Client_Secret__c;
        Opportunity_RESTv2.unittesting_fromDate = string.valueOf(date.today());
        Opportunity_RESTv2.getOpportunity();
        
        Opportunity_RESTv2.unittesting_clientSecret = 'invalid_secret_key';
        Opportunity_RESTv2.unittesting_fromDate = string.valueOf(date.today());
        Opportunity_RESTv2.getOpportunity();
                
        /* //can't test in proper RestContext way, as during the deployment, the Opportunity_REST class won't deployed on the SITE.
        string prefix = '';
        
        Site site = [SELECT GuestUserId, Name, Subdomain, UrlPathPrefix FROM Site WHERE Name = :'Prime_Pursuits_API'];
        Organization org = [SELECT InstanceName, IsSandbox, OrganizationType FROM Organization WHERE isSandBox =: true];
    
        if (org.issandbox == true)
            prefix = '4wavesdev-';
        
        String siteFullUrl = 'https://' + prefix + site.Subdomain + '.';
        siteFullUrl += (org.IsSandbox || org.OrganizationType == 'Developer Edition' ? (org.InstanceName.toLowerCase() + '.') : '') + 'force.com';
        siteFullUrl += '/' + site.UrlPathPrefix;
        
        RestRequest req = new RestRequest(); 
        req.requestURI = siteFullUrl + '/services/apexrest/opportunities';  // sample Endpoint
    	req.httpMethod = 'GET';
        req.addParameter('clientSecret', api.Client_Secret__c);
        
        RestResponse res = new RestResponse();
        
        RestContext.request = req;
   		RestContext.response= res;
        
        system.debug('JMA::DEBUG::URI --> ' + req.requestURI );
        system.debug('JMA::DEBUG::Client Secret (TEST) --> ' + api.Client_Secret__c );
        
        Opportunity_REST.getOpportunity();
        */
    }
    
}