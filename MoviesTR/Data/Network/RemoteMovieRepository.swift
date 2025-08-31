//
//  RemoteMovieRepository.swift
//  MoviesTR
//
//  Created by Meharoof Najeeb on 2025-08-31.
//

import Foundation

final class RemoteMovieRepository: MoviesFetching {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    private struct Root: Decodable {
        let movies: [RemoteMovie]
        
        var movieObjects: [Movie] {
            return movies.map { Movie(id: $0.id, name: $0.name, imageURL: URL(string: $0.thumbnail)!, year: "\($0.year)") }
        }
    }
    
    private struct RemoteMovie: Identifiable, Decodable {
        let id: Int
        let name: String
        let thumbnail: String
        let year: Int
    }
    
    // MARK: - MoviesFetching
    func fetchMovies(type: MoviesType) async throws -> [Movie] {
        let url: URL
        switch type {
        case .all:
            url = URL(string: "https://raw.githubusercontent.com/TradeRev/tr-ios-challenge/master/list.json")!
        case .recommended(let id):
            url = URL(string: String(format: "https://raw.githubusercontent.com/TradeRev/tr-ios-challenge/master/details/recommended/%d.json", id))!
        }
        let data = try await networkService.fetchData(from: url)
        let results = (try JSONDecoder().decode(Root.self, from: data)).movieObjects
        return results
    }
}
