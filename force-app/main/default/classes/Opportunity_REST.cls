@RestResource(urlMapping='/opportunities/*')
global class Opportunity_REST {
    
    global class RESTError
    {
        public string ExceptionType{get;set;}
        public string ErrorMessage{get;set;}

		public RESTError(string aExceptionType, string aErrorMessage)
        {
            ExceptionType = aExceptionType;
            ErrorMessage = aErrorMessage;
        }
        
        public RESTError(Exception aException)
        {
            ExceptionType = aException.getTypeName();
            ErrorMessage = aException.getMessage() + '\n' + aException.getStackTraceString();
        }
    }
    
    global class ShippingCertificate
    {
        public string SfdcId {get;set;}
        public string IMICustomerID {get;set;}
        public string GroupName {get;set;}
        public string CertificateNumber{get;set;}
        public integer NumberOfHeadApproved{get;set;}
        public Date ApprovedDate {get;set;}
        public string SourceOfOriginIdentification {get;set;}
        public Date FirstCalfBornDate{get;set;}
        public date ThirtyMonthHarvestByDate {get;set;}
        
        
        public ShippingCertificate(string aIMICustomerID, Certificate__c aCertificate)
        {
            SfdcId = aCertificate.Id;
            IMICustomerID = aIMICustomerID;
            GroupName = aCertificate.Group_Name__c;
            CertificateNumber = aCertificate.Certificate_Number__c;
            NumberOfHeadApproved = integer.valueOf(aCertificate.Head_Count__c);
            ApprovedDate = aCertificate.Approval_Date__c;
            SourceOfOriginIdentification = aCertificate.Source_of_Origin__c;
            FirstCalfBornDate = aCertificate.First_Calf_Born_Date__c;
            ThirtyMonthHarvestByDate = aCertificate.X30_Month_Harvest_by_Date_Shipping__c;
        }
    }
    
    global class TagManifest
    {
        public string EIDTag{get;set;}
        
        public TagManifest (TagOrderLineTag__c aTag)
        {
            EIDTag = aTag.EID__c;
        }
    }
    
    global class Producer
    { 
       // private Id AccountId{get;set;}
        public string SfdcId {get;set;}
        public string OpportunityName {get;set;}
        public string IMICustomerID {get;set;} //Account.ClientID
        public string RanchProducerName {get;set;} //Account.Name
        public string PrimaryContact{get;set;} //Account.Primary_Contact2
        public string Phone{get;set;}//Account.Phone
        public string Email{get;set;} //Account.Email
        public string VerificationOwner; //Account.Verification_Owner
        public string MailingStreetAddress {get;set;} 
        public string MailingCity{get;set;}
        public string MailingState{get;set;}
        public string MailingZip {get;set;}
        public datetime CreatedDateTime {get;set;}
        public datetime UpdatedDateTime {get;set;}
        
        //private string OpportunityId {get;set;}
        //private string Name {get;set;}
        public boolean AgeVerification {get;set;}
		public boolean NHTC {get;set;}
        public boolean GAP {get;set;}
        public boolean SourceVerification {get;set;}
        public boolean VerifiedNaturalBeef {get;set;}
        public boolean VerifiedPrimePursuits {get;set;}
        public boolean ApprovalStatus {get;set;}
        public Date ApprovalDate {get;set;}
        
        
        public list<ShippingCertificate> ShippingCertificates{get;set;}
        
        public list<TagManifest> TagManifests {get;set;}     
        
        public Producer(Account aAccount, Opportunity aOpportunity)
        {
            SfdcId = aOpportunity.Id;
            CreatedDateTime = aOpportunity.CreatedDate;
            UpdatedDateTime = aOpportunity.LastModifiedDate;
            IMICustomerID = aOpportunity.Account.SF_Client_ID__c;
            OpportunityName = aOpportunity.Name;
            RanchProducerName = aOpportunity.Account.Name;
            PrimaryContact = aOpportunity.Account.Primary_Contact2__r.LastName;
            Phone = aOpportunity.Account.Phone;
            Email = aOpportunity.Account.Account_Email__c;
            VerificationOwner = aOpportunity.Account.Verification_Owner__c;
            MailingStreetAddress = aOpportunity.Mailing_Street__c;
            MailingCity = aOpportunity.Account.ShippingCity;
            MailingState = aOpportunity.Account.ShippingState;
            MailingZip = aOpportunity.Mailing_Zip__c;
            
            //OpportunityId = aOpportunity.Id;
            //Name = aOpportunity.Name;
			AgeVerification =	aOpportunity.Programs_Claims_Umbrella__c.contains('Age Verification');
			NHTC =	aOpportunity.Programs_Claims_Umbrella__c.contains('NHTC');
            string gapValues = aOpportunity.Programs_Claims_GAP__c;
			if (gapValues != null)
            	GAP = gapValues.contains('GAP Collection Point') || gapValues.contains('GAP Step 1') || gapValues.contains('GAP Step 2') || gapValues.contains('GAP Step 3') || gapValues.contains('GAP Step 4') || gapValues.contains('GAP Step 5') || gapValues.contains('GAP Step 5+');
            else
                GAP = false;
			SourceVerification =	aOpportunity.Programs_Claims_Umbrella__c.contains('Source Verification');
			VerifiedNaturalBeef = aOpportunity.Programs_Claims_Umbrella__c.contains('Verified Natural Beef');
			VerifiedPrimePursuits =	 aOpportunity.Programs_Claims_Umbrella__c.contains('Prime Pursuits');
			ApprovalStatus = AgeVerification || NHTC || GAP || SourceVerification || VerifiedNaturalBeef || VerifiedPrimePursuits; 
            
            if (GAP == true)
            	ApprovalDate = aOpportunity.Approval_Completion_Date_GAP__c;
            else 
                ApprovalDate = aOpportunity.Approval_Completion_Date_Umbrella__c;
            
            ShippingCertificates = new list<ShippingCertificate>();
            TagManifests = new list<TagManifest>();
        }
        
        public void getCertificates()
        {
            /*set<Id> optyIds = new set<Id>();
            map<Id, IMIOpportunity> imiOpportunityById = new map<Id, IMIOpportunity>();
            
            for(IMIOpportunity opty: Opportunities)
            {
                optyIds.add(opty.Id);
                imiOpportunityById.put(opty.Id, opty);
            }
            
            for(Certificate__c cert: [SELECT Id, Name, RecordType.DeveloperName, Opportunity_Name__c FROM Certificate__c WHERE Opportunity_Name__c IN: OptyIds])
            {
                IMICertificate imicert = new IMICertificate();
                imicert.Id = cert.Id;
                imicert.Name = cert.Name;
                imicert.RecordType = cert.RecordType.DeveloperName;
                imiOpportunityById.get(cert.Opportunity_Name__c).Certificates.add(imicert);
            }*/
        }
    }
    
   global class Producers
   {
       public list<Producer> Producers{get;set;}
       public RESTError Error {get;set;}
       
       public Producers()
       {
           Producers = new list<Producer>();
           Error = null;
       }
   }
      
    
    private static boolean Authenticate()
    {
        return true;
    }
    
    public static string unittesting_clientSecret {get;set;} //for unittesting 
    public static string unittesting_fromDate {get;set;} //for unittesting 
    
	@HttpGet
    global static Producers getOpportunity()
    {
        Producers returnProducer = new Producers();
        
        try
        {
            Account imiAcc = null;
            if (Authenticate() == true)
            {
                string clientSecret = '';
                
                if(test.isRunningTest() == false)
                	clientSecret = RestContext.request.params.get('clientSecret');
                else
                    clientSecret = unittesting_clientSecret;
                string accountId = null;
                
                string fromDt = unittesting_fromDate;
                if(test.isRunningTest() == false)
                    fromDt = RestContext.request.params.get('fromDate');
                
                Date fromDate = Date.newInstance(1900, 1, 1);
                
                if (fromDt != null)
                    fromDate = Date.valueOf(fromDt);
                
                system.debug('JMA::DEBUG:: Client secret : ' + clientSecret);
                Id subscriptionId = null;
                for(Prime_Pursuits_API_Subscription__c api: [SELECT Id, Account__c FROM Prime_Pursuits_API_Subscription__c WHERE Client_Secret__c =: clientSecret AND Active__c =: true ])
                {
                	accountId = api.Account__c;    
                    subscriptionId = api.id;
                    break;
                }
                
                string remoteAddress = '127.0.0.1';
                string params = 'dummy';
				if (Test.isRunningTest() == false)
                {
                    remoteAddress = RestContext.request.remoteAddress;
                    params = string.valueOf(RestContext.request.params);
                }
                
                if (accountId == null)
                {
                    RESTError error = new RESTError('Subscription Error', 'No valid subscription found for the client secret ' + clientSecret);
                    returnProducer.Error = error;
                    
                    Prime_Pursuits_API_Log__c log = new Prime_Pursuits_API_Log__c();
                    log.Prime_Pursuits_API_Subscription__c = subscriptionId;
                    log.IP_Address__c = remoteAddress;
                    log.Parameters__c = params;
                    insert log;
                }
                else
                {
                    map<string,Producer> producerByOptyId = new map<string,Producer>();
                    
                    //creating log
                    Prime_Pursuits_API_Log__c log = new Prime_Pursuits_API_Log__c();
                    log.Prime_Pursuits_API_Subscription__c = subscriptionId;
                    log.IP_Address__c = remoteAddress;
                    log.Parameters__c = params;
                    insert log;
                     
                    Account acc = [SELECT Id, Name, Client_ID__c, Primary_Contact2__c, Primary_Contact2__r.LastName, Phone, Account_Email__c, Verification_Owner__c, ShippingCity, ShippingState FROM Account WHERE Id =: accountId];
                    
                    set<string> stageOfWorkUmbrellaNotAllowed = new set<string>();
                    stageOfWorkUmbrellaNotAllowed.add(null);
                    stageOfWorkUmbrellaNotAllowed.add('');
                    stageOfWorkUmbrellaNotAllowed.add('sales');
                    
                    list<Producer> producers = new list<Producer>();
                    if (acc != null)
                    {
                        //list<Opportunity> opportunities = [SELECT Id, Name, StageName, Mailing_Street__c, Mailing_Zip__c,Programs_Claims_Umbrella__c,Programs_Claims_GAP__c,Approval_Status_Umbrella__c, Approval_Status_GAP__c,Approval_Completion_Date_GAP__c,Approval_Completion_Date_Umbrella__c FROM Opportunity  WHERE (Programs_Claims__c INCLUDES ('Prime Pursuits') OR Programs_Claims_umbrella__c INCLUDES ('Prime Pursuits') OR Programs_Claims_gap__c INCLUDES ('Prime Pursuits') OR Programs_Claims_other__c INCLUDES ('Prime Pursuits') ) AND LastModifiedDate >= : fromDate /*limit 15000*/];
                        //Name, Client_ID__c, Primary_Contact2__c, Primary_Contact2__r.LastName, Phone, Account_Email__c, Verification_Owner__c, ShippingCity, ShippingState
                        //(Programs_Claims__c INCLUDES ('Prime Pursuits') OR Programs_Claims_umbrella__c INCLUDES ('Prime Pursuits') OR Programs_Claims_gap__c INCLUDES ('Prime Pursuits') OR Programs_Claims_other__c INCLUDES ('Prime Pursuits') ) AND
						list<Opportunity> opportunities = [SELECT AccountId, Account.Name, Account.Client_ID__c, Account.SF_Client_ID__c, Account.Primary_Contact2__c, Account.Primary_Contact2__r.LastName, Account.Phone, Account.Account_Email__c, Account.Verification_Owner__c, Account.ShippingCity, Account.ShippingState, Id, Name, StageName, Mailing_Street__c, Mailing_Zip__c,Programs_Claims_Umbrella__c,Programs_Claims_GAP__c,Approval_Status_Umbrella__c, Approval_Status_GAP__c,Approval_Completion_Date_GAP__c,Approval_Completion_Date_Umbrella__c , CreatedDate, LastModifiedDate
                                                           FROM Opportunity  WHERE 
                                                           Programs_Claims_Umbrella__c INCLUDES ('Prime Pursuits') 
                                                           AND Release_Form_on_File__c =: 'Yes' 
                                                           AND LastModifiedDate >= : fromDate 
                                                           AND Stage_of_Work_Umbrella__c NOT IN: stageOfWorkUmbrellaNotAllowed/*limit 15000*/];
                        for(Opportunity opty: opportunities)
                        {
                            Producer prod = new Producer(acc, opty);
                            producers.add(prod);
                            producerByOptyId.put(opty.Id, prod);
                        }
                        
                        //querying shipping certificates
                        map<string, list<ShippingCertificate>> certificateByOptyId = new map<string,list<ShippingCertificate>>();
                        for(Certificate__c cert: [SELECT Id, Name, Opportunity_Name__c, Group_Name__c, Certificate_Number__c, Head_Count__c, Approval_Date__c,  Source_of_Origin__c, First_Calf_Born_Date__c, X30_Month_Harvest_by_Date_Shipping__c FROM Certificate__c WHERE Opportunity_Name__c IN: producerByOptyId.keySet()  /*limit 15000*/])
                        {            
                            Producer prod = producerByOptyId.get(cert.Opportunity_Name__c);
                            
                            ShippingCertificate shipCert = new ShippingCertificate(prod.IMICustomerId, cert);
                            
                            if (certificateByOptyId.get(cert.Opportunity_Name__c) == null)
                                certificateByOptyId.put(cert.Opportunity_Name__c, new list<ShippingCertificate>());
                            
                            certificateByOptyId.get(cert.Opportunity_Name__c).add(shipCert);
                            
                            prod.ShippingCertificates = certificateByOptyId.get(cert.Opportunity_Name__c);
                        }
                        
                        //populating Tag Lines
                        map<string, list<TagManifest>> tagsByOptyId = new map<string,list<TagManifest>>();
                        for(TagOrderLineTag__c lineTag : [SELECT Id, Name, EID__c, TagOrderLineItem__r.TagOrder__r.Opportunity__c FROM TagOrderLineTag__c WHERE TagOrderLineItem__r.TagOrder__r.Opportunity__c IN:  producerByOptyId.keySet()  /*limit 15000*/])
                        {
                            TagManifest tag = new TagManifest(lineTag);
                            
                            id OptyId = lineTag.TagOrderLineItem__r.TagOrder__r.Opportunity__c;
                            
                            if (tagsByOptyId.get(optyId) == null)
                                tagsByOptyId.put(OptyId, new list<TagManifest>());
                            
                            tagsByOptyId.get(OptyId).add(tag);
                            
                            producerByOptyId.get(optyID).TagManifests = tagsByOptyId.get(OptyId);
                        }
                        
                        Producers producerContainer = new Producers();
                        producerContainer.producers = producers;
                        returnProducer = producerContainer;
                    }
                }
                    
            }
            
        }
        catch(Exception ex)
        {
        	RESTError error = new RESTError(ex);
        	returnProducer.Error = error;
        }
        
        //string json =   JSON.serialize(returnObj);
        //json = json.remove('\\');
        //return json;
        return returnProducer;        
    }
}