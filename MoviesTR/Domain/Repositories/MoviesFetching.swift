//
//  MovieRepository.swift
//  MoviesTR
//
//  Created by Meharoof Najeeb on 2025-08-30.
//

enum MoviesType {
    case all
    case recommended
}

protocol MoviesFetching {
    func fetchMovies(type: MoviesType) async throws -> [Movie]
}
