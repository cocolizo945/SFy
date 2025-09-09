/**
 * @description       : 
 * @author            : Eduardo Mendez Miranda
 * @group             : 
 * @last modified on  : 09-08-2025
 * @last modified by  : Eduardo Mendez Miranda
**/
public with sharing class PlaylistSongSelector {
    
    
    public static List<Playlist_Song__c> getByPlaylist(Id playlistId) {
        return [
            SELECT Id
            FROM Playlist_Song__c
            WHERE PlaylistId__c = :playlistId
        ];
    }
}