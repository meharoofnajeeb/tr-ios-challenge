//
//  NetworkServiceTests.swift
//  MoviesTR
//
//  Created by Meharoof Najeeb on 2025-08-31.
//

import XCTest
@testable import MoviesTR

final class NetworkServiceTests: XCTestCase {
    func test_fetchData_deliversDataOnSuccessfulResponse() async throws {
        let expectedData = Data("{}".utf8)
        let url = URL(string: "https://any-url.com")!
        let sut = makeSUT()
        URLProtocolStub.requestHandler = { [weak self] request in
            XCTAssertEqual(request.url, url)
            guard let response = self?.anyHTTPURLResponse(with: url, responseCode: 200) else {
                fatalError("Possible memory issue.")
            }
            return (expectedData, response)
        }
        
        let resultData = try await sut.fetchData(from: url)
        
        XCTAssertEqual(resultData, expectedData)
    }
    
    
    
    func test_fetchData_throwsErrorOnNon200StatusCode() async {
        let url = URL(string: "https://not-found-url.com")!
        let sut = makeSUT()
        URLProtocolStub.requestHandler = { [weak self] request in
            guard let response = self?.anyHTTPURLResponse(with: url, responseCode: 404) else {
                fatalError("Possible memory issue.")
            }
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
        addTeardownBlock {
            URLProtocolStub.requestHandler = nil
        }
        return sut
    }
    
    private func anyHTTPURLResponse(with url: URL, responseCode: Int) -> HTTPURLResponse {
        return HTTPURLResponse(url: url, statusCode: responseCode, httpVersion: nil, headerFields: nil)!
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
