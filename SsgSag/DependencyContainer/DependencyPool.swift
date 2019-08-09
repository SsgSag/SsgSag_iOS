//
//  DependencyPool.swift
//  SsgSag
//
//  Created by 이혜주 on 27/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

class DependencyPool {
    private var dependencyPool: [DependencyKey: Any] = [:]
    
    func register<T>(key: DependencyKey, dependency: T) throws {
        
        guard dependencyPool[key] == nil else {
            throw DependencyError.keyAlreadyExistsError(key: key)
        }
        
        dependencyPool.updateValue(dependency, forKey: key)
    }
    
    func pullOutDependency<T>(key: DependencyKey) throws -> T {
        guard let rawDependency = dependencyPool[key] else {
            throw DependencyError.unregisteredKeyError(key: key)
        }
        
        guard let dependency = rawDependency as? T else {
            throw DependencyError.downcastingFailureError(key: key)
        }
        
        return dependency
    }
}

enum DependencyError: Error {
    case keyAlreadyExistsError(key: DependencyKey)
    case unregisteredKeyError(key: DependencyKey)
    case downcastingFailureError(key: DependencyKey)
}
