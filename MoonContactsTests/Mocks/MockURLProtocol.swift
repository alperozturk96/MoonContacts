//
//  MockURLProtocol.swift
//  MoonContactsTests
//
//  Created by Alper Öztürk on 22.12.2021.

/*
    We've made these additions to URLProtocol to make sure we're not making real network requests.
    Unit test should be fast and indepented the real api call.
*/

//

import Foundation
import XCTest

class MockURLProtocol: URLProtocol {
    static var stubResponseHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override class func canInit(with task: URLSessionTask) -> Bool {
       return true
     }
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = MockURLProtocol.stubResponseHandler else {
            XCTFail("Received unexpected request with no handler set")
            return
        }
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {
        
    }
}
