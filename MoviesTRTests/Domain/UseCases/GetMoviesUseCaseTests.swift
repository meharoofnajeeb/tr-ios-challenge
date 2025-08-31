//
//  GetMoviesUseCaseTests.swift
//  MoviesTRTests
//
//  Created by Meharoof Najeeb on 2025-08-30.
//

import XCTest
@testable import MoviesTR

final class GetMoviesUseCaseTests: XCTestCase {
    
    func test_getMovies_deliversMoviesOnFetcherSuccess() async throws {
        let expectedMovie = Movie(id: 1, name: "Movie 1", imageURL: URL(string: "http://any-url.com")!, year: "2000")
        let (sut, fetcher) = makeSUT(moviesToReturn: [expectedMovie])
        
        let movies = try await sut.getMovies()
        
        XCTAssertEqual(fetcher.fetchAllCallCount, 1)
        XCTAssertEqual(movies, [expectedMovie])
    }
    
    func test_getMovies_deliversErrorOnFetcherError() async {
        let expectedError = NSError(domain: "test", code: -1)
        let (sut, fetcher) = makeSUT(errorToThrow: expectedError)
        
        do {
            let _ = try await sut.getMovies()
            XCTFail("Expected error. Got success instead.")
        } catch {
            XCTAssertEqual(fetcher.fetchAllCallCount, 1)
            XCTAssertEqual(error as NSError, expectedError)
        }
    }
    
    // MARK: - Private helpers
    private func makeSUT(moviesToReturn: [Movie] = [], errorToThrow: Error? = nil) -> (sut: GetMoviesUseCase, fetcher: MoviesFetcherSpy) {
        let fetcher = MoviesFetcherSpy(moviesToReturn: moviesToReturn, errorToThrow: errorToThrow)
        let sut = GetMoviesUseCase(fetcher: fetcher)
        return (sut, fetcher)
    }
    
    private class MoviesFetcherSpy: MoviesFetching {
        private let moviesToReturn: [Movie]
        private var error: Error?
        
        var fetchAllCallCount = 0
        
        init(moviesToReturn: [Movie] = [], errorToThrow: Error? = nil) {
            self.moviesToReturn = moviesToReturn
            self.error = errorToThrow
        }
        
        func fetchAllMovies() async throws -> [MoviesTR.Movie] {
            fetchAllCallCount += 1
            if let error {
                throw error
            }
            return moviesToReturn
        }
    }
}
