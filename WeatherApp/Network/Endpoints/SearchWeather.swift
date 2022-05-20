//
//  SearchWeather.swift
//  WeatherApp
//
//  Created by Nguyen Tran on 17/05/2022.
//

import Foundation

struct SearchWeatherInput: RequestInput {
    var headers: [String : String]? = nil
    var params: [String: Any]? = nil
}

struct SearchWeatherWithCity: RequestType {
    var city: String
    var requestInput: RequestInput? = nil
    
    init(city: String) {
        self.city = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
    
    typealias ResponseType = SearchAPIResponse
    var data: RequestData {
        return RequestData(endpoint: .searchWheather(city: city),
                           method: .get)
    }
}
