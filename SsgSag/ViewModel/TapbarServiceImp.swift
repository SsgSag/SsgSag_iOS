//
//  TapbarServiceImp.swift
//  SsgSag
//
//  Created by admin on 05/05/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

protocol TapbarService: class {
    func requestAllTodoList(completionHandler: @escaping (DataResponse<[Posters]>) -> Void)
    
    func requestIsInUpdateServer(completionHandler: @escaping (DataResponse<UpdateNetworkModel>) -> Void)
}

class TapbarServiceImp: TapbarService {
    
    func requestIsInUpdateServer(completionHandler: @escaping (DataResponse<UpdateNetworkModel>) -> Void) {
        guard let url = UserAPI.sharedInstance.getURL(RequestURL.isUpdate.getRequestURL) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        NetworkManager.shared.getData(with: request) { (data, error, response) in
            guard let data = data else { return }
            
            do {
                let dataFromNetwork = try JSONDecoder().decode(UpdateNetworkModel.self, from: data)
                
                completionHandler(DataResponse.success(dataFromNetwork))
            } catch {
                print("requestIsInUpdateServer Parsing Error")
            }
        }
    }
    
    func requestAllTodoList(completionHandler: @escaping (DataResponse<[Posters]>) -> Void) {
        
        guard let url = UserAPI.sharedInstance.getURL(RequestURL.allTodoList.getRequestURL) else {return}
        
        guard let key = UserDefaults.standard.object(forKey: TokenName.token) as? String else { return }
        
        var request = URLRequest(url: url)
        request.setValue(key, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        NetworkManager.shared.getData(with: request) { (data, error, response) in
            guard let data = data else { return }
            
            do {
                let response = try JSONDecoder().decode(AllTodo.self, from: data)
                
                guard let posters = response.data else {return}
                
                completionHandler(DataResponse.success(posters))
                
            } catch {
                print("AllTodoList Parsing Error")
            }
        }
    }
    
}
