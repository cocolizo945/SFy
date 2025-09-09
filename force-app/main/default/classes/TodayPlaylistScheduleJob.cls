/**
 * @description       : 
 * @author            : Eduardo Mendez Miranda
 * @group             : 
 * @last modified on  : 09-08-2025
 * @last modified by  : Eduardo Mendez Miranda
**/
public with sharing class TodayPlaylistScheduleJob implements Schedulable{
    public void execute(SchedulableContext sc) {
        
        try {
            updateReleasedTodayPlaylist();    
        } catch (Exception e ) {
             System.debug('Error in Scheduled Job updateReleasedTodayPlaylist: ' + e.getMessage());
            System.debug('Stack Trace: ' + e.getStackTraceString());
        }
    }

    private void updateReleasedTodayPlaylist() {

        //get today songs
         Map<Id, Song__c> todaysSongsMap = SongsSelector.getTodaysPublicSongsMap();

        //check if the playlist released today exist
        List<User_Playlist__c> releasedTodayPlaylist = UserPlaylistSelector.getPlaylistByName('Released Today');

        if (releasedTodayPlaylist == null) {
                releasedTodayPlaylist.add(new User_Playlist__c(
                    Name = 'Released Today',
                    IsPublic__c = TRUE
                ));
                insert releasedTodayPlaylist;
            }

        // get old links and delete them
        List<Playlist_Song__c> oldLinks = PlaylistSongSelector.getByPlaylist(releasedTodayPlaylist[0].Id);
        
        if (!oldLinks.isEmpty()) {
            delete oldLinks;
        }

        //reading and insert the songs on the Playlist Released Today
        if (!todaysSongsMap.isEmpty()) {
            List<Playlist_Song__c> songsToInsert = new List<Playlist_Song__c>();

               for (Song__c song : todaysSongsMap.values()) {
                songsToInsert.add(new Playlist_Song__c(
                    PlaylistId__c = releasedTodayPlaylist[0].Id,
                    SongId__c = song.Id,
                    Duration__c = song.Duration__c,
                    Genre__c = song.Genre__c,
                    Name = song.Name
                ));
            }
            
            
                insert songsToInsert; 
            
        }
    }
}