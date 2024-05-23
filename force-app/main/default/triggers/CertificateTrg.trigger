/*
Author: Rizwan Ali
Date Created: 12-Sep-2019
Purpose: 
         1. American Grown Certificate - 
            Copying the data from Account's child "Feeder Farm" records to new American Grown Certificate record 
  
********************************************** Modification History **********************************************
Modified By: 
Date Modified:
Purpose:

*/

trigger CertificateTrg on Certificate__c (after insert) {

if(Trigger.isAfter && Trigger.isInsert)
 {
    //1. Create Set of IDs to Fetch Feeder Farms
    SET<ID> setofAmericanGrownCertificateIDs = new SET<ID>();
    SET<ID> setofAccountIDs =new SET<ID>();   
    
    String AmericanGrownRecordTypeID = [SELECT Id from RecordType WHERE sObjectType='Certificate__c' 
                                        AND Name = 'American Grown'].Id;
    
    for(Certificate__c objCertificate : Trigger.New)
    {
      if(objCertificate.RecordTypeId ==  AmericanGrownRecordTypeID)
      {  
       setofAmericanGrownCertificateIDs.add(objCertificate.Id);   
       setofAccountIDs.add(objCertificate.Account_ID__c);
      }
    }
  
  //2. Fetch Feeder Farms
  list<Feeder_Farm__c> ListofFeederFarms = [SELECT ID, 
                                                Name,
                                                Physical_Address__c,
                                                Other_Species__c 
                                            FROM Feeder_Farm__c 
                                            WHERE Account__c IN : setofAccountIDs
                                            ORDER BY CreatedDate
                                            ];
  
  
  
  list<Certificate__c>  ListofCertificateToUpdate = [SELECT ID,
                                                            ffAddress_1__c,
                                                            ffAddress_2__c,
                                                            ffAddress_3__c,
                                                            ffAddress_4__c,
                                                            ffAddress_5__c,
                                                            ffAddress_6__c,
                                                            ffAddress_7__c,
                                                            ffAddress_8__c,
                                                            ffAddress_9__c,
                                                            ffAddress_10__c,
                                                            ffAddress_11__c,
                                                            ffAddress_12__c,
                                                            ffAddress_13__c,
                                                            ffAddress_14__c,
                                                            ffAddress_15__c,
                                                            ffAddress_16__c,
                                                            ffAddress_17__c,
                                                            ffAddress_18__c,
                                                            ffAddress_19__c,
                                                            ffAddress_20__c,
                                                            ffAddress_21__c,
                                                            ffAddress_22__c,
                                                            ffAddress_23__c,
                                                            ffAddress_24__c,
                                                            ffAddress_25__c,
                                                            ffAddress_26__c,
                                                            ffAddress_27__c,
                                                            ffAddress_28__c,
                                                            ffAddress_29__c,
                                                            ffAddress_30__c,
                                                            ffAddress_31__c,
                                                            ffAddress_32__c,
                                                            ffAddress_33__c,
                                                            ffAddress_34__c,
                                                            ffAddress_35__c,
                                                            ffAddress_36__c,
                                                            ffAddress_37__c,
                                                            ffAddress_38__c, 
                                                            ffAddress_39__c,
                                                            ffAddress_40__c,

                                                            ffSpecies_1__c,
                                                            ffSpecies_2__c,
                                                            ffSpecies_3__c,
                                                            ffSpecies_4__c,
                                                            ffSpecies_5__c,
                                                            ffSpecies_6__c,
                                                            ffSpecies_7__c,
                                                            ffSpecies_8__c,
                                                            ffSpecies_9__c,
                                                            ffSpecies_10__c,
                                                            ffSpecies_11__c,
                                                            ffSpecies_12__c,
                                                            ffSpecies_13__c,
                                                            ffSpecies_14__c,
                                                            ffSpecies_15__c,
                                                            ffSpecies_16__c,
                                                            ffSpecies_17__c,
                                                            ffSpecies_18__c,
                                                            ffSpecies_19__c,
                                                            ffSpecies_20__c,
                                                            ffSpecies_21__c,
                                                            ffSpecies_22__c,
                                                            ffSpecies_23__c,
                                                            ffSpecies_24__c,
                                                            ffSpecies_25__c,
                                                            ffSpecies_26__c,
                                                            ffSpecies_27__c,
                                                            ffSpecies_28__c,
                                                            ffSpecies_29__c,
                                                            ffSpecies_30__c,
                                                            ffSpecies_31__c,
                                                            ffSpecies_32__c,
                                                            ffSpecies_33__c,
                                                            ffSpecies_34__c,
                                                            ffSpecies_35__c,
                                                            ffSpecies_36__c,
                                                            ffSpecies_37__c,
                                                            ffSpecies_38__c,
                                                            ffSpecies_39__c,
                                                            ffSpecies_40__c,
                            
                                                            ffLegalName_1__c,
                                                            ffLegalName_2__c,
                                                            ffLegalName_3__c,
                                                            ffLegalName_4__c,
                                                            ffLegalName_5__c,
                                                            ffLegalName_6__c,
                                                            ffLegalName_7__c,
                                                            ffLegalName_8__c,
                                                            ffLegalName_9__c,
                                                            ffLegalName_10__c,
                                                            ffLegalName_11__c,
                                                            ffLegalName_12__c,
                                                            ffLegalName_13__c,
                                                            ffLegalName_14__c,
                                                            ffLegalName_15__c,
                                                            ffLegalName_16__c,
                                                            ffLegalName_17__c,
                                                            ffLegalName_18__c,
                                                            ffLegalName_19__c,
                                                            ffLegalName_20__c,
                                                            ffLegalName_21__c,
                                                            ffLegalName_22__c,
                                                            ffLegalName_23__c,
                                                            ffLegalName_24__c,
                                                            ffLegalName_25__c,
                                                            ffLegalName_26__c,
                                                            ffLegalName_27__c,
                                                            ffLegalName_28__c,
                                                            ffLegalName_29__c,
                                                            ffLegalName_30__c,
                                                            ffLegalName_31__c,
                                                            ffLegalName_32__c,
                                                            ffLegalName_33__c,
                                                            ffLegalName_34__c,
                                                            ffLegalName_35__c,
                                                            ffLegalName_36__c,
                                                            ffLegalName_37__c,
                                                            ffLegalName_38__c,
                                                            ffLegalName_39__c,
                                                            ffLegalName_40__c

                                                    FROM Certificate__c 
                                                    WHERE ID IN : setofAmericanGrownCertificateIDs];  
 
 
 //3. Updating the Certificate data using Feeder Farms data
 if(ListofFeederFarms.Size()>0 && ListofCertificateToUpdate.size()>0)
 {
   
   for(Certificate__c objCertificate : ListofCertificateToUpdate) 
   {

   if(ListofFeederFarms.size()>= 1)
    {
      objCertificate.ffLegalName_1__c = ListofFeederFarms[0].Name;
      objCertificate.ffAddress_1__c = ListofFeederFarms[0].Physical_Address__c;
      objCertificate.ffSpecies_1__c = ListofFeederFarms[0].Other_Species__c;
    }
    
    if(ListofFeederFarms.size()>= 2)
    {
      objCertificate.ffLegalName_2__c = ListofFeederFarms[1].Name;
      objCertificate.ffAddress_2__c = ListofFeederFarms[1].Physical_Address__c;
      objCertificate.ffSpecies_2__c = ListofFeederFarms[1].Other_Species__c;
    }
    
    if(ListofFeederFarms.size()>= 3)
    {
      objCertificate.ffLegalName_3__c = ListofFeederFarms[2].Name;
      objCertificate.ffAddress_3__c = ListofFeederFarms[2].Physical_Address__c;
      objCertificate.ffSpecies_3__c = ListofFeederFarms[2].Other_Species__c;
    }
    
    if(ListofFeederFarms.size()>= 4)
    {
      objCertificate.ffLegalName_4__c = ListofFeederFarms[3].Name;
      objCertificate.ffAddress_4__c = ListofFeederFarms[3].Physical_Address__c;
      objCertificate.ffSpecies_4__c = ListofFeederFarms[3].Other_Species__c;
    }
    
    if(ListofFeederFarms.size()>= 5)
    {
      objCertificate.ffLegalName_5__c = ListofFeederFarms[4].Name;
      objCertificate.ffAddress_5__c = ListofFeederFarms[4].Physical_Address__c;
      objCertificate.ffSpecies_5__c = ListofFeederFarms[4].Other_Species__c;
    }
    
    if(ListofFeederFarms.size()>= 6)
    {
      objCertificate.ffLegalName_6__c = ListofFeederFarms[5].Name;
      objCertificate.ffAddress_6__c = ListofFeederFarms[5].Physical_Address__c;
      objCertificate.ffSpecies_6__c = ListofFeederFarms[5].Other_Species__c;
    }
    
    if(ListofFeederFarms.size()>= 7)
    {
      objCertificate.ffLegalName_7__c = ListofFeederFarms[6].Name;
      objCertificate.ffAddress_7__c = ListofFeederFarms[6].Physical_Address__c;
      objCertificate.ffSpecies_7__c = ListofFeederFarms[6].Other_Species__c;
    }
    
    if(ListofFeederFarms.size()>= 8)
    {
      objCertificate.ffLegalName_8__c = ListofFeederFarms[7].Name;
      objCertificate.ffAddress_8__c = ListofFeederFarms[7].Physical_Address__c;
      objCertificate.ffSpecies_8__c = ListofFeederFarms[7].Other_Species__c;
    }
    
    if(ListofFeederFarms.size()>= 9)
    {
      objCertificate.ffLegalName_9__c = ListofFeederFarms[8].Name;
      objCertificate.ffAddress_9__c = ListofFeederFarms[8].Physical_Address__c;
      objCertificate.ffSpecies_9__c = ListofFeederFarms[8].Other_Species__c;
    }
    
    if(ListofFeederFarms.size()>= 10)
    {
      objCertificate.ffLegalName_10__c = ListofFeederFarms[9].Name;
      objCertificate.ffAddress_10__c = ListofFeederFarms[9].Physical_Address__c;
      objCertificate.ffSpecies_10__c = ListofFeederFarms[9].Other_Species__c;
    }
   
    
     if(ListofFeederFarms.size()>= 11)
    {
      objCertificate.ffLegalName_11__c = ListofFeederFarms[10].Name;
      objCertificate.ffAddress_11__c = ListofFeederFarms[10].Physical_Address__c;
      objCertificate.ffSpecies_11__c = ListofFeederFarms[10].Other_Species__c;
    }
    
    if(ListofFeederFarms.size()>= 12)
    {
      objCertificate.ffLegalName_12__c = ListofFeederFarms[11].Name;
      objCertificate.ffAddress_12__c = ListofFeederFarms[11].Physical_Address__c;
      objCertificate.ffSpecies_12__c = ListofFeederFarms[11].Other_Species__c;
    }
    
    if(ListofFeederFarms.size()>= 13)
    {
      objCertificate.ffLegalName_13__c = ListofFeederFarms[12].Name;
      objCertificate.ffAddress_13__c = ListofFeederFarms[12].Physical_Address__c;
      objCertificate.ffSpecies_13__c = ListofFeederFarms[12].Other_Species__c;
    }
    
    if(ListofFeederFarms.size()>= 14)
    {
      objCertificate.ffLegalName_14__c = ListofFeederFarms[13].Name;
      objCertificate.ffAddress_14__c = ListofFeederFarms[13].Physical_Address__c;
      objCertificate.ffSpecies_14__c = ListofFeederFarms[13].Other_Species__c;
    }
    
    if(ListofFeederFarms.size()>= 15)
    {
      objCertificate.ffLegalName_15__c = ListofFeederFarms[14].Name;
      objCertificate.ffAddress_15__c = ListofFeederFarms[14].Physical_Address__c;
      objCertificate.ffSpecies_15__c = ListofFeederFarms[14].Other_Species__c;
    }
    
    if(ListofFeederFarms.size()>= 16)
    {
      objCertificate.ffLegalName_16__c = ListofFeederFarms[15].Name;
      objCertificate.ffAddress_16__c = ListofFeederFarms[15].Physical_Address__c;
      objCertificate.ffSpecies_16__c = ListofFeederFarms[15].Other_Species__c;
    }
    
    if(ListofFeederFarms.size()>= 17)
    {
      objCertificate.ffLegalName_17__c = ListofFeederFarms[16].Name;
      objCertificate.ffAddress_17__c = ListofFeederFarms[16].Physical_Address__c;
      objCertificate.ffSpecies_17__c = ListofFeederFarms[16].Other_Species__c;
    }
    
    if(ListofFeederFarms.size()>= 18)
    {
      objCertificate.ffLegalName_18__c = ListofFeederFarms[17].Name;
      objCertificate.ffAddress_18__c = ListofFeederFarms[17].Physical_Address__c;
      objCertificate.ffSpecies_18__c = ListofFeederFarms[17].Other_Species__c;
    }
    
    if(ListofFeederFarms.size()>= 19)
    {
      objCertificate.ffLegalName_19__c = ListofFeederFarms[18].Name;
      objCertificate.ffAddress_19__c = ListofFeederFarms[18].Physical_Address__c;
      objCertificate.ffSpecies_19__c = ListofFeederFarms[18].Other_Species__c;
    }
    
    if(ListofFeederFarms.size()>= 20)
    {
      objCertificate.ffLegalName_20__c = ListofFeederFarms[19].Name;
      objCertificate.ffAddress_20__c = ListofFeederFarms[19].Physical_Address__c;
      objCertificate.ffSpecies_20__c = ListofFeederFarms[19].Other_Species__c;
    }
    
    
     if(ListofFeederFarms.size()>= 21)
    {
      objCertificate.ffLegalName_21__c = ListofFeederFarms[20].Name;
      objCertificate.ffAddress_21__c = ListofFeederFarms[20].Physical_Address__c;
      objCertificate.ffSpecies_21__c = ListofFeederFarms[20].Other_Species__c;
    }
    
    if(ListofFeederFarms.size()>= 22)
    {
      objCertificate.ffLegalName_22__c = ListofFeederFarms[21].Name;
      objCertificate.ffAddress_22__c = ListofFeederFarms[21].Physical_Address__c;
      objCertificate.ffSpecies_22__c = ListofFeederFarms[21].Other_Species__c;
    }
    
    if(ListofFeederFarms.size()>= 23)
    {
      objCertificate.ffLegalName_23__c = ListofFeederFarms[22].Name;
      objCertificate.ffAddress_23__c = ListofFeederFarms[22].Physical_Address__c;
      objCertificate.ffSpecies_23__c = ListofFeederFarms[22].Other_Species__c;
    }
    
    if(ListofFeederFarms.size()>= 24)
    {
      objCertificate.ffLegalName_24__c = ListofFeederFarms[23].Name;
      objCertificate.ffAddress_24__c = ListofFeederFarms[23].Physical_Address__c;
      objCertificate.ffSpecies_24__c = ListofFeederFarms[23].Other_Species__c;
    }
    
    if(ListofFeederFarms.size()>= 25)
    {
      objCertificate.ffLegalName_25__c = ListofFeederFarms[24].Name;
      objCertificate.ffAddress_25__c = ListofFeederFarms[24].Physical_Address__c;
      objCertificate.ffSpecies_25__c = ListofFeederFarms[24].Other_Species__c;
    }
    
    if(ListofFeederFarms.size()>= 26)
    {
      objCertificate.ffLegalName_26__c = ListofFeederFarms[25].Name;
      objCertificate.ffAddress_26__c = ListofFeederFarms[25].Physical_Address__c;
      objCertificate.ffSpecies_26__c = ListofFeederFarms[25].Other_Species__c;
    }
    
    if(ListofFeederFarms.size()>= 27)
    {
      objCertificate.ffLegalName_27__c = ListofFeederFarms[26].Name;
      objCertificate.ffAddress_27__c = ListofFeederFarms[26].Physical_Address__c;
      objCertificate.ffSpecies_27__c = ListofFeederFarms[26].Other_Species__c;
    }
    
    if(ListofFeederFarms.size()>= 28)
    {
      objCertificate.ffLegalName_28__c = ListofFeederFarms[27].Name;
      objCertificate.ffAddress_28__c = ListofFeederFarms[27].Physical_Address__c;
      objCertificate.ffSpecies_28__c = ListofFeederFarms[27].Other_Species__c;
    }
    
    if(ListofFeederFarms.size()>= 29)
    {
      objCertificate.ffLegalName_29__c = ListofFeederFarms[28].Name;
      objCertificate.ffAddress_29__c = ListofFeederFarms[28].Physical_Address__c;
      objCertificate.ffSpecies_29__c = ListofFeederFarms[28].Other_Species__c;
    }
    
    if(ListofFeederFarms.size()>= 30)
    {
      objCertificate.ffLegalName_30__c = ListofFeederFarms[29].Name;
      objCertificate.ffAddress_30__c = ListofFeederFarms[29].Physical_Address__c;
      objCertificate.ffSpecies_30__c = ListofFeederFarms[29].Other_Species__c;
    }
    
     if(ListofFeederFarms.size()>= 31)
    {
      objCertificate.ffLegalName_31__c = ListofFeederFarms[30].Name;
      objCertificate.ffAddress_31__c = ListofFeederFarms[30].Physical_Address__c;
      objCertificate.ffSpecies_31__c = ListofFeederFarms[30].Other_Species__c;
    }
    
    if(ListofFeederFarms.size()>= 32)
    {
      objCertificate.ffLegalName_32__c = ListofFeederFarms[31].Name;
      objCertificate.ffAddress_32__c = ListofFeederFarms[31].Physical_Address__c;
      objCertificate.ffSpecies_32__c = ListofFeederFarms[31].Other_Species__c;
    }
    
    if(ListofFeederFarms.size()>= 33)
    {
      objCertificate.ffLegalName_33__c = ListofFeederFarms[32].Name;
      objCertificate.ffAddress_33__c = ListofFeederFarms[32].Physical_Address__c;
      objCertificate.ffSpecies_33__c = ListofFeederFarms[32].Other_Species__c;
    }
    
    if(ListofFeederFarms.size()>= 34)
    {
      objCertificate.ffLegalName_34__c = ListofFeederFarms[33].Name;
      objCertificate.ffAddress_34__c = ListofFeederFarms[33].Physical_Address__c;
      objCertificate.ffSpecies_34__c = ListofFeederFarms[33].Other_Species__c;
    }
    
    if(ListofFeederFarms.size()>= 35)
    {
      objCertificate.ffLegalName_35__c = ListofFeederFarms[34].Name;
      objCertificate.ffAddress_35__c = ListofFeederFarms[34].Physical_Address__c;
      objCertificate.ffSpecies_35__c = ListofFeederFarms[34].Other_Species__c;
    }
    
    if(ListofFeederFarms.size()>= 36)
    {
      objCertificate.ffLegalName_36__c = ListofFeederFarms[35].Name;
      objCertificate.ffAddress_36__c = ListofFeederFarms[35].Physical_Address__c;
      objCertificate.ffSpecies_36__c = ListofFeederFarms[35].Other_Species__c;
    }
    
    if(ListofFeederFarms.size()>= 37)
    {
      objCertificate.ffLegalName_37__c = ListofFeederFarms[36].Name;
      objCertificate.ffAddress_37__c = ListofFeederFarms[36].Physical_Address__c;
      objCertificate.ffSpecies_37__c = ListofFeederFarms[36].Other_Species__c;
    }
    
    if(ListofFeederFarms.size()>= 38)
    {
      objCertificate.ffLegalName_38__c = ListofFeederFarms[37].Name;
      objCertificate.ffAddress_38__c = ListofFeederFarms[37].Physical_Address__c;
      objCertificate.ffSpecies_38__c = ListofFeederFarms[37].Other_Species__c;
    }
    
    if(ListofFeederFarms.size()>= 39)
    {
      objCertificate.ffLegalName_39__c = ListofFeederFarms[38].Name;
      objCertificate.ffAddress_39__c = ListofFeederFarms[38].Physical_Address__c;
      objCertificate.ffSpecies_39__c = ListofFeederFarms[38].Other_Species__c;
    }
    
    if(ListofFeederFarms.size()>= 40)
    {
      objCertificate.ffLegalName_40__c = ListofFeederFarms[39].Name;
      objCertificate.ffAddress_40__c = ListofFeederFarms[39].Physical_Address__c;
      objCertificate.ffSpecies_40__c = ListofFeederFarms[39].Other_Species__c;
    }
    
    
   }
    
    if(ListofCertificateToUpdate.size()>0) 
    {
       update ListofCertificateToUpdate ; 
    }
 }    

 }
}