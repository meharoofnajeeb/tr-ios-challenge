//
//  UserDefaultsLikesRepositoryTests.swift
//  MoviesTRTests
//
//  Created by Meharoof Najeeb on 2025-09-02.
//

import XCTest
@testable import MoviesTR

final class UserDefaultsLikesRepositoryTests: XCTestCase {
    private let testSuiteName = "TestLikesStore"
    private var userDefaults: UserDefaults!

    override func setUp() {
        super.setUp()
        userDefaults = UserDefaults(suiteName: testSuiteName)
        userDefaults.removePersistentDomain(forName: testSuiteName)
    }

    override func tearDown() {
        userDefaults.removePersistentDomain(forName: testSuiteName)
        userDefaults = nil
        super.tearDown()
    }
    
    func test_toggleLike_persistsLikedAndUnlikedStates() {
        let movieID = 1
        var sut = UserDefaultsLikesRepository(userDefaults: userDefaults)
        XCTAssertFalse(sut.isLiked(movieID: movieID))
        
        sut.toggleLike(for: movieID)
        
        sut = UserDefaultsLikesRepository(userDefaults: userDefaults)
        XCTAssertTrue(sut.isLiked(movieID: movieID))
        
        sut.toggleLike(for: movieID)
        
        sut = UserDefaultsLikesRepository(userDefaults: userDefaults)
        XCTAssertFalse(sut.isLiked(movieID: movieID))
    }
}
