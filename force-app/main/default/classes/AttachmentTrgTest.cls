/*
Created By : Muhammad Jawwad
Created Date :11/11/2020
description : Test coverage of AttachmentTrg
*/
@isTest
public class AttachmentTrgTest {
    
    static testMethod void testMethod1() 
	{
        Id MinorNCrecordTypeId = Schema.SObjectType.Verification_Report__c.getRecordTypeInfosByName().get('WFCFO Minor NC Verification Report').getRecordTypeId();
        
    	Verification_Report__c ObjVR = new Verification_Report__c();
        ObjVR.RecordTypeId = MinorNCrecordTypeId;
        ObjVR.Name  = 'Test';
        insert ObjVR;
 		
        Test.StartTest(); 
        Attachment attach=new Attachment();   	
    	attach.Name= ObjVR.Name  = '.pdf';
    	Blob bodyBlob=Blob.valueOf('Testing Body of Attachment');
    	attach.body=bodyBlob;
        attach.parentId=ObjVR.id;
        insert attach;
    	Test.StopTest();
        
    	List<Attachment> attachments=[select id, name from Attachment where parent.id=:ObjVR.id];
    	System.assertEquals(1, attachments.size());
    }
    static testMethod void testMethod2() 
	{
        Id MinorNCrecordTypeId = Schema.SObjectType.Verification_Report__c.getRecordTypeInfosByName().get('WFCFO Minor NC Verification Report').getRecordTypeId();
        
    	Verification_Report__c ObjVR = new Verification_Report__c();
        ObjVR.RecordTypeId = MinorNCrecordTypeId;
        ObjVR.Name  = 'Test Resolution';
        insert ObjVR;
 		
        Test.StartTest(); 
        Attachment attach=new Attachment();   	
    	attach.Name= ObjVR.Name  =' – Resolution Notice.pdf';
    	Blob bodyBlob=Blob.valueOf('Testing Body of Attachment');
    	attach.body=bodyBlob;
        attach.parentId=ObjVR.id;
        insert attach;
    	Test.StopTest();
        
    	List<Attachment> attachments=[select id, name from Attachment where parent.id=:ObjVR.id];
    	System.assertEquals(1, attachments.size());
    }
    static testMethod void testMethod3() 
	{
        Id MinorNCrecordTypeId = Schema.SObjectType.Verification_Report__c.getRecordTypeInfosByName().get('Unannounced Inspections').getRecordTypeId();
        
    	Verification_Report__c ObjVR = new Verification_Report__c();
        ObjVR.RecordTypeId = MinorNCrecordTypeId;
        ObjVR.Name  = 'Test Resolution';
        insert ObjVR;
 		
        Test.StartTest(); 
        Attachment attach=new Attachment();   	
    	attach.Name= ObjVR.Name  = '.pdf';
    	Blob bodyBlob=Blob.valueOf('Testing Body of Attachment');
    	attach.body=bodyBlob;
        attach.parentId=ObjVR.id;
        insert attach;
    	Test.StopTest();
        
    	List<Attachment> attachments=[select id, name from Attachment where parent.id=:ObjVR.id];
    	System.assertEquals(1, attachments.size());
    }

}