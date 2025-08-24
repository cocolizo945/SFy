/**
 * @description       : 
 * @author            : Eduardo Mendez Miranda
 * @group             : 
 * @last modified on  : 08-24-2025
 * @last modified by  : Eduardo Mendez Miranda
**/
public with sharing class TodayPlaylistScheduleJob implements Schedulable{
    public void execute(SchedulableContext sc) {
        updateReleasedTodayPlaylist();
    }

    private void updateReleasedTodayPlaylist() {
        Date today = Date.today();

        //get today songs
        List<Song__c> todaysSongs = [
            SELECT Id, Name, Duration__c, Genre__c, ArtistId__r.Name
            FROM Song__c
            WHERE Release_Date__c = :today
            AND IsPublic__c = TRUE
        ];

        //check if the playlist released today exist
        User_Playlist__c releasedTodayPlaylist;
        List<User_Playlist__c> found = [
            SELECT Id, Name
            FROM User_Playlist__c
            WHERE Name = 'Released Today'
            LIMIT 1
        ];
        if (!found.isEmpty()) {
            releasedTodayPlaylist = found[0];
        } else {
            releasedTodayPlaylist = new User_Playlist__c(
                Name = 'Released Today',
                IsPublic__c = TRUE
            );
            System.debug(releasedTodayPlaylist);
            insert releasedTodayPlaylist;
        }

        //get the old links between Song__c and User_Playlist__c
        List<Playlist_Song__c> oldLinks = [
            SELECT Id
            FROM Playlist_Song__c
            WHERE PlaylistId__c = :releasedTodayPlaylist.Id
        ];
        //in case oldLinks are not empty delete the links
        if (!oldLinks.isEmpty()) {
            delete oldLinks; 
        }

        //reading and insert the songs on the Playlist Released Today
        if (!todaysSongs.isEmpty()) {
            Map<Id, Song__c> songById = new Map<Id, Song__c>(todaysSongs);
            Set<Id> songIds = songById.keySet();

            List<Playlist_Song__c> toInsert = new List<Playlist_Song__c>();
            for (Id sid : songIds) {
                Song__c s = songById.get(sid);
                toInsert.add(new Playlist_Song__c(
                    PlaylistId__c = releasedTodayPlaylist.Id,
                    SongId__c = s.Id,
                    Duration__c = s.Duration__c,
                    Genre__c = s.Genre__c,
                    Name = s.Name
                ));
            }
            if (!toInsert.isEmpty()) {
                insert toInsert; 
            }
        }
    }
}