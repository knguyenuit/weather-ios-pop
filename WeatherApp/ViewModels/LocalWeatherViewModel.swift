//
//  LocalWeatherViewModel.swift
//  WeatherApp
//
//  Created by Nguyen Tran on 19/05/2022.
//

import Foundation

import Foundation

protocol LocalWeatherViewModelType {
    // Output
    var onGetLocalWeatherSuccess: ((WeatherResponse) -> Void)? { get set }
    var onGetLocalWeatherFail: ((String) -> Void)? { get set }
    
    // Input
    func getLocalWeather()
}

class LocalWeatherViewModel: LocalWeatherViewModelType {

    private var currentCity: String
    var onGetLocalWeatherSuccess: ((WeatherResponse) -> Void)?
    var onGetLocalWeatherFail: ((String) -> Void)?
    private let api: APIClient
    
    init(api: APIClient, city: String) {
        self.api = api
        currentCity = city
    }
    
    
    func getLocalWeather() {
        api.getLocalWeather(with: currentCity) { [weak self] response in
            guard let self = self else { return }
            self.onGetLocalWeatherSuccess?(response)
        } onError: { [weak self] error in
            guard let self = self else { return }
            self.onGetLocalWeatherFail?("getLocalWeatherError")
        }

    }
}
