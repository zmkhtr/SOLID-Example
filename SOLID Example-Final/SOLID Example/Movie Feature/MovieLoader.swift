//
//  MovieLoader.swift
//  SOLID Example
//
//  Created by PT.Koanba on 24/09/22.
//

import Foundation

protocol MovieLoader {
    typealias Result = Swift.Result<[RemoteMovie], Error>
    
    func get(completion: @escaping (Result) -> Void)
}
