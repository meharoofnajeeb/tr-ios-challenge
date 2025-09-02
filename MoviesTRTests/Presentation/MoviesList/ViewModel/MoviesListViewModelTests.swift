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
        let (sut, getMoviesUseCase) = makeSUT(withResult: .success(mockMovies))
        
        await sut.fetchMovies()
        
        XCTAssertEqual(getMoviesUseCase.getMoviesCallCount, 1)
        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(sut.movies, mockMovies)
        XCTAssertNil(sut.errorMessage)
    }
    
    func test_fetchMovies_setsErrorOnFailure() async {
        let expectedError = NSError(domain: "Test", code: -1)
        let (sut, _) = makeSUT(withResult: .failure(expectedError))
        
        await sut.fetchMovies()
        
        XCTAssertFalse(sut.isLoading)
        XCTAssertTrue(sut.movies.isEmpty)
        XCTAssertNotNil(sut.errorMessage)
    }

    // MARK: - Private helpers
    private func makeSUT(withResult result: Result<[Movie], Error>) -> (sut: MoviesListViewModel, getMoviesUseCase: GetMoviesUseCaseMock){
        let getMoviesUseCase = GetMoviesUseCaseMock(result: result)
        let sut = MoviesListViewModel(getMoviesUseCase: getMoviesUseCase)
        return (sut, getMoviesUseCase)
    }
}
