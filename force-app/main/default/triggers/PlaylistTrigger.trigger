trigger PlaylistTrigger on Playlist_Song__c (before insert) {

    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
        PlaylistHandler.AvoidDuplicateOnPlaylist(Trigger.new, Trigger.oldMap, Trigger.isUpdate);
    }
}