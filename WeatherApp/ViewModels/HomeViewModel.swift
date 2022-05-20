//
//  HomeViewModel.swift
//  WeatherApp
//
//  Created by Nguyen Tran on 18/05/2022.
//

import Foundation

protocol HomeViewModelType {
    // Input
    var onGetListSearchSuccess: (([SearchWeatherCityModel]) -> Void)? { get set }
    var onGetListSearchFail: ((String) -> Void)? { get set }
    
    // Output
    func searchWeather(with city: String)
}

class HomeViewModel: HomeViewModelType {
    var onGetListSearchSuccess: (([SearchWeatherCityModel]) -> Void)?
    var onGetListSearchFail: ((String) -> Void)?
    private let api: APIClient
    
    init(api: APIClient) {
        self.api = api
    }
    
    func checkDataLocal() {
        self.onGetListSearchSuccess?(DataManager.shared.getWeatherLocations())
    }
    
    func searchWeather(with city: String) {
        api.searchWeather(with: city) { [weak self] response in
            guard let self = self else { return }
            self.onGetListSearchSuccess?(response.searchApi.result)
        } onError: { [weak self] error in
            guard let self = self else { return }
            self.onGetListSearchFail?(error.message)
        }

    }
}
