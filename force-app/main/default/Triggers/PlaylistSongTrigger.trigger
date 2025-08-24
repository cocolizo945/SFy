/**
 * @description       : 
 * @author            : Eduardo Mendez Miranda
 * @group             : 
 * @last modified on  : 08-24-2025
 * @last modified by  : Eduardo Mendez Miranda
**/
trigger PlaylistSongTrigger on Playlist_Song__c (before insert) {

    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            PlaylistSongHandler.beforeInsert(Trigger.new);
        }
        if (Trigger.isUpdate) {
            PlaylistSongHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}