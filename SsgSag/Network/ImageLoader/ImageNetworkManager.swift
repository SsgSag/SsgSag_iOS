//
//  ImageNetworkManager.swift
//  Common
//
//  Created by admin on 13/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//
import UIKit
import RxSwift
import RxCocoa

class ImageLoader {
    
    var disposeBag = DisposeBag()
    private let network: RxNetwork = RxNetworkImp(session: URLSession.shared)
    private let imageCache = NSCache<NSString, UIImage>()
    func load(with urlString: String) -> Observable<UIImage?> {
        return Observable<UIImage?>.create { [weak self] (observer) in
            guard let self = self,
                let url = URL(string: urlString) else {
                observer.onError(RxCocoaURLError.unknown)
                return Disposables.create()
            }
            
            if let cachedImage = self.imageCache.object(forKey: urlString as NSString) {
                observer.onNext(cachedImage)
                observer.onCompleted()
                return Disposables.create()
            }
            
            let dataObservable = self.network.dispatch(request: URLRequest(url: url))
            dataObservable
                .subscribe(onNext: { (data) in
                    if let image = UIImage(data: data) {
                        
                        self.imageCache.setObject(image.scale(with: 0.4),
                                             forKey: urlString as NSString)
                        observer.onNext(image)
                    } else {
                        observer.onNext(nil)
                    }
                    observer.onCompleted()
                
                }, onError: { (error) in
                    observer.onError(error)
                })
                .disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
}

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
        guard let image = cache.object(forKey: imageURL as NSString) else {
            downloadImage(imageURL: imageURL, completionHandler: completionHandler)
            return
        }
        
        DispatchQueue.main.async {
            completionHandler(image, nil)
        }
    }
    
}

extension UIImage {
    func scale(with scale: CGFloat) -> UIImage {
        let size = CGSize(width: self.size.width * scale, height: self.size.height * scale)
        let format = UIGraphicsImageRendererFormat.default()
        format.opaque = true
        format.scale = self.scale
        
        let render = UIGraphicsImageRenderer(size:size, format: format)
        let image = render.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        
        return image
    }
}
