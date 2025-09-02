/**
 * @description       : 
 * @author            : Eduardo Mendez Miranda
 * @group             : 
 * @last modified on  : 09-01-2025
 * @last modified by  : Eduardo Mendez Miranda
**/
public with sharing class TodayPlaylistScheduleJob implements Schedulable{
    public void execute(SchedulableContext sc) {
        updateReleasedTodayPlaylist();
    }

    private void updateReleasedTodayPlaylist() {

        //get today songs
         Map<Id, Song__c> todaysSongsMap = SongsSelector.getTodaysPublicSongsMap();

        //check if the playlist released today exist
        User_Playlist__c releasedTodayPlaylist = UserPlaylistSelector.getPlaylistByName('Released Today');

        if (releasedTodayPlaylist == null) {
                releasedTodayPlaylist = new User_Playlist__c(
                    Name = 'Released Today',
                    IsPublic__c = TRUE
                );
                insert releasedTodayPlaylist;
            }

        // get old links and delete them
        List<Playlist_Song__c> oldLinks = PlaylistSongSelector.getByPlaylist(releasedTodayPlaylist.Id);
        
        if (!oldLinks.isEmpty()) {
            delete oldLinks;
        }

        //reading and insert the songs on the Playlist Released Today
        if (!todaysSongsMap.isEmpty()) {
            List<Playlist_Song__c> songsToInsert = new List<Playlist_Song__c>();

               for (Song__c s : todaysSongsMap.values()) {
                songsToInsert.add(new Playlist_Song__c(
                    PlaylistId__c = releasedTodayPlaylist.Id,
                    SongId__c = s.Id,
                    Duration__c = s.Duration__c,
                    Genre__c = s.Genre__c,
                    Name = s.Name
                ));
            }
            
            if (!songsToInsert.isEmpty()) {
                insert songsToInsert; 
            }
        }
    }
}