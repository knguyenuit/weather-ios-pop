//
//  LocalWeatherCityMock.swift
//  WeatherApp
//
//  Created by Nguyen Tran on 26/05/2022.
//

@testable import WeatherApp

struct LocalWeatherCityMock: RequestType {
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
    
    func execute (
        dispatcher: NetworkDispatcher = URLSessionNetworkDispatcher(),
        onSuccess: @escaping (ResponseType) -> Void,
        onError: @escaping (Error) -> Void
    ) {
        let mockResponse = WeatherResponse.mock(from: "local_weather_mock_response")!
        dispatcher.dispatch(request: data) { data in
            onSuccess(mockResponse)
        } onError: { error in
            onError(error)
        }

    }
}
