//
//  ToggleLikeUseCaseTests.swift
//  MoviesTRTests
//
//  Created by Meharoof Najeeb on 2025-09-02.
//

import XCTest
@testable import MoviesTR

final class ToggleLikeUseCaseTests: XCTestCase {
    func test_toggleLike_messagesTheRepositoryToToggleLike() {
        let movieID = 1
        let repository = LikesRepositorySpy()
        let sut = ToggleLikeUseCase(likesRepository: repository)
        
        sut.toggleLike(for: movieID)
        
        XCTAssertEqual(repository.toggleLikeCallCount, 1)
        XCTAssertEqual(repository.movieID, movieID)
    }
    
    //MARK: - Private helpers
    private class LikesRepositorySpy: LikesRepository {
        var toggleLikeCallCount = 0
        var movieID: Int?
        
        func isLiked(movieID: Int) -> Bool { return false }
        
        func toggleLike(for movieID: Int) {
            toggleLikeCallCount += 1
            self.movieID = movieID
        }
    }
}
