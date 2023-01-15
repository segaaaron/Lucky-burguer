//
//  Network.swift
//  Lucky-Test-burguer
//
//  Created by Miguel Angel Saravia Belmonte on 1/15/23.
//

import Foundation

protocol NetworkProtocol {
    func apiService<T: Decodable>(with
                                         method: HTTPMethod,
                                         model: T.Type,
                                         endPoint: EndPoints,
                                         params: [String: String]?,
                                         completion: @escaping (Result<T, Error>?) -> Void)
}

final class Network: NetworkProtocol {
    func apiService<T>(with
                       method: HTTPMethod,
                       model: T.Type,
                       endPoint: EndPoints,
                       params: [String : String]?,
                       completion: @escaping (Result<T, Error>?) -> Void) where T : Decodable {
        
        let session = URLSession.shared
        
        let request = Request()
        request.url = Network.serviceUrl
        request.method = method
        request.params = params
        request.endPointPath = endPoint.endpoint
        request.timeout = 30
        
        guard let respRequest = RequestService.getRequest(with: request) else { return }
        session.dataTask(with: respRequest) { data, _ , error in
            DispatchQueue.global(qos: .background).async {
                if error != nil {
                    ServiceError.handleError(error as NSError?) { err in
                        guard let error = err else {return}
                        completion(.failure(error))
                    }
                }
                
                if let data = data {
                    do {
                        let resp = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(resp))
                    } catch let error as NSError {
                        ServiceError.handleError(error) { err in
                            guard let error = err else {return}
                            completion(.failure(error))
                        }
                    }
                }
            }
        }.resume()
    }
    
    static var serviceUrl: String {
        guard let url: String = ServicePath.pathMainUrl("url") else { return "" }
        return url
    }
}

final class ServicePath: NSObject {
    class func pathMainUrl(_ key: String) -> String? {
        let bundle = Bundle.main
        guard let path = bundle.path(forResource: "ServiceUrl", ofType: "plist"),
              let url = NSDictionary(contentsOfFile: path) else { return nil }
        return url[key] as? String
    }
}
