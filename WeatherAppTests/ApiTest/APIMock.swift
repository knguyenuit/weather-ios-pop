//
//  APIMock.swift
//  WeatherAppTests
//
//  Created by Nguyen Tran on 19/05/2022.
//

@testable import WeatherApp

enum APIResult {
    case success
    case failure(Error)
}

class APIMock: APIClient {
    var apiResult: APIResult = .success
    
    func searchWeather(with city: String,
                       onSuccess: @escaping (SearchAPIResponse) -> Void,
                       onError: @escaping (Error) -> Void) {
        switch apiResult {
        case .success:
            onSuccess(SearchAPIResponse.mock(from: "search_weather_mock_response")!)
        case .failure(let error):
            onError(error)
        }
    }

    func getLocalWeather(with city: String,
                         onSuccess: @escaping (WeatherResponse) -> Void,
                         onError: @escaping (Error) -> Void) {
        switch apiResult {
        case .success:
            let mockResponse = WeatherResponse.mock(from: "local_weather_mock_response")!
            onSuccess(mockResponse)
        case .failure(let error):
            onError(error)
        }
    }
}
