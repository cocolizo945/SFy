/**
 * @description       : 
 * @author            : Eduardo Mendez Miranda
 * @group             : 
 * @last modified on  : 08-24-2025
 * @last modified by  : Eduardo Mendez Miranda
**/
public with sharing class PlaylistSelector {
    
    /**
     * @description Retrieves the five most recently modified playlists for the specified user.
     * @param userId The Id of the User__c record whose playlists should be retrieved.
     * @return A list of up to 5 User_Playlist__c records, ordered by LastModifiedDate (descending).
     * @example List<User_Playlist__c> playlists = PlaylistSelector.getLastModifiedPlaylist(UserInfo.getUserId());
     */
    public static List<User_Playlist__c> getLastModifiedPlaylist(Id userId){
        return[
            SELECT 
            Id,
            Name,
            Cant_Songs__c,
            Playtime__c, 
            LastModifiedDate  
            FROM User_Playlist__c 
            WHERE UserId__c = :userId
            ORDER BY LastModifiedDate 
            DESC LIMIT 5
        ];
    }
}