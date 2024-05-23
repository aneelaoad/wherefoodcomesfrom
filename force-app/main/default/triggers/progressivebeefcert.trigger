trigger progressivebeefcert on Certificate__c (before insert) {
for(Certificate__c c: Trigger.new){
c.Opp4__c = '0066300000DLBLdAAP';
}
}