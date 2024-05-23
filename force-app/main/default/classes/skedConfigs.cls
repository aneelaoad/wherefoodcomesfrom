public class skedConfigs {
	public static String GOOGLE_API_KEY{
        get{
            if(GOOGLE_API_KEY == null){
                if(skedConfigs__c.getAll().containsKey('Google_API_KEY')){
                    GOOGLE_API_KEY     = skedConfigs__c.getAll().get('Google_API_KEY').Value__c;
                }else GOOGLE_API_KEY   = '';
            }
            return GOOGLE_API_KEY;
        }
    }

    public static String OPPORTUNITY_CARD_COLOR{
        get{
            if(OPPORTUNITY_CARD_COLOR == null){
                if(skedConfigs__c.getAll().containsKey('Opportunity_Card_Color')){
                    OPPORTUNITY_CARD_COLOR     = skedConfigs__c.getAll().get('Opportunity_Card_Color').Value__c;
                }else OPPORTUNITY_CARD_COLOR   = '#FFFFFF';
            }
            return OPPORTUNITY_CARD_COLOR;
        }
    }

    public static String JOB_CARD_COLOR{
        get{
            if(JOB_CARD_COLOR == null){
                if(skedConfigs__c.getAll().containsKey('Job_Card_Color')){
                    JOB_CARD_COLOR     = skedConfigs__c.getAll().get('Job_Card_Color').Value__c;
                }else JOB_CARD_COLOR   = '#FFFFFF';
            }
            return JOB_CARD_COLOR;
        }
    }

    public static String EXCLUDED_JOB_STATUSES{
        get{
            if(EXCLUDED_JOB_STATUSES == null){
                if(skedConfigs__c.getAll().containsKey('Excluded_Job_Statuses')){
                    EXCLUDED_JOB_STATUSES     = skedConfigs__c.getAll().get('Excluded_Job_Statuses').Value__c;
                }else EXCLUDED_JOB_STATUSES   = '';
            }
            return EXCLUDED_JOB_STATUSES;
        }
    }

    public static String EXCLUDED_OPPORTUNITY_STATUSES{
        get{
            if(EXCLUDED_OPPORTUNITY_STATUSES == null){
                if(skedConfigs__c.getAll().containsKey('Excluded_Opportunity_Statuses')){
                    EXCLUDED_OPPORTUNITY_STATUSES     = skedConfigs__c.getAll().get('Excluded_Opportunity_Statuses').Value__c;
                }else EXCLUDED_OPPORTUNITY_STATUSES   = '';
            }
            return EXCLUDED_OPPORTUNITY_STATUSES;
        }
    }
}