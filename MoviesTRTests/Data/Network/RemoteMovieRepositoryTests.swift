//
//  RemoteMovieRepositoryTests.swift
//  MoviesTRTests
//
//  Created by Meharoof Najeeb on 2025-08-31.
//

import XCTest
@testable import MoviesTR

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

final class RemoteMovieRepositoryTests: XCTestCase {

    func test_fetchMovies_forAllMovies_constructsURLCorrectlyForAllMovies() async throws {
        let json = makeJsonMovieData()
        let sut = makeSUT()
        URLProtocolStub.requestHandler = { [weak self] request in
            XCTAssertEqual(request.url?.absoluteString, self?.listAllURLString)
            guard let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil) else {
                XCTFail("Error forming URL.")
                throw URLError(.badURL)
            }
            return (json, response)
        }
        
        _ = try await sut.fetchMovies(type: .all)
    }
    
    func test_fetchMovies_forRecommendedMovies_constructsAppropriateURLForRecommendedMovies() async throws {
        let movieID = 2
        let json = makeJsonMovieData(movieID: movieID)
        let sut = makeSUT()
        URLProtocolStub.requestHandler = { [weak self] request in
            guard let self else {
                fatalError("Potential memory issue.")
            }
            let recommendedURLString = String(format: "\(self.recommendedListURLString)", movieID)
            XCTAssertEqual(request.url?.absoluteString, recommendedURLString)
            guard let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil) else {
                XCTFail("Error forming URL.")
                throw URLError(.badURL)
            }
            return (json, response)
        }
        
        _ = try await sut.fetchMovies(type: .recommended(movieID))
    }
    
    func test_fetchMovies_forAllMovies_deliversDataSuccessfullyOnSuccessfulHTTPURLResponse() async throws {
        let json = makeJsonMovieData()
        let sut = makeSUT()
        URLProtocolStub.requestHandler = { request in
            guard let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil) else {
                throw URLError(.badURL)
            }
            return (json, response)
        }
        
        let movies = try await sut.fetchMovies(type: .all)
        
        XCTAssertEqual(movies.count, 1)
        XCTAssertEqual(movies.first?.id, 1)
        XCTAssertEqual(movies.first?.name, "Movie 1")
        XCTAssertEqual(movies.first?.imageURL, URL(string: "https://image-urls.com/1.jpg"))
        XCTAssertEqual(movies.first?.year, "2000")
    }
    
    func test_fetchMovies_deliversErrorOnNon200HTTPURLResponse() async throws {
        let sut = makeSUT()
        
        URLProtocolStub.requestHandler = { request in
            guard let response = HTTPURLResponse(url: URL(string: "https://any-url-com")!, statusCode: 500, httpVersion: nil, headerFields: nil) else {
                throw URLError(.badServerResponse)
            }
            return (Data(), response)
        }
        
        do {
            _ = try await sut.fetchMovies(type: .all)
            XCTFail("Expected error. Got success instead.")
        } catch {
            guard let urlError = error as? URLError else {
                XCTFail("Expected URLError. Got \(error) instead.")
                return
            }
            XCTAssertEqual(urlError.code, .badServerResponse, "Expected badServerResponse error code.")
        }
    }
    
    //MARK: - Private helpers
    private func makeSUT() -> RemoteMovieRepository {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)
        let networkService = NetworkService(session: session)
        addTeardownBlock {
            URLProtocolStub.requestHandler = nil
        }
        let sut = RemoteMovieRepository(networkService: networkService)
        return sut
    }
    
    private func makeJsonMovieData(movieID: Int = 1, year: Int = 2000) -> Data {
        return """
{
    "movies" : [
        {
            "id": \(movieID),
            "name": "Movie \(movieID)",
            "thumbnail": "https://image-urls.com/\(movieID).jpg",
            "year": \(year)
        }
    ]
}
""".data(using: .utf8)!
    }
    
    private var listAllURLString: String {
        return "https://raw.githubusercontent.com/TradeRev/tr-ios-challenge/master/list.json"
    }
    
    private var recommendedListURLString: String {
        return "https://raw.githubusercontent.com/TradeRev/tr-ios-challenge/master/details/recommended/%d.json"
    }
}
