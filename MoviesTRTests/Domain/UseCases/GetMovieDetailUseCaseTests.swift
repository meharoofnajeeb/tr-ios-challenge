//
//  GetMovieDetailUseCase.swift
//  MoviesTRTests
//
//  Created by Meharoof Najeeb on 2025-08-30.
//

import XCTest
@testable import MoviesTR

final class GetMovieDetailUseCase {
    private let fetcher: MovieDetailFetching
    
    init(fetcher: MovieDetailFetching) {
        self.fetcher = fetcher
    }
}

final class GetMovieDetailUseCaseTests: XCTestCase {
    func test_init_doesNotMessageFetcher() {
        let fetcher = MovieDetailFetcherSpy()
        let _ = GetMovieDetailUseCase(fetcher: fetcher)
        
        XCTAssertEqual(fetcher.fetchMovieDetailsCallCount, 0)
    }
    
    // MARK: - Private helpers
    private class MovieDetailFetcherSpy: MovieDetailFetching {
        var fetchMovieDetailsCallCount = 0
        
        func fetchMovieDetails(for id: Int) async throws -> MovieDetail {
            fetchMovieDetailsCallCount += 1
            return MovieDetail(id: -1, name: "", description: "", notes: "", rating: "", imageURL: URL(string: "http://any-url.com")!, releaseDate: "")
        }
    }
}
