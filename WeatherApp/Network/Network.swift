//
//  Network.swift
//  S-Call
//
//  Created by dev on 07/03/2022.
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

enum EndPoint {
    case searchWheather(city: String)
    case localWeather(city: String)
    
    var path: String {
        switch self {
        case .searchWheather(let city):
            return "v1/search.ashx?key=\(Keys.weatherAPIKey)&format=json&popular=yes&query=\(city)"
        case .localWeather(let city):
            return "v1/weather.ashx?key=\(Keys.weatherAPIKey)&format=json&q=\(city)"
        }
    }
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

protocol RequestType {
    associatedtype ResponseType: Codable
    var data: RequestData { get }
    var requestInput: RequestInput? { get }
}

extension RequestType {
    func execute (
        dispatcher: NetworkDispatcher = URLSessionNetworkDispatcher.instance,
        onSuccess: @escaping (ResponseType) -> Void,
        onError: @escaping (Error) -> Void
    ) {
        dispatcher.dispatch(
            request: self.data,
            onSuccess: { (responseData: Data) in
                print(responseData.jsonString)
                do {
                    let jsonDecoder = JSONDecoder()
                    let result = try jsonDecoder.decode(ResponseType.self, from: responseData)
                    DispatchQueue.main.async {
                        onSuccess(result)
                    }
                } catch let error {
                    let er = parseError(data: responseData) ?? error
                    DispatchQueue.main.async {
                        onError(er)
                    }
                }
            },
            onError: { (error: Error) in
                DispatchQueue.main.async {
                    onError(error)
                }
            }
        )
    }
    
    private func parseError(data: Data) -> Error? {
        do {
            let apiError = try JSONDecoder().decode(APIError.self, from: data)
            return NWError.apiError(apiError)
        } catch {
            return nil
        }
    }
}

protocol NetworkDispatcher {
    func dispatch(request: RequestData, onSuccess: @escaping (Data) -> Void, onError: @escaping (Error) -> Void)
}

struct URLSessionNetworkDispatcher: NetworkDispatcher {
    static let instance = URLSessionNetworkDispatcher()
    private init() {}
    
    func dispatch(request: RequestData, onSuccess: @escaping (Data) -> Void, onError: @escaping (Error) -> Void) {
        let urlString = baseURL + request.endpoint.path
        guard let url = URL(string: urlString) else {
            onError(NWError.invalidURL)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        
        do {
            if let params = request.requestInput?.params {
                print(params.jsonString)
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
            }
        } catch let error {
            onError(error)
            return
        }
        
        urlRequest.setDefaultHeaders(request: request)
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                onError(error)
                print(error)
                return
            }
            
            guard let _data = data else {
                onError(NWError.noData)
                return
            }
            
            onSuccess(_data)
        }.resume()
    }
}

private extension URLRequest {
    mutating func setDefaultHeaders(request: RequestData) {
        if let headers = request.requestInput?.headers {
            allHTTPHeaderFields = headers
        }
        
        var addDefaultHeaders = (allHTTPHeaderFields ?? [:])
        addDefaultHeaders["Content-Type"] = "application/json"
        
        switch request.apiType {
        case .private:
            addDefaultHeaders["Authorization"] = ""
        case .public:
            break
        }
        allHTTPHeaderFields = addDefaultHeaders
    }
}
