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
    
    func getMovieDetails(for id: Int) async throws -> MovieDetail {
        return try await fetcher.fetchMovieDetails(for: id)
    }
}

final class GetMovieDetailUseCaseTests: XCTestCase {
    func test_init_doesNotMessageFetcher() {
        let fetcher = MovieDetailFetcherSpy(movieToReturn: MovieDetail(id: 1, name: "Movie 1", description: "Description1", notes: "Notes 1", rating: "10", imageURL: URL(string: "http://any-url.com")!, releaseDate: "2000"))
        let _ = GetMovieDetailUseCase(fetcher: fetcher)
        
        XCTAssertEqual(fetcher.fetchMovieDetailsCallCount, 0)
    }
    
    func test_getMovieDetails_deliversMovieDetailsOnFetcherSuccess() async throws {
        let movieID = 1
        let expectedMovieDetail = MovieDetail(id: movieID, name: "Movie 1", description: "Description1", notes: "Notes 1", rating: "10", imageURL: URL(string: "http://any-url.com")!, releaseDate: "2000")
        let fetcher = MovieDetailFetcherSpy(movieToReturn: expectedMovieDetail)
        let sut = GetMovieDetailUseCase(fetcher: fetcher)
        
        let resultMovieDetail = try await sut.getMovieDetails(for: movieID)
        
        XCTAssertEqual(fetcher.fetchMovieDetailsCallCount, 1)
        XCTAssertEqual(resultMovieDetail, expectedMovieDetail)
    }
    
    // MARK: - Private helpers
    private class MovieDetailFetcherSpy: MovieDetailFetching {
        var fetchMovieDetailsCallCount = 0
        private let movieToReturn: MovieDetail
        
        init(movieToReturn: MovieDetail) {
            self.movieToReturn = movieToReturn
        }
        
        func fetchMovieDetails(for id: Int) async throws -> MovieDetail {
            fetchMovieDetailsCallCount += 1
            return movieToReturn
        }
    }
}
