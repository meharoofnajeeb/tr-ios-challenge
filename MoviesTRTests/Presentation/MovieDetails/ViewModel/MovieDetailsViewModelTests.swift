//
//  MovieDetailsViewModelTests.swift
//  MoviesTRTests
//
//  Created by Meharoof Najeeb on 2025-09-01.
//

import XCTest
@testable import MoviesTR

final class MovieDetailsViewModelTests: XCTestCase {
    func test_loadContent_fetchesMovieDetailsAndUpdatesViewModelStates() async {
        let movieID = 1
        let movieDetails = getAnyMovieDetail(with: movieID)
        let (sut, getMovieDetailsUseCase, _) = makeSUT(withDetailsResult: .success(movieDetails), withRecommendedResult: .failure(anyNSError()), movieID: movieID)
        
        await sut.loadContent()
        
        XCTAssertEqual(getMovieDetailsUseCase.getMovieDetailsCallCount, 1)
        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(sut.movieDetails, movieDetails)
        XCTAssertNil(sut.errorMessage)
    }
    
    func test_loadContent_setsErrorOnFailure() async {
        let (sut, _, _) = makeSUT(withDetailsResult: .failure(anyNSError()), withRecommendedResult: .failure(anyNSError()), movieID: -1)
        
        await sut.loadContent()
        
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.movieDetails)
        XCTAssertNotNil(sut.errorMessage)
    }
    
    func test_loadContent_deliversRecommendedMoviesAfterFetchingMovieDetails() async {
        let currentMovieID = 1
        let expectedMovies = [Movie(id: 2, name: "Movie 2", imageURL: URL(string: "https://some-url-2.com")!, year: "2000")]
        let (sut, _, _) = makeSUT(withDetailsResult: .success(getAnyMovieDetail(with: currentMovieID)), withRecommendedResult: .success(expectedMovies), movieID: currentMovieID)
        
        await sut.loadContent()
        
        XCTAssertEqual(sut.recommendedMovies, expectedMovies)
        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoading)
    }
    
    func test_loadContent_doesNotFetchRecommendedMoviesWhenFetchingMovieDetailsFail() async {
        let currentMovieID = 1
        let expectedMovies = [Movie(id: 2, name: "Movie 2", imageURL: URL(string: "https://some-url-2.com")!, year: "2000")]
        let (sut, _, getMoviesUseCase) = makeSUT(withDetailsResult: .failure(anyNSError()), withRecommendedResult: .success(expectedMovies), movieID: currentMovieID)
        
        await sut.loadContent()
        
        XCTAssertEqual(sut.recommendedMovies, [])
        XCTAssertEqual(getMoviesUseCase.getMoviesCallCount, 0)
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoading)
    }
    
    //MARK: - Private helpers
    private func makeSUT(withDetailsResult: Result<MovieDetail, Error>, withRecommendedResult: Result<[Movie], Error>, movieID: Int) -> (sut: MovieDetailViewModel, getMovieDetailUseCase: GetMovieDetailsUseCaseMock, getMoviesUseCase: GetMoviesUseCaseMock) {
        let getMovieDetailsUseCase = GetMovieDetailsUseCaseMock(result: withDetailsResult)
        let getMoviesUseCase = GetMoviesUseCaseMock(result: withRecommendedResult)
        let sut = MovieDetailViewModel(getMovieDetailsUseCase: getMovieDetailsUseCase, getMoviesUseCase: getMoviesUseCase, movieID: movieID)
        return (sut, getMovieDetailsUseCase, getMoviesUseCase)
    }
    
    private func getAnyMovieDetail(with id: Int) -> MovieDetail {
        return MovieDetail(id: id,
                           name: "Movie \(id)",
                           description: "Some description for Movie \(id)",
                           notes: "Some notes for Movie \(id)",
                           rating: "10.0",
                           imageURL: URL(string: "http://some-url.com")!,
                           releaseDate: Date())
    }
    
    private func anyNSError() -> NSError {
        return NSError(domain: "Test", code: 1)
    }
    
    private class GetMovieDetailsUseCaseMock: GetMovieDetailsUseCaseProtocol {
        private(set) var getMovieDetailsCallCount = 0
        var result: Result<MovieDetail, Error>
        
        init(result: Result<MovieDetail, Error>) {
            self.result = result
        }
        
        func getMovieDetails(for id: Int) async throws -> MovieDetail {
            getMovieDetailsCallCount += 1
            return try result.get()
        }
    }
}
