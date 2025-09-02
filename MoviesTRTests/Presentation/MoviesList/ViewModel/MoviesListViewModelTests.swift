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
        let mockMovies = [getAnyMovieDetail(with: 1)]
        let (sut, getMoviesUseCase, _) = makeSUT(withResult: .success(mockMovies))
        
        await sut.fetchMovies()
        
        XCTAssertEqual(getMoviesUseCase.getMoviesCallCount, 1)
        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(sut.movies, mockMovies)
        XCTAssertNil(sut.errorMessage)
    }
    
    func test_fetchMovies_setsErrorOnFailure() async {
        let expectedError = NSError(domain: "Test", code: -1)
        let (sut, _, _) = makeSUT(withResult: .failure(expectedError))
        
        await sut.fetchMovies()
        
        XCTAssertFalse(sut.isLoading)
        XCTAssertTrue(sut.movies.isEmpty)
        XCTAssertNotNil(sut.errorMessage)
    }

    func test_isLiked_returnsCorrectStatusForEachMovie() async {
        let likedMovies: Set<Int> = [1, 3]
        let movies = [getAnyMovieDetail(with: 1), getAnyMovieDetail(with: 3), getAnyMovieDetail(with: 5)]
        let (sut, _, likesUseCase) = makeSUT(withResult: .success(movies), likedMovies: likedMovies)
        await sut.fetchMovies()
        
        for movie in sut.movies {
            XCTAssertEqual(sut.isLiked(movieID: movie.id), likedMovies.contains(movie.id))
        }
        
        XCTAssertEqual(likesUseCase.isLikedCallCount, movies.count)
    }
    
    func test_toggleLike_callsUseCaseAndRefreshesState() async {
        let movies = [getAnyMovieDetail(with: 1), getAnyMovieDetail(with: 3), getAnyMovieDetail(with: 5)]
        let (sut, _, likesUseCase) = makeSUT(withResult: .success(movies))
        await sut.fetchMovies()
        
        sut.toggleLiked(movieID: 1)
        
        XCTAssertEqual(likesUseCase.toggleLikeCallCount, 1)
        XCTAssertTrue(sut.isLiked(movieID: 1))
        XCTAssertEqual(likesUseCase.isLikedCallCount, 1)
    }
    
    // MARK: - Private helpers
    private func makeSUT(withResult result: Result<[Movie], Error>, likedMovies: Set<Int> = []) -> (sut: MoviesListViewModel, getMoviesUseCase: GetMoviesUseCaseMock, likesUseCase: LikesUseCaseMock) {
        let getMoviesUseCase = GetMoviesUseCaseMock(result: result)
        let likesUseCase = LikesUseCaseMock(likedMovies: likedMovies)
        let sut = MoviesListViewModel(getMoviesUseCase: getMoviesUseCase, getLikeStatusUseCase: likesUseCase, toggleLikeUseCase: likesUseCase)
        return (sut, getMoviesUseCase, likesUseCase)
    }
    
    private func getAnyMovieDetail(with id: Int) -> Movie {
        return Movie(id: id,
                     name: "Movie \(id)",
                     imageURL: URL(string: "http://some-url-\(id).com")!,
                     year: "2000")
    }
}
