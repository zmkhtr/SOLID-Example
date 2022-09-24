//
//  HTTPClient.swift
//  SOLID Example
//
//  Created by PT.Koanba on 24/09/22.
//

import Foundation

protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    func request(from url : URL, completion: @escaping (Result) -> Void)
}
