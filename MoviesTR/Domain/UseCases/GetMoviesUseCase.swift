//
//  GetMoviesUseCase.swift
//  MoviesTR
//
//  Created by Meharoof Najeeb on 2025-08-30.
//

protocol GetMoviesUseCaseProtocol {
    func getMovies(type: MoviesType) async throws -> [Movie]
}

final class GetMoviesUseCase: GetMoviesUseCaseProtocol {
    private let fetcher: MoviesFetching
    
    init(fetcher: MoviesFetching) {
        self.fetcher = fetcher
    }
    
    func getMovies(type: MoviesType = .all) async throws -> [Movie] {
        return try await fetcher.fetchMovies(type: type)
    }
}
