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
    private let dataLocalManager: DataKeepable
    
    init(api: APIClient, dataLocalManager: DataKeepable) {
        self.api = api
        self.dataLocalManager = dataLocalManager
    }
    
    func checkDataLocal() {
        self.onGetListSearchSuccess?(dataLocalManager.getWeatherLocations())
    }
    
    func getWeatherLocations() -> [SearchWeatherCityModel] {
        return dataLocalManager.getWeatherLocations()
    }
    
    func saveWeatherLocations(_ location: SearchWeatherCityModel) {
        var localWeather = dataLocalManager.getWeatherLocations()
        if localWeather.isEmpty {
            localWeather.append(location)
        } else {
            if !localWeather.contains(where: { $0.getAreaName() == location.getAreaName() }) {
                if localWeather.count >= 10 {
                    localWeather.remove(at: 9)
                }
                localWeather.insert(location, at: 0)
            }
        }
        dataLocalManager.saveWeatherLocations(localWeather)
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
