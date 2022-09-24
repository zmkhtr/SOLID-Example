//
//  MovieItemMapper.swift
//  SOLID Example
//
//  Created by PT.Koanba on 24/09/22.
//

import Foundation

final class MovieItemMapper {
    
    enum Error: Swift.Error {
        case invalidData
    }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteMovie] {
        guard response.statusCode == 200, let root = try? JSONDecoder().decode([RemoteMovie].self, from: data) else {
            throw Error.invalidData
        }
        
        return root
    }
}
