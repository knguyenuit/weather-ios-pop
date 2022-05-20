//
//  LocalWeatherViewModelMock.swift
//  WeatherAppTests
//
//  Created by Nguyen Tran on 19/05/2022.
//

@testable import WeatherApp

class LocalWeatherViewModelMock: LocalWeatherViewModelType {
    public var onGetLocalWeatherSuccess: ((WeatherResponse) -> Void)?
    public var onGetLocalWeatherFail: ((String) -> Void)?
    public var getLocalWeatherSuccess: Bool = false
    public var weatherResponse: WeatherResponse?
    
    private let api: APIClient
    private var currentCity: String

    init(api: APIClient, city: String) {
        self.api = api
        currentCity = city
    }
    
    func getLocalWeather() {
        api.getLocalWeather(with: currentCity,
                            onSuccess: { [weak self] response in
            self?.getLocalWeatherSuccess = true
            self?.weatherResponse = response
            self?.onGetLocalWeatherSuccess?(response)
        },
                            onError: { [weak self] error in
            self?.getLocalWeatherSuccess = false
            self?.weatherResponse = nil
            self?.onGetLocalWeatherFail?(error.message)
        })
    }
    
    
}
