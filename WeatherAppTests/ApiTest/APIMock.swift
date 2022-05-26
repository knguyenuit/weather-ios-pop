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
        SearchWeatherMock(city: city).execute(
            onSuccess: { response in
                onSuccess(response)
            },
            onError: { err in
                onError(err)
            }
        )
    }

    func getLocalWeather(with city: String,
                         onSuccess: @escaping (WeatherResponse) -> Void,
                         onError: @escaping (Error) -> Void) {
        LocalWeatherCityMock(city: city).execute(
            onSuccess: { response in
                onSuccess(response)
            },
            onError: { err in
                onError(err)
            }
        )
    }
}
