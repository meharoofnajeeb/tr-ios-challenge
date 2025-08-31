//
//  GetMoviesUseCase.swift
//  MoviesTR
//
//  Created by Meharoof Najeeb on 2025-08-30.
//

final class GetMoviesUseCase {
    private let fetcher: MoviesFetching
    
    init(fetcher: MoviesFetching) {
        self.fetcher = fetcher
    }
    
    func getMovies() async throws -> [Movie] {
        return try await fetcher.fetchAllMovies()
    }
}
