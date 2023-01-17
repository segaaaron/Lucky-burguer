//
//  Network.swift
//  Lucky-Test-burguer
//
//  Created by Miguel Angel Saravia Belmonte on 1/15/23.
//

import Foundation
import UIKit

protocol NetworkProtocol {
    func apiService<T: Decodable>(with
                                         method: HTTPMethod,
                                         model: T.Type,
                                         endPoint: EndPoints,
                                         params: [String: String]?,
                                         completion: @escaping (Result<T, Error>?) -> Void)
}

let cacheDownload = NSCache<NSString, UIImage>()

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
    
    static func downloadImageCache(_ urlString: String, nameKey: String, completion: @escaping(_ image: UIImage) -> Void) {
        
        if let cacheImg = cacheDownload.object(forKey: nameKey as NSString) {
            completion(cacheImg)
            return
        }
        
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                
                guard
                    let httpURLResponse = response as? HTTPURLResponse,
                        httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType,
                        mimeType.hasPrefix("image"),
                    let data = data,
                        error == nil,
                    let recieveImg: UIImage = UIImage(data: data)
                else { return }
                let image = recieveImg.resizeCompressImage(image: recieveImg, withSize: CGSize(width: 300, height: 300))
                DispatchQueue.main.async {
                    cacheDownload.setObject(image, forKey: nameKey as NSString)
                    completion(image)
                }
            }.resume()
        }
    }
}

final class ServicePath: NSObject {
    static func pathMainUrl(_ key: String) -> String? {
        let bundle = Bundle.main
        guard let path = bundle.path(forResource: "ServiceUrl", ofType: "plist"),
              let url = NSDictionary(contentsOfFile: path) else { return nil }
        return url[key] as? String
    }
}
