//
//  Router.swift
//  SsgSag
//
//  Created by admin on 12/04/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

class Router<EndPoint: EndPointType>: NetworkRouter {
    
    //do not wnat anyoune ouside this class modifying this task
    private var task: URLSessionTask?
    
    func request(_ route: EndPoint, completion: @escaping NetworRouterCompletion) {
        let session = URLSession.shared
        
        do {
            let request = try self.buildRequest(from:route)
            task = session.dataTask(with: request, completionHandler: { (data, response, error) in
                completion(data, response, error)
            })
        } catch {
            completion(nil, nil, error)
        }
        self.task?.resume()
    }
    
    func cancel() {
        
    }
    
    /// This function is responsible for all the vital work in our network layer.
    ///
    /// 1. We instantiate a variable request of type URLRequest. Give it our base URL and append the specific path we are going to use.
    ///
    /// 2. We set the httpMethod of the request equal to that of our EndPoint.
    ///
    /// 3. We create a do-try-catch block since our encoders throws an error. By creating one big do-try-catch block we don’t have to create a separate block for each try.
    ///
    ///
    /// 4. Switch on route.task
    ///
    /// 5. Depending on the task, call the appropriate encoder.
    
    fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest {
        
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10.0)
        request.httpMethod = route.httpMethod.rawValue
        
        do {
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            case .requestParameters(bodyParameters: let bodyParameters, urlParameters: let urlParameters):
                
                try self.configureParameters(bodyParameters: bodyParameters,
                                             urlParameters: urlParameters,
                                             request: &request)
                
            case .requestParametersAndHeaders(bodyParameters: let bodyParameters, urlParameters: let urlParameters, additionHeaders: let additionalHeaders):
                
                self.addAdditionalHeaders(additionalHeaders, request: &request)
                
                try self.configureParameters(bodyParameters: bodyParameters,
                                             urlParameters: urlParameters,
                                             request: &request)
            }
            
            return request
        } catch {
            throw error
        }
    }
    
    fileprivate func configureParameters(bodyParameters: Parameters?,
                                         urlParameters: Parameters?,
                                         request: inout URLRequest) throws {
        do {
            if let bodyParameters = bodyParameters {
                try JSONParamterEncoder.encode(urlRequest: &request, with: bodyParameters)
            }
            
            if let urlParameters = urlParameters {
                try URLParameterEncoder.encode(urlRequest: &request, with: urlParameters)
            }
            
        } catch {
            throw error
        }
    }
    
    fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
}
