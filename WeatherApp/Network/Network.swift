import Foundation

typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void

protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol { }

protocol URLSessionProtocol {
    func dataTaskWithURL(_ urlRequest: URLRequest, completion: @escaping DataTaskResult)
    -> URLSessionDataTaskProtocol
}

extension URLSession: URLSessionProtocol {
    func dataTaskWithURL(_ urlRequest: URLRequest, completion: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        dataTask(with: urlRequest, completionHandler: completion) as URLSessionDataTaskProtocol
    }
}

protocol NetworkDispatcher {
    func dispatch(request: RequestData, onSuccess: @escaping (Data) -> Void, onError: @escaping (Error) -> Void)
}

struct URLSessionNetworkDispatcher: NetworkDispatcher {
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
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
        
        session.dataTaskWithURL(urlRequest) { (data, response, error) in
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
