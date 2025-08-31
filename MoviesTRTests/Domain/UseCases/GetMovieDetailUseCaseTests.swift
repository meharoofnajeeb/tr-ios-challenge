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
        let fetcher = MovieDetailFetcherSpy(movieToReturn: anyMovieDetail())
        let _ = GetMovieDetailUseCase(fetcher: fetcher)
        
        XCTAssertEqual(fetcher.fetchMovieDetailsCallCount, 0)
    }
    
    func test_getMovieDetails_deliversMovieDetailsOnFetcherSuccess() async throws {
        let movieID = 1
        let expectedMovieDetail = anyMovieDetail(movieID: movieID)
        let fetcher = MovieDetailFetcherSpy(movieToReturn: expectedMovieDetail)
        let sut = GetMovieDetailUseCase(fetcher: fetcher)
        
        let resultMovieDetail = try await sut.getMovieDetails(for: movieID)
        
        XCTAssertEqual(fetcher.fetchMovieDetailsCallCount, 1)
        XCTAssertEqual(resultMovieDetail, expectedMovieDetail)
    }
    
    func test_getMovieDetails_deliversErrorOnFetcherError() async {
        let expectedError = NSError(domain: "test", code: -1)
        let (sut, _) = makeSUT(expectedError: expectedError)
        
        do {
            let _ = try await sut.getMovieDetails(for: -1)
            XCTFail("Expeted error. Got success instead.")
        } catch {
            XCTAssertEqual(error as NSError, expectedError)
        }
    }
    
    // MARK: - Private helpers
    private func makeSUT(exptectedMovie: MovieDetail? = nil, expectedError: Error? = nil) -> (sut: GetMovieDetailUseCase, fetcher: MovieDetailFetcherSpy) {
        let fetcher = MovieDetailFetcherSpy(movieToReturn: exptectedMovie, expectedError: expectedError)
        let sut = GetMovieDetailUseCase(fetcher: fetcher)
        return (sut, fetcher)
    }
    
    private func anyMovieDetail(movieID: Int = 1) -> MovieDetail {
        return MovieDetail(id: movieID, name: "Movie 1", description: "Description1", notes: "Notes 1", rating: "10", imageURL: URL(string: "http://any-url.com")!, releaseDate: "2000")
    }
    
    private class MovieDetailFetcherSpy: MovieDetailFetching {
        var fetchMovieDetailsCallCount = 0
        private var movieToReturn: MovieDetail?
        private var error: Error?
        
        init(movieToReturn: MovieDetail? = nil, expectedError: Error? = nil) {
            self.movieToReturn = movieToReturn
            self.error = expectedError
        }
        
        func fetchMovieDetails(for id: Int) async throws -> MovieDetail {
            fetchMovieDetailsCallCount += 1
            if let error {
                throw error
            }
            return movieToReturn!
        }
    }
}
