//
//  EndPoints.swift
//  Lucky-Test-burguer
//
//  Created by Miguel Angel Saravia Belmonte on 1/15/23.
//

import Foundation

enum HTTPMethod: String {
    case GET = "get"
    case POST = "post"
}

enum EndPoints {
    case test
    
    var endpoint: String {
        switch self {
        case .test:
            return "/test"
        }
    }
}
