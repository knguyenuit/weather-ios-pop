//
//  NetworkDefine.swift
//  WeatherApp
//
//  Created by Nguyen Tran on 26/05/2022.
//

import Foundation

let baseURL = "https://api.worldweatheronline.com/premium/"

enum APIType {
    case `private`, `public`
}

protocol RequestInput {
    var params: [String: Any]? { get }
    var headers: [String: String]? { get }
}

struct APIError: Codable {
    let data: ErrorModel
}

struct ErrorModel: Codable {
    let error: [MessageError]
}

struct MessageError: Codable {
    let msg: String
}

enum NWError: Swift.Error {
    case invalidURL
    case noData
    case authFailed
    case apiError(APIError)
}

extension Error {
    var message: String {
        switch self as? NWError {
        case .invalidURL:
            return "Invalid request"
        case .authFailed:
            return "Unauthorized"
        case .apiError(let er):
            return er.data.error.isEmpty ? "No data" : er.data.error[0].msg
        case .noData:
            return "No data"
        default:
            return localizedDescription
        }
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

struct RequestData {
    let apiType: APIType
    let endpoint: EndPoint
    let method: HTTPMethod
    let requestInput: RequestInput?
    
    init (
        apiType: APIType = .private,
        endpoint: EndPoint,
        method: HTTPMethod = .get,
        requestInput: RequestInput? = nil) {
        self.apiType = apiType
        self.endpoint = endpoint
        self.method = method
        self.requestInput = requestInput
    }
}
