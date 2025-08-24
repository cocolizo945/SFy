/**
 * @description       : 
 * @author            : Eduardo Mendez Miranda
 * @group             : 
 * @last modified on  : 08-22-2025
 * @last modified by  : Eduardo Mendez Miranda
**/
public with sharing class SongTriggerHandler extends TriggerHandler {
    
    public static List<Song__c> newSongs = Trigger.new;

    public override void beforeInsert(){

        //varaibles to save the songs without album and the last album
        Set<Id> artistIds = new Set<Id>();
        Set<Song__c> songsWithoutAlbum = new set<Song__c>();
        Map<Id, Album__c> latestAlbumByArtist = new Map<Id, Album__c>();

        //checking if the songs have an album if not are saved on artistId and songsWithoutalbum
        for(Song__c song : newSongs){
            if(song.AlbumId__c == null && song.ArtistId__c != null){
                artistIds.add(song.ArtistId__c);
                songsWithoutAlbum.add(song);
            }
        }
        //early return
        if(artistIds.isEmpty()){
            return;
        }
        
        // getting lastest albums
        for(Album__c album : [
            SELECT Id, ArtistId__c, Release_Date__c
            FROM Album__c
            WHERE ArtistId__c IN :artistIds
            ORDER BY Release_Date__c DESC
        ]){
            if(!latestAlbumByArtist.containsKey(album.ArtistId__c)){
                latestAlbumByArtist.put(album.ArtistId__c, album);
            }
        }

        //modding the album in the song
        for(Song__c song : songsWithoutAlbum){
            Album__c latest = latestAlbumByArtist.get(song.ArtistId__c);
            if(latest != null){
                song.AlbumId__c = latest.id;
            }
        }
    }

}