//
//  HttpStatusCode.swift
//  SsgSag
//
//  Created by 이혜주 on 30/10/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

enum HttpStatusCode: Int, Error {
    
    case sucess = 200
    case secondSucess = 201
    case processingSuccess = 204
    case requestError = 400
    case authenticationFailure = 401
    case authorizationFailure = 403
    case failure = 404
    case dataBaseError = 600
    case serverError = 500
    
    func throwError() throws {
        switch self {
        case .authorizationFailure:
            throw HttpStatusCode.authorizationFailure
        case .failure:
            throw HttpStatusCode.failure
        case .dataBaseError:
            throw HttpStatusCode.dataBaseError
        case .serverError:
            throw HttpStatusCode.serverError
        default:
            break
        }
    }
    
}
