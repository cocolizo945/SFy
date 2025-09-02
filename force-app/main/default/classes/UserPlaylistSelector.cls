/**
 * @description       : 
 * @author            : Eduardo Mendez Miranda
 * @group             : 
 * @last modified on  : 09-01-2025
 * @last modified by  : Eduardo Mendez Miranda
**/
public with sharing class UserPlaylistSelector {
    
    @AuraEnabled
    public static User_Playlist__c getPlaylistByName(String playlistName) {
        List<User_Playlist__c> playlistExist = [
            SELECT Id, Name
            FROM User_Playlist__c
            WHERE Name = :playlistName
            LIMIT 1
        ];
        return playlistExist.isEmpty() ? null : playlistExist[0];
    }

}