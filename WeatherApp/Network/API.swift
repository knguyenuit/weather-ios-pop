//
//  API.swift
//  WeatherApp
//
//  Created by Nguyen Tran on 17/05/2022.
//

import Foundation

let baseURL = "https://api.worldweatheronline.com/premium/"

protocol APIClient {
    func searchWeather(with city: String,
                        onSuccess: @escaping (SearchAPIResponse) -> Void,
                        onError: @escaping (Error) -> Void)
    
    func getLocalWeather(with city: String,
                        onSuccess: @escaping (WeatherResponse) -> Void,
                        onError: @escaping (Error) -> Void)
}

class API: APIClient {
    
    var session: DWURLSession
    
    init(session: DWURLSession) {
        self.session = session
    }
    
    func getLocalWeather(with city: String, onSuccess: @escaping (WeatherResponse) -> Void, onError: @escaping (Error) -> Void) {
        var urlReqest = URLRequest(url: URL.init(string: baseURL + "v1/weather.ashx?key=\(Keys.weatherAPIKey)&format=json&q=\(city)")!)
        urlReqest.httpMethod = "GET"

        let _ = session.dataTaskWithRequest(request: urlReqest) { responseData, response, error in
            do {
                let jsonDecoder = JSONDecoder()
                if let responseData = responseData {
                    let result = try jsonDecoder.decode(WeatherResponse.self, from: responseData)
                    DispatchQueue.main.async {
                        onSuccess(result)
                    }
                }
            } catch let error {
                DispatchQueue.main.async {
                    onError(error)
                }
            }
        }
    }
    
    func searchWeather(with city: String,
                        onSuccess: @escaping (SearchAPIResponse) -> Void,
                        onError: @escaping (Error) -> Void) {
        var urlReqest = URLRequest(url: URL.init(string: baseURL + "v1/search.ashx?key=\(Keys.weatherAPIKey)&format=json&popular=yes&query=\(city)")!)
        urlReqest.httpMethod = "GET"

        let _ = session.dataTaskWithRequest(request: urlReqest) { responseData, response, error in
            do {
                let jsonDecoder = JSONDecoder()
                if let responseData = responseData {
                    let result = try jsonDecoder.decode(SearchAPIResponse.self, from: responseData)
                    DispatchQueue.main.async {
                        onSuccess(result)
                    }
                }
            } catch let error {
                DispatchQueue.main.async {
                    onError(error)
                }
            }
        }
    }
}



class URLSessionMock: DWURLSession {
  var url: URL?
  var request: URLRequest?
  private let dataTaskMock: URLSessionDataTaskMock

  public init(data: Data?, response: URLResponse?, error: Error?) {
      dataTaskMock = URLSessionDataTaskMock()
      dataTaskMock.taskResponse = (data, response, error)
  }

  public func dataTaskWithRequest(request: URLRequest,
    completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
      self.request = request
      self.dataTaskMock.completionHandler = completionHandler
      return self.dataTaskMock
  }

  final private class URLSessionDataTaskMock : URLSessionDataTask {

    typealias CompletionHandler = (Data, URLResponse, Error) -> Void
    var completionHandler: CompletionHandler?
    var taskResponse: (Data?, URLResponse?, Error?)?

    override func resume() {
        completionHandler?((taskResponse?.0)!, (taskResponse?.1)!, (taskResponse?.2)!)
    }
  }
}
