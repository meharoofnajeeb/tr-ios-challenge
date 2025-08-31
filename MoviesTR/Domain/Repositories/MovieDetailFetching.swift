//
//  MovieDetailFetching.swift
//  MoviesTR
//
//  Created by Meharoof Najeeb on 2025-08-30.
//

protocol MovieDetailFetching {
    func fetchMovieDetails(for id: Int) async throws -> MovieDetail
}
