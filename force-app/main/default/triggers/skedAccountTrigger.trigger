trigger skedAccountTrigger on Account (after insert, after update) {

	if(Trigger.isAfter){
        if(Trigger.isInsert || Trigger.isUpdate){
            skedLocationServices.updateLocationGeocode(Trigger.old, Trigger.newMap, skedLocationServices.OBJ_ACCOUNT);
        }
    }
}