//
//  GetMoviesUseCaseMock.swift
//  MoviesTR
//
//  Created by Meharoof Najeeb on 2025-09-01.
//

@testable import MoviesTR

class GetMoviesUseCaseMock: GetMoviesUseCaseProtocol {
    private(set) var getMoviesCallCount = 0
    var result: Result<[Movie], Error>
    
    init(result: Result<[Movie], Error>) {
        self.result = result
    }
    
    func getMovies(type: MoviesType) async throws -> [Movie] {
        getMoviesCallCount += 1
        return try result.get()
    }
}
