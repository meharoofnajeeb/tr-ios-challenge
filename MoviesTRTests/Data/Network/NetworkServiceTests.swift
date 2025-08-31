//
//  NetworkServiceTests.swift
//  MoviesTR
//
//  Created by Meharoof Najeeb on 2025-08-31.
//

import XCTest
@testable import MoviesTR

final class NetworkService {
    let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchData(from url: URL) async throws -> Data {
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        return data
    }
}

final class NetworkServiceTests: XCTestCase {
    func test_fetchData_deliversDataOnSuccessfulResponse() async throws {
        let expectedData = Data("{}".utf8)
        let url = URL(string: "https://any-url.com")!
        let sut = makeSUT()
        URLProtocolStub.requestHandler = { request in
            XCTAssertEqual(request.url, url)
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (expectedData, response)
        }
        
        let resultData = try await sut.fetchData(from: url)
        
        XCTAssertEqual(resultData, expectedData)
    }
    
    
    
    func test_fetchData_throwsErrorOnNon200StatusCode() async {
        let url = URL(string: "https://not-found-url.com")!
        let sut = makeSUT()
        URLProtocolStub.requestHandler = { request in
            let response = HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil)!
            return (Data(), response)
        }
        
        do {
            _ = try await sut.fetchData(from: url)
            XCTFail("Expected error. Got success instead.")
        } catch {
            XCTAssertEqual((error as? URLError)?.code, .badServerResponse)
        }
    }
    
    // MARK: - Private helpers
    private func makeSUT() -> NetworkService {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)
        let sut = NetworkService(session: session)
        return sut
    }
    
    private class URLProtocolStub: URLProtocol {
        static var requestHandler: ((URLRequest) throws -> (Data, HTTPURLResponse))?

        override class func canInit(with request: URLRequest) -> Bool {
            return true
        }

        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }

        override func startLoading() {
            guard let handler = URLProtocolStub.requestHandler else {
                fatalError("Handler is not set.")
            }
            
            do {
                let (data, response) = try handler(request)
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                client?.urlProtocol(self, didLoad: data)
                client?.urlProtocolDidFinishLoading(self)
            } catch {
                client?.urlProtocol(self, didFailWithError: error)
            }
        }

        override func stopLoading() {}
    }
}
