//
//  URLSessionHTTPClient.swift
//  SOLID Example
//
//  Created by PT.Koanba on 24/09/22.
//

import Foundation

class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    
    private struct UnexpectedValuesRepresentation : Error {}

    public init(session: URLSession) {
        self.session = session
    }
    
    func request(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
        session.dataTask(with: url) { data, response, error in
            if let data = data, let response = response as? HTTPURLResponse {
                completion(.success((data, response)))
            } else if let error = error {
                completion(.failure(error))
            } else {
                completion(.failure(UnexpectedValuesRepresentation()))
            }
        }.resume()
    }
}
