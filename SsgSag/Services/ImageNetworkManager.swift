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
    
    private func downloadImage(imageURL: URL, completionHandler: @escaping (UIImage?, Error?) -> Void) {
        
        session.dataTask(with: imageURL) { [weak self] (data, _, error) in
            
            if error != nil {
                return
            }
            
            guard let data = data else {
                return
            }
            
            guard let image: UIImage = UIImage(data: data) else {
                return
            }
            
            self?.cache.setObject(image, forKey: imageURL.absoluteString as NSString)
            
            DispatchQueue.main.async {
                completionHandler(image, nil)
            }
        }.resume()
    }
    
    public func getImageByCache(imageURL: URL, completionHandler: @escaping (UIImage?, Error?) -> Void) {
        if let image = cache.object(forKey: imageURL.absoluteString as NSString) {
            DispatchQueue.main.async {
                completionHandler(image, nil)
            }
        } else {
            downloadImage(imageURL: imageURL, completionHandler: completionHandler)
        }
    }
    
}
