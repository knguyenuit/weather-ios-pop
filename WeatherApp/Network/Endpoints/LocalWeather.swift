//
//  LocalWeather.swift
//  WeatherApp
//
//  Created by Nguyen Tran on 19/05/2022.
//

import Foundation

struct LocalWeatherInput: RequestInput {
    var headers: [String : String]? = nil
    var params: [String: Any]? = nil
}

struct LocalWeatherWithCity: RequestType {
    var city: String
    var requestInput: RequestInput? = nil
    
    init(city: String) {
        self.city = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
    
    typealias ResponseType = WeatherResponse
    var data: RequestData {
        return RequestData(endpoint: .localWeather(city: city),
                           method: .get)
    }
}

