import UIKit

public enum DataResponse<Data> {
    
    case success(Data)
    case failed(Error)
    
    init(value: Data, error: Error?) {
        if let error = error {
            self = .failed(error)
        } else {
            self = .success(value)
        }
    }
    
    public var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failed:
            return false
        }
    }
    
    public var isFailure: Bool {
        return !isSuccess
    }
    
    public var value: Data? {
        switch self {
        case .success(let value):
            return value
        case .failed:
            return nil
        }
    }
    
    public var error: Error? {
        switch self {
        case .success:
            return nil
        case .failed(let error):
            return error
        }
    }
}
