//
//  ApiTest.swift
//  WeatherAppTests
//
//  Created by Nguyen Tran on 20/05/2022.
//

@testable import WeatherApp
import XCTest

class ApiTest: XCTestCase {
    private var api: API!
    
    override func setUp() {
        super.setUp()
        api = API()
    }
    
    override func tearDown() {
        api = nil
        super.tearDown()
    }
    
    func testAPI_OnInitialize_ShouldNotNil() {
        XCTAssertNotNil(api)
    }
    
    func testGetLocalWeather_OnSuccess() {
        let dataMock = WeatherResponse.mock(from: "local_weather_mock_response")!
        api.getLocalWeather(with: "Danang") { response in
            XCTAssertNotNil(response)
            XCTAssertEqual(response.data.request.first?.query, dataMock.data.request.first?.query)
        } onError: { error in
            XCTAssertNil(error)
        }
    }
    
    func testGetLocalWeather_OnSuccessClosureNotNull() {
        let onSuccess: (WeatherResponse) -> Void = { response in
            XCTAssertNotNil(response)
        }
        let onError: (Error) -> Void = { error in
            XCTAssertNil(error)
        }
        api.getLocalWeather(with: "DaNang", onSuccess: onSuccess, onError: onError)
        XCTAssertNotNil(onSuccess)
        XCTAssertNotNil(onError)
        
    }
    
    func testGetLocalWeather_OnFail() {
        api.getLocalWeather(with: "Danangafdsafasd") { response in
            XCTAssertNil(response)
        } onError: { error in
            XCTAssertNotNil(error)
        }
    }
    
    func testGetLocalWeather_OnFailClosureNotNull() {
        let onSuccess: (WeatherResponse) -> Void = { response in
            XCTAssertNil(response)
        }
        let onError: (Error) -> Void = { error in
            XCTAssertNotNil(error)
        }
        api.getLocalWeather(with: "Danangsadfsd", onSuccess: onSuccess, onError: onError)
        XCTAssertNotNil(onError)
        XCTAssertNotNil(onSuccess)
    }
    
    func testSearchWeather_OnSuccess() {
        let dataMock = SearchAPIResponse.mock(from: "search_weather_mock_response")!
        api.searchWeather(with: "Sin") { response in
            XCTAssertNotNil(response)
            XCTAssertEqual(response.searchApi.result.first?.getAreaName(), dataMock.searchApi.result.first?.getAreaName())
            XCTAssertEqual(response.searchApi.result.count, dataMock.searchApi.result.count)
        } onError: { error in
            XCTAssertNil(error)
        }
    }
    
    func testSearchWeather_OnSuccessClosureNotNull() {
        let onSuccess: (SearchAPIResponse) -> Void = { response in
            XCTAssertNotNil(response)
        }
        let onError: (Error) -> Void = { error in
            XCTAssertNil(error)
        }
        api.searchWeather(with: "Sin", onSuccess: onSuccess, onError: onError)
        XCTAssertNotNil(onError)
        XCTAssertNotNil(onSuccess)
    }
    
    func testSearchWeather_OnFail() {
        api.searchWeather(with: "Sinsafsdafsd") { response in
            XCTAssertNil(response)
        } onError: { error in
            XCTAssertNotNil(error)
        }
    }
    
    func testSearchWeather_OnFailClosureNotNull() {
        let onSuccess: (SearchAPIResponse) -> Void = { response in
            XCTAssertNil(response)
        }
        let onError: (Error) -> Void = { error in
            XCTAssertNotNil(error)
        }
        api.searchWeather(with: "Sinsafsdafsd", onSuccess: onSuccess, onError: onError)
        XCTAssertNotNil(onError)
        XCTAssertNotNil(onSuccess)
    }
}
