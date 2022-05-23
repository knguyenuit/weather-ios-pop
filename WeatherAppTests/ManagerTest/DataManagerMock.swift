//
//  DataManagerMock.swift
//  WeatherAppTests
//
//  Created by Nguyen Tran on 23/05/2022.
//

@testable import WeatherApp
import Foundation

class DataManagerMock: DataKeepable {
    func saveWeatherLocations(_ locations: [SearchWeatherCityModel]) {
        if let encoded = try? JSONEncoder().encode(locations) {
            UserDefaults.weatherLocationDataMock = encoded
        }
    }
    
    func getWeatherLocations() -> [SearchWeatherCityModel] {
        guard let weatherLocationData = UserDefaults.weatherLocationDataMock,
              let weatherLocations = try? JSONDecoder().decode([SearchWeatherCityModel].self, from: weatherLocationData) else { return [] }
        return weatherLocations.count < 10 ? weatherLocations : Array(weatherLocations.prefix(10))
    }
    
    func clear() {
        UserDefaults.weatherLocationDataMock = nil
    }
}
