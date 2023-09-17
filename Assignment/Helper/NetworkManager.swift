//
//  NetworkManager.swift


import UIKit
import Combine
import Alamofire
import Reachability


class NetworkManager {
    
    // live url https://api.selrweb.com/
    // api.selr.intellexio.com
    
   // static let baseURL = "https://picsum.photos"
    static let baseURL = "https://pixabay.com/api/?key=39465172-9b6a53f53f357bd30ef5861e6"
    
    enum Endpoint: String {
        case list = "list"
    }
    
    static func request<R: Codable>(
     //   endPoint: Endpoint,
      //  urlFragment: String? = nil,
        method: HTTPMethod,
        payload: [String: String]? = nil,
        responseEncoder: R.Type
    ) -> AnyPublisher<R, Error> {
        
        if !NetworkReachability.shared.isInternetReachable {
            return Fail(error: NetworkManagerError.apiErrorWithCustomMessage(code: 2, message: "No internet")).eraseToAnyPublisher()
        }
        
        let url = URL(string: baseURL)!
        
        debugPrint(url)
        var headers = [
            "Accept": "application/json"
        ]
        
        headers.updateValue("39465172-9b6a53f53f357bd30ef5861e6", forKey: "key")
    
        return AF.request(url, method: method, parameters: payload, encoder: .urlEncodedForm, headers: HTTPHeaders(headers))
            .publishData()
            .value()
            .mapError({
                $0.underlyingError ?? NetworkManagerError.apiErrorWithCustomMessage(code: -1, message: "Something went wrong!")
            })
            .tryMap({ baseResponse in
                let c = try JSONSerialization.jsonObject(with: baseResponse, options: .mutableContainers)
                print(c)
                let d = try JSONDecoder().decode(RootResponseModel<R>.self, from: baseResponse)
        //        print(d)
                return d.hits
            })
            .eraseToAnyPublisher()
    }
        
}

struct RootResponseModel<R: Codable>: Codable {
    let total: Int
    let totalHits: Int
    let hits: R
}


enum NetworkManagerError: Error {
    case apiErrorWithCustomMessage(code: Int, message: String?)
}


extension NetworkManagerError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .apiErrorWithCustomMessage(_, let message):
            return NSLocalizedString(message ?? "NetworkManagerError error!", comment: "NetworkManagerError custom error.")
        }
    }
}
