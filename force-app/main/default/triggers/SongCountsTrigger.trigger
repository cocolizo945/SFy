trigger SongCountsTrigger on Song__c (after insert, after update, after delete, after undelete) {
    Set<Id> artistIds = new Set<Id>();
 
    if(Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete){
        for(Song__c s : Trigger.new){
                    if(s.ArtistId__c != null){
                        artistIds.add(s.ArtistId__c);
                    }
                }
    }
    if(Trigger.isDelete){
        for(Song__c s : Trigger.old){
            if(s.ArtistId__c != null){
                artistIds.add(s.ArtistId__c);
            }
        }
    }
 
    if(!artistIds.isEmpty()){
        ArtistHandler.updateCounts(artistIds);
    }
}