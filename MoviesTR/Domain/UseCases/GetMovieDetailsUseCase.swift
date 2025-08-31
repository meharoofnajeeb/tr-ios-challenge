//
//  GetMovieDetailsUseCase.swift
//  MoviesTR
//
//  Created by Meharoof Najeeb on 2025-08-31.
//

final class GetMovieDetailUseCase {
    private let fetcher: MovieDetailFetching
    
    init(fetcher: MovieDetailFetching) {
        self.fetcher = fetcher
    }
    
    func getMovieDetails(for id: Int) async throws -> MovieDetail {
        return try await fetcher.fetchMovieDetails(for: id)
    }
}
