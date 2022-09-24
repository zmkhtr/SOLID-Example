//
//  RemoteMovieLoader.swift
//  SOLID Example
//
//  Created by PT.Koanba on 24/09/22.
//

import Foundation

class RemoteMovieLoader: MovieLoader {
    private let url: URL
    private let client: HTTPClient
    
    typealias Result = MovieLoader.Result
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func get(completion: @escaping (Result) -> Void) {
        client.request(from: url) { result in
            switch result {
            case let .success((data, response)):
                completion(RemoteMovieLoader.map(data, from: response))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let items = try MovieItemMapper.map(data, from: response)
            return .success(items)
        } catch {
            return .failure(error)
        }
    }
}
