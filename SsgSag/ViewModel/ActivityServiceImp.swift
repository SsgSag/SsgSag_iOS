//
//  ActivityServiceImp.swift
//  SsgSag
//
//  Created by admin on 12/05/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class ActivityServiceImp: ActivityService {
    func requestDeleteActivity(contentIdx: Int, completionHandler: @escaping ((DataResponse<Activity>) -> Void)) {
        
        guard let url = UserAPI.sharedInstance.getURL(RequestURL.deleteAcitivity(careerIdx: contentIdx).getRequestURL()) else {return}
        
        guard let key = UserDefaults.standard.object(forKey: "SsgSagToken") as? String else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue(key, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        NetworkManager.shared.getData(with: request) { (data, error, response) in
            guard let data = data else {return}
            
            do {
                let dataByNetwork = try JSONDecoder().decode(Activity.self, from: data)
                
                completionHandler(DataResponse.success(dataByNetwork))
            } catch {
                print("AcitivityDelete Json Parsing")
            }
        }
        
        
    }
    
    
}
