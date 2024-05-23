public class UpdateTextFieldBasedOnMPHelper {

public static void updateTextAreaField (Verification_Report__c[] VReports){
        for(Verification_Report__c vr: VReports){        
            String pickValuesStr;
			if(!String.isBlank(vr.Supporting_Documentation__c)){
				List<String> pickValues = vr.Supporting_Documentation__c.split(';');
				for(String str : pickValues){
					if(String.isBlank(pickValuesStr)){
						pickValuesStr ='• ' + str;
					}
					else{
						pickValuesStr += '\n' +'• ' +  str;
					}
				}
			}
			vr.Supporting_Documentation_Text__c = pickValuesStr;  
        }
    }
}