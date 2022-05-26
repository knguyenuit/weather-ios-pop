//
//  Endpoint.swift
//  WeatherApp
//
//  Created by Nguyen Tran on 26/05/2022.
//

import Foundation

enum EndPoint {
    case searchWheather(city: String)
    case localWeather(city: String)
    
    var path: String {
        switch self {
        case .searchWheather(let city):
            return "v1/search.ashx?key=\(Keys.weatherAPIKey)&format=json&popular=yes&query=\(city)"
        case .localWeather(let city):
            return "v1/weather.ashx?key=\(Keys.weatherAPIKey)&format=json&q=\(city)"
        }
    }
}
