import UIKit

class NetworkManager {
    
    private let session: URLSession
    
    static let shared: NetworkManager = NetworkManager()
    
    private init(_ configuration: URLSessionConfiguration) {
        configuration.urlCache = nil
        //여기서 customize한 세션을 설정할 수 있다.
        self.session = URLSession(configuration: configuration)
    }
    
    private convenience init() {
        self.init(.default)
    }
    
    func getData(with: URLRequest, completionHandler: @escaping (Data?, Error?, URLResponse?) -> Void) {
        
        session.dataTask(with: with) { (data, response, error) in
            
            if error != nil {
                
                //print("network error")
            }
            
            guard let data = data else {
                return
            }
            
            DispatchQueue.main.async {
                completionHandler(data, nil, response)
            }
            
        }.resume()
        
    }
    
}
