//
//  MoviesListViewModelTests.swift
//  MoviesTRTests
//
//  Created by Meharoof Najeeb on 2025-09-01.
//

import XCTest
@testable import MoviesTR

@MainActor
final class MoviesListViewModelTests: XCTestCase {

    func test_fetchMovies_setsMoviesOnSuccess() async {
        let mockMovies = [Movie(id: 1, name: "Movie 1", imageURL: URL(string: "https://any-url-1.com")!, year: "2000")]
        let getMoviesUseCase = GetMoviesUseCaseMock(movies: mockMovies)
        let sut = MoviesListViewModel(getMoviesUseCase: getMoviesUseCase)
        
        await sut.fetchMovies()
        
        XCTAssertEqual(getMoviesUseCase.getMoviesCallCount, 1)
        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(sut.movies, mockMovies)
        XCTAssertNil(sut.errorMessage)
    }

    // MARK: - Private helpers
    private class GetMoviesUseCaseMock: GetMoviesUseCaseProtocol {
        private(set) var getMoviesCallCount = 0
        var movies: [Movie]
        
        init(movies: [Movie] = [Movie]()) {
            self.movies = movies
        }
        
        func getMovies(type: MoviesType) async throws -> [Movie] {
            getMoviesCallCount += 1
            return movies
        }
    }
}
