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
}