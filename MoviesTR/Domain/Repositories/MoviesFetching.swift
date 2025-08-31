//
//  MovieRepository.swift
//  MoviesTR
//
//  Created by Meharoof Najeeb on 2025-08-30.
//

protocol MoviesFetching {
    func fetchAllMovies() async throws -> [Movie]
}
