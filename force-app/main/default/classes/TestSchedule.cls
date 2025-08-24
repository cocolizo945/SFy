/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestSchedule {

    @TestSetup
    static void makeData(){
        List<Song__c> songs                 = new List<Song__c>();
        List<Artist__c> newArtist           = new List<Artist__c>();
        List<Album__c> newAlbum             = new List<Album__c>();
        List<Playlist_Song__c> newPlaylist  = new List<Playlist_Song__c>();

        newArtist.add(new Artist__c(Name = 'automated test artist'));
        insert newArtist;
        
        newAlbum.add(new Album__c(  Name = 'automated test album',
                                    ArtistId__c = newArtist[0].Id,
                                    IsPublic__c = true,
                                    Release_Date__c = System.today()));            
        insert newAlbum;

        User_Playlist__c pl = new User_Playlist__c(Name = 'Released Today', IsPublic__c = true);
        insert pl;

        for(Integer i = 0; i<=2; i++){
            songs.add(new Song__c(
                Name = 'test name ' + i,
                Release_Date__c = System.today(),
                IsPublic__c = true,
                ArtistId__c = newArtist[0].Id
            ));
            System.debug('song' + i);
        }

        for(Integer i = 3; i<5; i++){
            songs.add(new Song__c(
                Name = 'test name ' + i,
                Release_Date__c = System.today().addDays(-1),
                IsPublic__c = true,
                ArtistId__c = newArtist[0].Id
            ));
            System.debug('song' + i);
        }
        System.debug(songs);
        insert songs;

        for(Integer i = 0; i<1; i++){
            newPlaylist.add(new Playlist_Song__c(
            PlaylistId__c = pl.Id,
            SongId__c = songs[3 + i].Id,
            Duration__c = 120,
            Genre__c = 'Pop',
            Name = 'OLD - ' + songs[3 + i].Name
            ));
        
        }
        insert newPlaylist;

    }

    private static void scheduleJob() {
        String cron = '0 0 0 1 1 ? 2099'; 
        System.schedule('testJob', cron, new TodayPlaylistScheduleJob());
    }

    @IsTest
    static void testCreatesPlaylistAndInsertsTodaysSongs() {

        Test.startTest();
        scheduleJob();
        Test.stopTest(); 
        
        User_Playlist__c plAfter = [
            SELECT Id, Name FROM User_Playlist__c
            WHERE Name = 'Released Today'
            LIMIT 1
        ];
        System.assertNotEquals(null, plAfter, 'Playlists Released Today exist');

        List<Playlist_Song__c> links = [
            SELECT Id, PlaylistId__c, SongId__c, Name
            FROM Playlist_Song__c
            WHERE PlaylistId__c = :plAfter.Id
            ORDER BY Name
        ];

        System.assertEquals(3, links.size(), '3 songs for today must exist on the playlist');

    }

    @IsTest
    static void testNoTodaysSongsLeavesPlaylistEmpty() {
        List<Song__c> todays = [SELECT Id FROM Song__c WHERE Release_Date__c = :System.today()];
        delete todays;

        Test.startTest();
        scheduleJob();
        Test.stopTest();

        
        User_Playlist__c plAfter = [
            SELECT Id, Name FROM User_Playlist__c
            WHERE Name = 'Released Today'
            LIMIT 1
        ];
        System.assertNotEquals(null, plAfter, 'the playlist Released Today must exist');

        Integer countLinks = [
            SELECT COUNT()
            FROM Playlist_Song__c
            WHERE PlaylistId__c = :plAfter.Id
        ];

        System.assertEquals(0, countLinks, 'if there is no recently released, the playlist is empty');
        
    }
}