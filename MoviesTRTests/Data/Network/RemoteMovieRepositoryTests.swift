//
//  RemoteMovieRepositoryTests.swift
//  MoviesTRTests
//
//  Created by Meharoof Najeeb on 2025-08-31.
//

import XCTest
@testable import MoviesTR

final class RemoteMovieRepositoryTests: XCTestCase {

    func test_fetchMovies_forAllMovies_constructsURLCorrectlyForAllMovies() async throws {
        let json = makeJsonMoviesData()
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
        let json = makeJsonMoviesData(movieID: movieID)
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
        let json = makeJsonMoviesData()
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
    
    func test_fetchMovies_deliversErrorOnDecodingError() async throws {
        let invalidJson = "".data(using: .utf8)!
        let sut = makeSUT()
        
        URLProtocolStub.requestHandler = { request in
            guard let response = HTTPURLResponse(url: URL(string: "https://any-url-com")!, statusCode: 200, httpVersion: nil, headerFields: nil) else {
                throw URLError(.badServerResponse)
            }
            return (invalidJson, response)
        }
        
        do {
            _ = try await sut.fetchMovies(type: .all)
            XCTFail("Expected error. Got success instead.")
        } catch {
            XCTAssertNotNil(error as? DecodingError)
        }
    }
    
    func test_fetchMovieDetails_constructsURLCorrectly() async throws {
        let movieID = 1
        let json = """
{
    "id": \(movieID),
      "name": "Movie \(movieID)",
      "Description": "Some random description for Movie \(movieID)",
      "Notes": "Some random notes for Movie \(movieID)",
      "Rating": 10,
      "picture": "https://raw.githubusercontent.com/TradeRev/tr-ios-challenge/master/details/\(movieID).jpg",
      "releaseDate": 946684800
}
""".data(using: .utf8)!
        let sut = makeSUT()
        
        URLProtocolStub.requestHandler = { [weak self] request in
            guard let self else {
                fatalError("Potential memory issue.")
            }
            let movieDetailsURLString = String(format: "\(self.movieDetailsURLString)", movieID)
            XCTAssertEqual(request.url?.absoluteString, movieDetailsURLString)
            guard let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil) else {
                XCTFail("Error forming URL.")
                throw URLError(.badURL)
            }
            return (json, response)
        }
        
        _ = try await sut.fetchMovieDetails(for: movieID)
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
    
    private func makeJsonMoviesData(movieID: Int = 1, year: Int = 2000) -> Data {
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
    
    private var movieDetailsURLString: String {
        return "https://raw.githubusercontent.com/TradeRev/tr-ios-challenge/master/details/%d.json"
    }
}
