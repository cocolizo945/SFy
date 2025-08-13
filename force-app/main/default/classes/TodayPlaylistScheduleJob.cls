public with sharing class TodayPlaylistScheduleJob implements Schedulable{
    public void execute(SchedulableContext sc) {
        updateReleasedTodayPlaylist();
    }

    private void updateReleasedTodayPlaylist() {
        Date today = Date.today();

        
        List<Song__c> todaysSongs = [
            SELECT Id, Name, Duration__c, Genre__c, ArtistId__r.Name
            FROM Song__c
            WHERE Release_Date__c = :today
            AND IsPublic__c = TRUE
        ];


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
            insert releasedTodayPlaylist;
        }

        
        List<Playlist_Song__c> oldLinks = [
            SELECT Id
            FROM Playlist_Song__c
            WHERE PlaylistId__c = :releasedTodayPlaylist.Id
        ];
        if (!oldLinks.isEmpty()) {
            delete oldLinks; 
        }

        
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