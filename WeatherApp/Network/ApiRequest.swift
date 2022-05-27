//
//  ApiRequest.swift
//  WeatherApp
//
//  Created by cristian on 27/05/2022.
//

import Foundation

public protocol DHURLSession {
    func dataTaskWithRequest(request: URLRequest,
                             completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: DHURLSession {
    public func dataTaskWithRequest(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            completionHandler(data, response, error)
        }
        task.resume()
        return task
    }
}
