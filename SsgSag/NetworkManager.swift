import UIKit

class NetworkManager {
    
    private let session: URLSession
    
    static let shared: NetworkManager = NetworkManager()
    
    private init(_ configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    private convenience init() {
        self.init(.default)
    }
    
    func getData(with: URLRequest, completion: @escaping (Data?, Error?, URLResponse?) -> Void) {
        let task = URLSession.shared.dataTask(with: with) { (data, res, error) in
            
            if error != nil {
                print(error?.localizedDescription)
                print("network error")
            }
            
            guard let data = data else {
                return
            }
            
            completion(data, nil, res)
        }
        task.resume()
    }
}

