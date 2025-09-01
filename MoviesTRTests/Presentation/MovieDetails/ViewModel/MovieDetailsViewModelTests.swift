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
        let getMovieDetailsUseCase = GetMovieDetailsUseCaseMock(movieDetails: movieDetails)
        let sut = MovieDetailViewModel(getMovieDetailsUseCase: getMovieDetailsUseCase, movieID: movieID)
        
        await sut.fetchMovieDetails()
        
        XCTAssertEqual(getMovieDetailsUseCase.getMovieDetailsCallCount, 1)
        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(sut.movieDetails, movieDetails)
        XCTAssertNil(sut.errorMessage)
    }
    
    //MARK: - Private helpers
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
        var movieDetails: MovieDetail?
        
        init(movieDetails: MovieDetail? = nil) {
            self.movieDetails = movieDetails
        }
        
        func getMovieDetails(for id: Int) async throws -> MovieDetail {
            getMovieDetailsCallCount += 1
            return movieDetails!
        }
    }
}
