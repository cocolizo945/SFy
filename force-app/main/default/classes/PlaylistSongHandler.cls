public with sharing class PlaylistSongHandler {

    public static void beforeInsert(List<Playlist_Song__c> newList) {
        AvoidDuplicateOnPlaylist(newList, null);
    }

    public static void beforeUpdate(List<Playlist_Song__c> newList, Map<Id, Playlist_Song__c> oldMap) {
        AvoidDuplicateOnPlaylist(newList, oldMap);
    }

    
    public static void AvoidDuplicateOnPlaylist( List<Playlist_Song__c> newList, Map<Id,Playlist_Song__c> oldMap) {
        Set<Id> playlistId = new Set<Id>();
        Set<String> comboKeys = new Set<String>();
        Map<String,Id> existingKeys = new Map<String,Id>();

        for (Playlist_Song__c ps : newList){
            if (ps.PlaylistId__c != null && ps.SongId__c != null){
                Playlist_Song__c oldPS = Trigger.isUpdate ? oldMap.get(ps.Id) : null;

                if(!Trigger.isUpdate || (ps.PlaylistId__c != oldPS.PlaylistId__c || ps.SongId__c != oldPS.SongId__c)){
                    playlistId.add(ps.PlaylistId__c);
                    comboKeys.add((ps.PlaylistId__c + '-' + ps.SongId__c));
                }
            }
        }
        
        for (Playlist_Song__c record : [
            SELECT Id, PlaylistId__c, SongId__c 
            FROM Playlist_Song__c 
            WHERE PlaylistId__c = :playlistId]){
                String key = record.PlaylistId__c + '-' + record.SongId__c;
                existingKeys.put(key, record.Id);
        }

        for (Playlist_Song__c ps : newList){
            if (ps.PlaylistId__c != null && ps.SongId__c != null){
                String key = ps.PlaylistId__c + '-' + ps.SongId__c;
                Playlist_Song__c oldPS = Trigger.isUpdate ? oldMap.get(ps.Id) : null;

                if (!Trigger.isUpdate || (ps.PlaylistId__c != oldPS.PlaylistId__c || ps.SongId__c != oldPS.SongId__c)){
                    if (existingKeys.containsKey(key) && existingKeys.get(key) != ps.Id){
                        ps.addError('Esta cancion ya existe en la playlist.');
                    }
                }
            }
        }

    }
}