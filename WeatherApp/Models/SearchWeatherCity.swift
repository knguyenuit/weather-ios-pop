//
//  SearchWeatherCity.swift
//  WeatherApp
//
//  Created by Nguyen Tran on 17/05/2022.
//

import Foundation

struct SearchAPIResponse: Codable {
    let searchApi: SearchAPIResult
    
    enum CodingKeys: String, CodingKey {
        case searchApi = "search_api"
    }
    
    init() {
        searchApi = SearchAPIResult(result: [])
    }
}

struct SearchAPIResult: Codable {
    let result: [SearchWeatherCityModel]
}

struct SearchWeatherCityModel: Codable {
    let areaName: [SearchWeatherCityModelValue]
    let country: [SearchWeatherCityModelValue]
    let region: [SearchWeatherCityModelValue]
    let latitude: String
    let longitude: String
    let population: String
    let weatherUrl: [SearchWeatherCityModelValue]
    
    func getAreaName() -> String {
        guard !areaName.isEmpty else { return "" }
        return areaName[0].value
    }
}

struct SearchWeatherCityModelValue: Codable {
    let value: String
}
