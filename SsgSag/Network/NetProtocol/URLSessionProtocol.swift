//
//  URLSessionProtocol.swift
//  SsgSag
//
//  Created by bumslap on 23/11/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

public protocol URLResponseProtocol {
    var isSuccess: Bool { get }
    var url: URL? { get }
    
}

extension URLResponse {
    
    public var isSuccess: Bool {
        guard let response = self as? HTTPURLResponse else { return false }
        return (200...299).contains(response.statusCode)
    }
    

}

extension URLResponse: URLResponseProtocol {

}

public protocol URLSessionTaskProtocol {
    var state: URLSessionTask.State { get }
    
    func resume()
    func cancel()
}

public protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponseProtocol?, Error?) -> Void) -> URLSessionTaskProtocol
    
    
    func dataTask(with url: URL,
                  completionHandler: @escaping (Data?, URLResponseProtocol?, Error?) -> Void)
        -> URLSessionTaskProtocol
}

extension URLSession: URLSessionProtocol {
    
    public func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponseProtocol?, Error?) -> Void) -> URLSessionTaskProtocol {
        return (dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask) as URLSessionTaskProtocol
    }
    
    public func dataTask(with url: URL,
                  completionHandler: @escaping (Data?, URLResponseProtocol?, Error?) -> Void)
        -> URLSessionTaskProtocol {
            
            return (dataTask(with: url, completionHandler: completionHandler) as URLSessionDataTask) as  URLSessionTaskProtocol
    }
}

extension URLSessionTask: URLSessionTaskProtocol {
    
}


