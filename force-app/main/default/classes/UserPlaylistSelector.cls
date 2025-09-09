/**
 * @description       : 
 * @author            : Eduardo Mendez Miranda
 * @group             : 
 * @last modified on  : 09-08-2025
 * @last modified by  : Eduardo Mendez Miranda
**/
public with sharing class UserPlaylistSelector {
    
    
    public static List<User_Playlist__c> getPlaylistByName(String playlistName) {
        return [
            SELECT Id, Name
            FROM User_Playlist__c
            WHERE Name = :playlistName
        ];
    }

}