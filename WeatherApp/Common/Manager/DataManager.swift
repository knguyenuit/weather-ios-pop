//
//  DataManager.swift
//  WeatherApp
//
//  Created by Nguyen Tran on 19/05/2022.
//

import Foundation

protocol DataKeepable {
    func saveWeatherLocations(_ locations: [SearchWeatherCityModel])
    func getWeatherLocations() -> [SearchWeatherCityModel]
    func clear()
}

class DataManager: DataKeepable {
    
    func saveWeatherLocations(_ locations: [SearchWeatherCityModel]) {
        if let encoded = try? JSONEncoder().encode(locations) {
            UserDefaults.weatherLocationData = encoded
        }
    }
    
    func getWeatherLocations() -> [SearchWeatherCityModel] {
        guard let weatherLocationData = UserDefaults.weatherLocationData,
              let weatherLocations = try? JSONDecoder().decode([SearchWeatherCityModel].self, from: weatherLocationData) else { return [] }
        return weatherLocations
    }
    
    func clear() {
        UserDefaults.weatherLocationData = nil
    }
}
