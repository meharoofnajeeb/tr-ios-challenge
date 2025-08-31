//
//  GetMoviesUseCaseTests.swift
//  MoviesTRTests
//
//  Created by Meharoof Najeeb on 2025-08-30.
//

import XCTest
@testable import MoviesTR

final class GetMoviesUseCase {
    private let fetcher: MoviesFetching
    
    init(fetcher: MoviesFetching) {
        self.fetcher = fetcher
    }
    
    func getMovies() async throws -> [Movie] {
        return try await fetcher.fetchAllMovies()
    }
}

final class GetMoviesUseCaseTests: XCTestCase {
    
    func test_getMovies_deliversMoviesOnFetcherSuccess() async throws {
        let expectedMovie = Movie(id: 1, name: "Movie 1", imageURL: URL(string: "http://any-url.com")!, year: "2000")
        let fetcher = MoviesFetcherSpy(moviesToReturn: [expectedMovie])
        let sut = GetMoviesUseCase(fetcher: fetcher)
        
        let movies = try await sut.getMovies()
        
        XCTAssertEqual(movies, [expectedMovie])
    }
    
    // MARK: - Private helpers
    private class MoviesFetcherSpy: MoviesFetching {
        private let moviesToReturn: [Movie]
        
        init(moviesToReturn: [Movie]) {
            self.moviesToReturn = moviesToReturn
        }
        
        func fetchAllMovies() async throws -> [MoviesTR.Movie] {
            return moviesToReturn
        }
    }
}
