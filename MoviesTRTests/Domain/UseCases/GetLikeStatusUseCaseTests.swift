//
//  GetLikeStatusUseCaseTests.swift
//  MoviesTRTests
//
//  Created by Meharoof Najeeb on 2025-09-02.
//

import XCTest
@testable import MoviesTR

final class GetLikeStatusUseCaseTests: XCTestCase {
    func test_isLiked_returnsTrueOrFalseForMovieStatus() {
        let likedMovies: Set<Int> = [1,3,5]
        let repository = LikesRepositoryMock(likedMovies: likedMovies)
        let sut = GetLikeStatusUseCase(likesRepository: repository)
        
        XCTAssertTrue(sut.isLiked(1))
        XCTAssertFalse(sut.isLiked(2))
    }
    
    //MARK: - Private helpers
    private class LikesRepositoryMock: LikesRepository {
        var toggleLikeCallCount = 0
        private var likedMovies: Set<Int>
        
        init(likedMovies: Set<Int>) {
            self.likedMovies = likedMovies
        }
        
        func isLiked(movieID: Int) -> Bool {
            likedMovies.contains(movieID)
        }
        
        func toggleLike(for movieID: Int) {}
    }
}
