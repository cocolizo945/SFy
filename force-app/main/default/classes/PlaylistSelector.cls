public with sharing class PlaylistSelector {
    
    public static List<User_Playlist__c> getLastModified(){
        return[
            SELECT 
            Id,
            Name,
            Cant_Songs__c,
            Playtime__c, 
            LastModifiedDate  
            FROM User_Playlist__c 
            WHERE UserId__c = 'a06gK000003Ba85QAC' 
            ORDER BY LastModifiedDate 
            DESC LIMIT 5
        ];
    }

    public static List<User_Playlist__c> getPlaylistUser(){
        return[
            SELECT
                Id,
                Name,
                Cant_Songs__c,
                Playtime__c,
                IsPublic__c
            FROM User_Playlist__c
            WHERE UserId__c = 'a06gK000003Ba85QAC'
        ];
    }

    public static List<User_Playlist__c> getPlaylistFromUser(){
        return[
            SELECT
                Id,
                Name,
                Cant_Songs__c,
                Playtime__c,
                IsPublic__c
            FROM User_Playlist__c
            WHERE IsPublic__c = true AND UserId__c = 'a06gK000003Ba85QAC'
        ];
    }

    public static List<User_Playlist__c> getPrivatePlaylist(){
        return[
            SELECT
                Id,
                Name,
                Cant_Songs__c,
                Playtime__c,
                IsPublic__c
            FROM User_Playlist__c
            WHERE IsPublic__c = false AND UserId__c = 'a06gK000003Ba85QAC'
        ];
    }
}