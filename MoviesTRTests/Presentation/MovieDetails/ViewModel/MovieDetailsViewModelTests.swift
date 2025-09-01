//
//  MovieDetailsViewModelTests.swift
//  MoviesTRTests
//
//  Created by Meharoof Najeeb on 2025-09-01.
//

import XCTest
@testable import MoviesTR

final class MovieDetailsViewModelTests: XCTestCase {
    func test_fetchMovieDetails_fetchesMovieDetailsAndUpdatesViewModelStates() async {
        let movieID = 1
        let movieDetails = getAnyMovieDetail(with: movieID)
        let (sut, getMovieDetailsUseCase) = makeSUT(withResult: .success(movieDetails), movieID: movieID)
        
        await sut.fetchMovieDetails()
        
        XCTAssertEqual(getMovieDetailsUseCase.getMovieDetailsCallCount, 1)
        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(sut.movieDetails, movieDetails)
        XCTAssertNil(sut.errorMessage)
    }
    
    func test_fetchMovieDetails_setsErrorOnFailure() async {
        let expectedError = NSError(domain: "Test", code: -1)
        let (sut, _) = makeSUT(withResult: .failure(expectedError), movieID: -1)
        
        await sut.fetchMovieDetails()
        
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.movieDetails)
        XCTAssertNotNil(sut.errorMessage)
    }
    
    //MARK: - Private helpers
    private func makeSUT(withResult result: Result<MovieDetail, Error>, movieID: Int) -> (sut: MovieDetailViewModel, getMovieDetailUseCase: GetMovieDetailsUseCaseMock) {
        let getMovieDetailsUseCase = GetMovieDetailsUseCaseMock(result: result)
        let sut = MovieDetailViewModel(getMovieDetailsUseCase: getMovieDetailsUseCase, movieID: movieID)
        return (sut, getMovieDetailsUseCase)
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
