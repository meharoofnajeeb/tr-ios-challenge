//
//  MovieDetailsViewModelTests.swift
//  MoviesTRTests
//
//  Created by Meharoof Najeeb on 2025-09-01.
//

import XCTest
@testable import MoviesTR

@MainActor
final class MovieDetailsViewModelTests: XCTestCase {
    func test_loadContent_fetchesMovieDetailsAndUpdatesViewModelStates() async {
        let movieID = 1
        let movieDetails = getAnyMovieDetail(with: movieID)
        let (sut, getMovieDetailsUseCase, _, _) = makeSUT(movieID: movieID, withDetailsResult: .success(movieDetails), withRecommendedResult: .failure(anyNSError()))
        
        await sut.loadContent()
        
        XCTAssertEqual(getMovieDetailsUseCase.getMovieDetailsCallCount, 1)
        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(sut.movieDetails, movieDetails)
        XCTAssertNil(sut.errorMessage)
    }
    
    func test_loadContent_setsErrorOnFailure() async {
        let (sut, getMovieDetailsUseCase, _, _) = makeSUT(movieID: -1, withDetailsResult: .failure(anyNSError()), withRecommendedResult: .failure(anyNSError()))
        
        await sut.loadContent()
        
        XCTAssertEqual(getMovieDetailsUseCase.getMovieDetailsCallCount, 1)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.movieDetails)
        XCTAssertNotNil(sut.errorMessage)
    }
    
    func test_loadContent_deliversRecommendedMoviesAfterFetchingMovieDetails() async {
        let currentMovieID = 1
        let expectedMovies = [Movie(id: 2, name: "Movie 2", imageURL: URL(string: "https://some-url-2.com")!, year: "2000")]
        let (sut, getMovieDetailsUseCase, getMoviesUseCase, _) = makeSUT(movieID: currentMovieID, withDetailsResult: .success(getAnyMovieDetail(with: currentMovieID)), withRecommendedResult: .success(expectedMovies))
        
        await sut.loadContent()
        
        XCTAssertEqual(getMovieDetailsUseCase.getMovieDetailsCallCount, 1)
        XCTAssertEqual(getMoviesUseCase.getMoviesCallCount, 1)
        XCTAssertEqual(sut.recommendedMovies, expectedMovies)
        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoading)
    }
    
    func test_loadContent_doesNotFetchRecommendedMoviesWhenFetchingMovieDetailsFail() async {
        let currentMovieID = 1
        let expectedMovies = [Movie(id: 2, name: "Movie 2", imageURL: URL(string: "https://some-url-2.com")!, year: "2000")]
        let (sut, _, getMoviesUseCase, _) = makeSUT(movieID: currentMovieID, withDetailsResult: .failure(anyNSError()), withRecommendedResult: .success(expectedMovies))
        
        await sut.loadContent()
        
        XCTAssertEqual(sut.recommendedMovies, [])
        XCTAssertEqual(getMoviesUseCase.getMoviesCallCount, 0)
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoading)
    }
    
    func test_loadContent_updatesLikeStatusState() async {
        let likedMovies: Set<Int> = [1, 3, 5]
        let movieID = 1
        let (sut, _, _, likesUseCaseMock) = makeSUT(movieID: movieID, withDetailsResult: .success(getAnyMovieDetail(with: movieID)), withRecommendedResult: .failure(anyNSError()), likedMovies: likedMovies)
        
        await sut.loadContent()
        
        XCTAssertTrue(sut.isLiked)
        XCTAssertEqual(likesUseCaseMock.isLikedCallCount, 1)
    }
    
    func test_likeTapped_updatesLikeStatusState() {
        let movieID = 1
        let (sut, _, _, likesUseCaseMock) = makeSUT(movieID: movieID, withDetailsResult: .success(getAnyMovieDetail(with: movieID)), withRecommendedResult: .failure(anyNSError()))
        XCTAssertFalse(sut.isLiked)
        
        sut.likeTapped()
        
        XCTAssertTrue(sut.isLiked)
        XCTAssertEqual(likesUseCaseMock.toggleLikeCallCount, 1)
        
        sut.likeTapped()
        
        XCTAssertFalse(sut.isLiked)
        XCTAssertEqual(likesUseCaseMock.toggleLikeCallCount, 2)
    }
    
    //MARK: - Private helpers
    private func makeSUT(movieID: Int, withDetailsResult: Result<MovieDetail, Error>, withRecommendedResult: Result<[Movie], Error>, likedMovies: Set<Int> = []) -> (sut: MovieDetailViewModel, getMovieDetailUseCase: GetMovieDetailsUseCaseMock, getMoviesUseCase: GetMoviesUseCaseMock, likeStatusUseCase: LikesUseCaseMock) {
        let getMovieDetailsUseCase = GetMovieDetailsUseCaseMock(result: withDetailsResult)
        let getMoviesUseCase = GetMoviesUseCaseMock(result: withRecommendedResult)
        let likesUseCaseMock = LikesUseCaseMock(likedMovies: likedMovies)
        let sut = MovieDetailViewModel(movieID: movieID, getMovieDetailsUseCase: getMovieDetailsUseCase, getMoviesUseCase: getMoviesUseCase, getLikeStatusUseCase: likesUseCaseMock, toggleLikeUseCase: likesUseCaseMock)
        return (sut, getMovieDetailsUseCase, getMoviesUseCase, likesUseCaseMock)
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
