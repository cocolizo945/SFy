/**
 * @description       : 
 * @author            : Eduardo Mendez Miranda
 * @group             : 
 * @last modified on  : 08-18-2025
 * @last modified by  : Eduardo Mendez Miranda
**/
trigger PlaylistSongTrigger on Playlist_Song__c (before insert, before update) {

    if (Trigger.isUpdate){
        if(Trigger.isBefore){
            PlaylistHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
        }
    }

    if (Trigger.isInsert){
        if(Trigger.isBefore){
            PlaylistHandler.beforeInsert(Trigger.new);
        }
    }
   
}