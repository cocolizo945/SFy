/**
 * @description       : 
 * @author            : Eduardo Mendez Miranda
 * @group             : 
 * @last modified on  : 08-24-2025
 * @last modified by  : Eduardo Mendez Miranda
**/
public with sharing class LandingPageController {

    /**
     * @description Returns a list of next songs using SongService logic.
     * @return List of Song__c representing the next songs according to business rules.
     * @throws AuraHandledException if the service call fails.
     * @example List<Song__c> nextSongs = LandingPageController.getNextSongs();
     */
    @AuraEnabled
    public static List<Song__c> getUpcommingSongs() {
        try {
            return SongService.getUpcommingSongs();
        } catch (Exception e) {
            throw new AuraHandledException('an error occurred while performing this operation');
        }
    }

    /**
     * @description Returns the last modified playlists for the current logged-in user.
     * @return List of User_Playlist__c containing the 5 most recently modified playlists.
     * @throws AuraHandledException if the selector call fails.
     * @example List<User_Playlist__c> playlists = LandingPageController.getLastModifiedPlaylist();
     */
    @AuraEnabled
    public static List<User_Playlist__c> getLastModifiedPlaylist(){
        try {
            return PlaylistSelector.getLastModifiedPlaylist(UserInfo.getUserId());
        }catch(Exception e){
            throw new AuraHandledException('an error occurred while performing this operation');
        }
    }
} 