public class DropboxApiConnection {
        //dropbox URLs
        public static final String DROPBOX_URL = 'https://www.dropbox.com/1/'; //authorization domain
        public static final String DROPBOX_API_URL = 'https://api.dropbox.com/1/'; //rest of the API calls domain
        public static final String DROPBOX_FILE_UPLOAD_URL = 'https://content.dropboxapi.com/2/files/upload'; //URL for uploading file
        public static final String DROPBOX_TOKEN_ENDPOINT = 'oauth2/token'; //rest of the API calls domain
        
        public string RefreshTokenUrl {get; set;}
        
	 	// Dropbox credentials
        public final String DB_CLIENT_ID;
        public final String DB_CLIENT_SECRET;
        public String ORG_DOMAIN_URL {get; set;} //URL of current salesforce org

        //Dropbox tokens
        private String accessToken { get; set; } //recieved in return for auth code
        private String refreshToken { get; set; } //refresh token to store and retrieve access token 
        //private String authCode { get; set; } //code returned in URL in after logging in dropbox 

        /*
        Instance of this class that will be called in DropboxIntegrationBatch to set
        the tokens retrieved from CustomMetaData class 
        */
        public DropboxApiConnection(String accessTokenp, String refreshTokenp, String clientIdp, String clientSecretp){
            this.accessToken = accessTokenp;
            this.refreshToken = refreshTokenp;
            this.DB_CLIENT_ID = clientIdp;
            this.DB_CLIENT_SECRET = clientSecretp;
            //this.authCode = ApexPages.currentPage().getParameters().get('code');
        }

        public void refreshToken(){
            DropboxApiRequest request = new DropboxApiRequest(
                this,
                this.getRefreshTokenUrl(),
                DropboxApiRequest.METHOD_POST
            );
           
            string basicAuthValue = request.setBasicAuthentication(DB_CLIENT_ID, DB_CLIENT_SECRET);
            request.setHeader('Authorization', basicAuthValue);
            //request.trySend();
        }
        
        /*
        Set URL and use for redirecting Dropbox Auth to our org.
        returns the Domain URL of the current Salesforce Organisation  
         */
        public string getOrgDomainURL(){
            this.ORG_DOMAIN_URL = string.format('https://{0}/', 
                new List<string>{URL.getOrgDomainUrl().getHost()}); // URL of salesforce org
            return ORG_DOMAIN_URL;
        }
        
         public String getRefreshToken(){
            return this.refreshToken;
        }

        public string setRefreshTokenUrl(){
            //set refresh token url
            this.refreshTokenUrl  = String.format('{0}{1}?grant_type=refresh_token&refresh_token={2}', 
                                        new List<String>{DROPBOX_API_URL,DROPBOX_TOKEN_ENDPOINT,this.getRefreshToken()
                                            });
            return refreshTokenUrl;
        }
        
        public string getRefreshTokenUrl(){
            return refreshTokenUrl;
        }
        
        public string getAccessToken(){
            return this.accessToken;
        }
     }