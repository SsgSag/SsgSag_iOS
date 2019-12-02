//
//  ImageNetworkManager.swift
//  Common
//
//  Created by admin on 13/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//
import UIKit

public class ImageNetworkManager {
    
    let session: URLSession
    
    public static let shared = ImageNetworkManager()
    
    private let cache: NSCache = NSCache<NSString, UIImage>()
    
    private init(_ configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    private convenience init() {
        self.init(.default)
    }
    
    // FIXME: - like 할시에만 cache에 넣는 정책을 사용하자.
    private func downloadImage(imageURL: String, completionHandler: @escaping (UIImage?, Error?) -> Void) {
        
        guard let url = URL(string: imageURL) else {
            return
        }
        
        session.dataTask(with: url) { [weak self] (data, _, error) in
            
            if error != nil {
                return
            }
            
            guard let data = data else {
                return
            }
            
            guard let image: UIImage = UIImage(data: data) else {
                return
            }
            
            self?.cache.setObject(image, forKey: imageURL as NSString)

            DispatchQueue.main.async {
                completionHandler(image, nil)
            }
        }.resume()
    }
    
    public func getImageByCache(imageURL: String, completionHandler: @escaping (UIImage?, Error?) -> Void) {
        if imageURL == "" {
            DispatchQueue.main.async {
                completionHandler(UIImage(named: "ic_developer"), nil)
                return
            }
        }
        
        guard let image = cache.object(forKey: imageURL as NSString) else {
            downloadImage(imageURL: imageURL, completionHandler: completionHandler)
            return
        }
        
        DispatchQueue.main.async {
            completionHandler(image, nil)
        }
    }
    
}
