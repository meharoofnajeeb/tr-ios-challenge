//
//  MovieRepository.swift
//  MoviesTR
//
//  Created by Meharoof Najeeb on 2025-08-30.
//

enum MoviesType {
    case all
    case recommended(Int)
}

protocol MoviesFetching {
    func fetchMovies(type: MoviesType) async throws -> [Movie]
}

protocol MovieDetailFetching {
    func fetchMovieDetails(for id: Int) async throws -> MovieDetail
}

typealias MovieRepository = MoviesFetching & MovieDetailFetching
