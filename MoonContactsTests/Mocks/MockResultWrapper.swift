//
//  MockResultWrapper.swift
//  MoonContactsTests
//
//  Created by Alper Öztürk on 22.12.2021.

/*
 We added MockURLProtocol to this response handler and made it usable in our tests.
 */

//
import Combine
import Foundation
@testable import MoonContacts

struct MockResultWrapper {
    var session:URLSession!
    var config:URLSessionConfiguration!
    
    struct Response<T> {
        let value: T
        let response: URLResponse
    }
    
    init() {
        config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        session = URLSession(configuration: config)
    }
    
    func mockPublisher(url:String) -> AnyPublisher<Employees, Error>? {
        guard let url = URL(string: url) else {
            return nil
        }
        
        let request = URLRequest(url: url)
        return run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    func run<T: Decodable>(_ request: URLRequest, _ decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<Response<T>, Error> {
        return session
            .dataTaskPublisher(for: request)
            .tryMap { result -> Response<T> in
                let value = try decoder.decode(T.self, from: result.data)
                return Response(value: value, response: result.response)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}
