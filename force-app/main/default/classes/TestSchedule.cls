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
        List<Song__c> songs                     = new List<Song__c>();
        List<Playlist_Song__c> testPlaylistSong = new List<Playlist_Song__c>();
        
        Artist__c testArtist = new Artist__c(Name = 'automated test artist');
        insert testArtist;
        
        Album__c testAlbum = new Album__c(Name = 'automated test album',
                                 ArtistId__c = testArtist.Id,
                                 IsPublic__c = true,
                                 Release_Date__c = System.today());
        insert testAlbum;

        User_Playlist__c testPlaylist = new User_Playlist__c(Name = 'Released Today', IsPublic__c = true);
        insert testPlaylist;

        for(Integer i = 0; i<=2; i++){
            songs.add(new Song__c(
                Name = 'test name ' + i,
                Release_Date__c = System.today(),
                IsPublic__c = true,
                ArtistId__c = testArtist.Id
            ));
        }

        for(Integer i = 0; i<2; i++){
            songs.add(new Song__c(
                Name = 'test name ' + i,
                Release_Date__c = System.today().addDays(-1),
                IsPublic__c = true,
                ArtistId__c = testArtist.Id
            ));

        }
        insert songs;

        for (Song__c song : songs) {
            if (song.Release_Date__c == System.today().addDays(-1)) {
                testPlaylistSong.add(new Playlist_Song__c(
                    PlaylistId__c = testPlaylist.Id,
                    SongId__c = song.Id,
                    Duration__c = 120,
                    Genre__c = 'Pop',
                    Name = 'OLD - ' + song.Name
                ));
                
            }
        }
        insert testPlaylistSong;
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
        
        Assert.areNotEqual(null, plAfter, 'Playlists Released Today exist');

        List<Playlist_Song__c> links = [
            SELECT Id, PlaylistId__c, SongId__c, Name
            FROM Playlist_Song__c
            WHERE PlaylistId__c = :plAfter.Id
            ORDER BY Name
        ];

        Assert.areEqual(3, links.size(), '3 songs for today must exist on the playlist');

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
        Assert.areNotEqual(null, plAfter, 'the playlist Released Today must exist');

        Integer countLinks = [
            SELECT COUNT()
            FROM Playlist_Song__c
            WHERE PlaylistId__c = :plAfter.Id
        ];

        Assert.areEqual(0, countLinks, 'playlist isnt empty');
    }
}