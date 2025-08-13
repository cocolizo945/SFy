trigger PlaylistSongTrigger on Playlist_Song__c (before insert) {

    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            PlaylistHandler.beforeInsert(Trigger.new);
        }
        if (Trigger.isUpdate) {
            PlaylistHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}