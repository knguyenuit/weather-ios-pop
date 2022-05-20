//
//  LocalWeatherCity.swift
//  WeatherApp
//
//  Created by Nguyen Tran on 19/05/2022.
//

import Foundation

// MARK: - WeatherResponse
struct WeatherResponse: Codable {
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let request: [Request]
    let currentCondition: [CurrentCondition]

    enum CodingKeys: String, CodingKey {
        case request
        case currentCondition = "current_condition"
    }
}

// MARK: - CurrentCondition
struct CurrentCondition: Codable {
    let tempC: String
    let weatherIconURL, weatherDesc: [Weather]
    let humidity: String

    enum CodingKeys: String, CodingKey {
        case tempC = "temp_C"
        case weatherIconURL = "weatherIconUrl"
        case weatherDesc, humidity
    }
}

// MARK: - Weather
struct Weather: Codable {
    let value: String
}

// MARK: - Request
struct Request: Codable {
    let type, query: String
}
