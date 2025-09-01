//
//  RemoteMovieRepository.swift
//  MoviesTR
//
//  Created by Meharoof Najeeb on 2025-08-31.
//

import Foundation

final class RemoteMovieRepository: MovieRepository {
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
    
    private struct RemoteMovieDetail: Identifiable, Decodable {
        let id: Int
        let name: String
        let Description: String
        let Notes: String
        let Rating: Double
        let picture: String
        let releaseDate: TimeInterval
        
        var movieDetail: MovieDetail {
            return MovieDetail(id: id,
                               name: name,
                               description: Description,
                               notes: Notes,
                               rating: "\(Rating)",
                               imageURL: URL(string: picture)!,
                               releaseDate: Date(timeIntervalSince1970: releaseDate))
        }
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
    
    // MARK: - MovieDetailsFetching
    func fetchMovieDetails(for id: Int) async throws -> MovieDetail {
        guard let url = URL(string: String(format: "https://raw.githubusercontent.com/TradeRev/tr-ios-challenge/master/details/%d.json", id)) else {
            throw URLError(.badURL)
        }
        
        let data = try await networkService.fetchData(from: url)
        let movieDetail = (try JSONDecoder().decode(RemoteMovieDetail.self, from: data)).movieDetail
        return movieDetail
    }
}
