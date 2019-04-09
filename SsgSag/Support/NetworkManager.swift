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
    
    func getData(with: URLRequest, completionHandler: @escaping (Data?, Error?, URLResponse?) -> Void) {
        DispatchQueue.global().async {
            let task = URLSession.shared.dataTask(with: with) { (data, response, error) in
                
                if error != nil {
                    
                    //print("network error")
                }
                
                guard let data = data else {
                    return
                }
                
                DispatchQueue.main.async {
                    completionHandler(data, nil, response)
                }
            }
            task.resume()
        }
    }
}

/*
enum NetworkingErrors: Error {
    case parsingJSON
    case noInternetConnection
    case dataReturnedNil
    case returnedError(Error)
    case invalidStatusCode(Int)
    case customError(String)
}


public enum HTTPStatusCode: Int {
    
    // 100
    case `continue` = 100
    
    // 200
    case ok = 200
    
    // 400
    case badRequest = 400
    case unauthorized
    case forbidden = 403
    case notFound
    
    // 500
    case internalServerError = 500
    case notImplemented
    case badGateway
    
    case `nil` = 9999
}


public extension HTTPURLResponse {
    var httpStatusCode: HTTPStatusCode {
        get {
            guard let code = HTTPStatusCode(rawValue: statusCode) else {
                return HTTPStatusCode.nil
            }

            return code
        }
    }
}
*/
