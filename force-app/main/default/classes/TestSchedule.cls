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


    private static Song__c makeSong(String name, Date releaseDate, Boolean isPublic) {
        Song__c s = new Song__c();
        s.Name = name;
        s.Release_Date__c = releaseDate;
        s.IsPublic__c = isPublic;
        s.Duration__c = 188;
        s.Genre__c = 'Pop';
        return s;
    }

    private static void scheduleJob() {
        String cron = '0 0 0 1 1 ? 2099'; 
        System.schedule('testJob', cron, new TodayPlaylistScheduleJob());
    }

    @IsTest
    static void testCreatesPlaylistAndInsertsTodaysSongs() {
        Date today = Date.today();
        Date yesterday = today.addDays(-1);

        List<Song__c> songs = new List<Song__c>{
            makeSong('Song A (today)', today, true),
            makeSong('Song B (today)', today, true),
            makeSong('Song C (today)', today, true),
            makeSong('Song D (yesterday)', yesterday, true),
            makeSong('Song E (yesterday)', yesterday, true)
        };
        insert songs;

        User_Playlist__c pl = new User_Playlist__c(Name = 'Released Today', IsPublic__c = true);
        insert pl;


        Playlist_Song__c old1 = new Playlist_Song__c(
            PlaylistId__c = pl.Id,
            SongId__c = songs[3].Id,
            Duration__c = 120,
            Genre__c = 'Pop',
            Name = 'OLD - ' + songs[3].Name
        );
        Playlist_Song__c old2 = new Playlist_Song__c(
            PlaylistId__c = pl.Id,
            SongId__c = songs[4].Id,
            Duration__c = 130,
            Genre__c = 'Pop',
            Name = 'OLD - ' + songs[4].Name
        );
        insert new List<Playlist_Song__c>{ old1, old2 };

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
        Date today = Date.today();
        Date yesterday = today.addDays(-1);

        
        insert new List<Song__c>{
            makeSong('Old 1', yesterday, true),
            makeSong('Old 2', yesterday, true)
        };

        
        User_Playlist__c pl = new User_Playlist__c(Name = 'Released Today', IsPublic__c = true);
        insert pl;

        Song__c dummy = makeSong('Dummy', yesterday, true);
        insert dummy;

        insert new Playlist_Song__c(
            PlaylistId__c = pl.Id,
            SongId__c = dummy.Id,
            Duration__c = 142,
            Genre__c = 'Pop',
            Name = 'OLD - Dummy'
        );

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