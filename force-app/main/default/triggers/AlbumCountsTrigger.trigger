trigger AlbumCountsTrigger on Album__c (after insert, after update, after delete, after undelete) {
    Set<Id> artistIds = new Set<Id>();
 
    if(Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete){
        for(Album__c alb : Trigger.new){
                if(alb.ArtistId__c != null){
                    artistIds.add(alb.ArtistId__c);
                    System.debug(artistIds);
                }
            }
    }
    if(Trigger.isDelete){
        for(Album__c alb : Trigger.old){
            if(alb.ArtistId__c != null){
                artistIds.add(alb.ArtistId__c);
            }
        }
    }
 
    if(!artistIds.isEmpty()){
        ArtistHandler.updateCounts(artistIds);
    }
}