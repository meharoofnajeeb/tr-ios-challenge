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
        let (data, _) = try await session.data(from: url)
        
        return data
    }
}

final class NetworkServiceTests: XCTestCase {
    func test_fetchData_deliversDataOnSuccessfulResponse() async throws {
        let expectedData = Data("{}".utf8)
        let url = URL(string: "https://any-url.com")!
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)
        let sut = NetworkService(session: session)
        URLProtocolStub.requestHandler = { request in
            XCTAssertEqual(request.url, url)
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (expectedData, response)
        }
        
        let resultData = try await sut.fetchData(from: url)
        
        XCTAssertEqual(resultData, expectedData)
    }
    
    // MARK: - Private helpers
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
