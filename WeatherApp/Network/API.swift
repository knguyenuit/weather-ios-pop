//
//  API.swift
//  WeatherApp
//
//  Created by Nguyen Tran on 17/05/2022.
//

import Foundation

protocol APIClient {
    func searchWeather(with city: String,
                        onSuccess: @escaping (SearchAPIResponse) -> Void,
                        onError: @escaping (Error) -> Void)
    
    func getLocalWeather(with city: String,
                        onSuccess: @escaping (WeatherResponse) -> Void,
                        onError: @escaping (Error) -> Void)
}

class API: APIClient {
    func getLocalWeather(with city: String, onSuccess: @escaping (WeatherResponse) -> Void, onError: @escaping (Error) -> Void) {
        
        LocalWeatherWithCity(city: city)
            .execute(
                onSuccess: { response in
                    onSuccess(response)
                },
                onError: { err in
                    onError(err)
                })
    }
    
    func searchWeather(with city: String,
                        onSuccess: @escaping (SearchAPIResponse) -> Void,
                        onError: @escaping (Error) -> Void) {
        SearchWeatherWithCity(city: city)
            .execute(
                onSuccess: { response in
                    onSuccess(response)
                },
                onError: { err in
                    onError(err)
                })
    }
}
