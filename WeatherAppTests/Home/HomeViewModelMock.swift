//
//  LocalWeatherViewModelMock.swift
//  WeatherAppTests
//
//  Created by Nguyen Tran on 19/05/2022.
//

@testable import WeatherApp

class HomeViewModelMock: HomeViewModelType {
    var onGetListSearchSuccess: (([SearchWeatherCityModel]) -> Void)?
    var onGetListSearchFail: ((String) -> Void)?
    
    public var searchWeatherSuccess: Bool = false
    public var listWeather: [SearchWeatherCityModel]?
    private let api: APIClient
    
    init(api: APIClient) {
        self.api = api
    }
    
    func searchWeather(with city: String) {
        api.searchWeather(with: city) { [weak self] response in
            self?.searchCitySuccess = true
            self?.listWeather = response.searchApi.result
            self?.onGetListSearchSuccess?(response.searchApi.result)
        } onError: { [weak self] error in
            self?.searchCitySuccess = false
            self?.listWeather = nil
            self?.onGetListSearchFail?(error.message)
        }

    }
    
}
