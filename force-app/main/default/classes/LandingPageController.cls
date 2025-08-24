/**
 * @description       : 
 * @author            : Eduardo Mendez Miranda
 * @group             : 
 * @last modified on  : 08-24-2025
 * @last modified by  : Eduardo Mendez Miranda
**/
public with sharing class LandingPageController {
    @AuraEnabled
    public static List<Song__c> getUpcommingSongs() {
        try{
            return SongsSelector.getUpcommingSongs();
        } catch( Exception e){
            throw new AuraHandledException('an error occurred while performing this operation');
        }
    }

    @AuraEnabled
    public static List<Song__c> getNextSongs() {
        try {
            return SongService.getUpcommingSongs();
        } catch (Exception e) {
            throw new AuraHandledException('an error occurred while performing this operation');
        }
    }

    @AuraEnabled
    public static List<User_Playlist__c> getLastModifiedPlaylist(){
        try {
            return PlaylistSelector.getLastModifiedPlaylist(UserInfo.getUserId());
        }catch(Exception e){
            throw new AuraHandledException('an error occurred while performing this operation');
        }
    }
} 