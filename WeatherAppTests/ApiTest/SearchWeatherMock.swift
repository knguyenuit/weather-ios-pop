//
//  SearchWeatherMock.swift
//  WeatherAppTests
//
//  Created by Nguyen Tran on 26/05/2022.
//


@testable import WeatherApp

struct SearchWeatherMock: RequestType {
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
    
    func execute (
        dispatcher: NetworkDispatcher = URLSessionNetworkDispatcher(),
        onSuccess: @escaping (ResponseType) -> Void,
        onError: @escaping (Error) -> Void
    ) {
        dispatcher.dispatch(request: data) { data in
            onSuccess(SearchAPIResponse.mock(from: "search_weather_mock_response")!)
        } onError: { error in
            onError(error)
        }

    }
}

