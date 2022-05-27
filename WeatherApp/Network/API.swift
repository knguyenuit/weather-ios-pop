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
