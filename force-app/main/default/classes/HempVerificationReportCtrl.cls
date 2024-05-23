public class HempVerificationReportCtrl {

    private final Verification_Report__c m_VerificationReport;
    public string ReportAddress1to4 {get; private set;}
    public string Background {get;private set;}
    public HempVerificationReportCtrl(ApexPages.StandardController aVerificationReportController)
    {
        m_VerificationReport = (Verification_Report__c)aVerificationReportController.getRecord();
        
        for(Verification_Report__c vr : [SELECT Background_and_Scope_of_Audit__c, Address_1__c , Address_2__c ,Address_3__c ,Address_4__c FROM Verification_Report__c WHERE Id =: m_VerificationReport.Id])
        {
            ReportAddress1to4 = vr.Address_1__c + '\n' +
                                                vr.Address_2__c + '\n' +
                                                vr.Address_3__c + '\n' +
                                                vr.Address_4__c;  
            Background = vr.Background_and_Scope_of_Audit__c;
            break;
        }
        
    }
    
    public list<Non_Conformity__c> getNonConformities()
    {
        return [SELECT Id, Name, NC_Description__c, Corrective_Actions_Due_Date__c FROM Non_Conformity__c WHERE Verification_Report__c =: m_VerificationReport.Id];
    }
    
}