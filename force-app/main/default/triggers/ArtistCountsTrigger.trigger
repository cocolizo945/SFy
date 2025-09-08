trigger ArtistCountsTrigger on Artist__c (after insert, after update, after delete, after undelete) {
    Set<Id> artistIds = new Set<Id>();
 
    if(Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete){
        artistIds.addAll(Trigger.newMap.keySet());
    }
    if(Trigger.isDelete){
        artistIds.addAll(Trigger.oldMap.keySet());
    }
 
    if(!artistIds.isEmpty()){
        ArtistHandler.updateCounts(artistIds);
    }
}