//
//  TapbarServiceImp.swift
//  SsgSag
//
//  Created by admin on 05/05/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

class TapbarServiceImp: TapbarService {
    func requestAllTodoList(completionHandler: @escaping (DataResponse<[Posters]>) -> Void) {
        
        guard let url = UserAPI.sharedInstance.getURL(RequestURL.allTodoList.getRequestURL()) else {return}
        
        guard let key = UserDefaults.standard.object(forKey: "SsgSagToken") as? String else { return }
        
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
