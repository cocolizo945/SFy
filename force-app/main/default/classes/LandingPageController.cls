public with sharing class LandingPageController {
    @AuraEnabled
    public static List<Song__c> getUpcommingSongs() {
        return SongsSelector.getUpcommingSongs();
    }

    @AuraEnabled
    public static List<Song__c> getNextSongs() {
        return SongsSelector.getNextSongs();
    }

    @AuraEnabled
    public static List<User_Playlist__c> getLastModified(){
        return PlaylistSelector.getLastModified();
    }

    @AuraEnabled
    public static List<Song__c> getSongsFromAlbum(){
        return SongsSelector.getSongsFromAlbum();
    }
    
    @AuraEnabled
    public static List<Album__c> getAlbumsFromArtist(){
        return AlbumsSelector.getAlbums();
    }

    @AuraEnabled
    public static List<User_Playlist__c> getPlaylistUser(){
        return PlaylistSelector.getPlaylistUser();
    }

    @AuraEnabled
    public static List<User_Playlist__c> getPlaylistFromUser(){
        return PlaylistSelector.getPlaylistFromUser();
    }

    @AuraEnabled
    public static List<User_Playlist__c> getPrivatePlaylist(){
        return PlaylistSelector.getPrivatePlaylist();
    }

}