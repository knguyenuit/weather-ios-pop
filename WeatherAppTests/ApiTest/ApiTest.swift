//
//  ApiTest.swift
//  WeatherAppTests
//
//  Created by Nguyen Tran on 20/05/2022.
//

@testable import WeatherApp
import XCTest

class ApiTest: XCTestCase {
    private var api: APIMock!
    
    override func setUp() {
        super.setUp()
        api = APIMock()
    }
    
    override func tearDown() {
        api = nil
        super.tearDown()
    }
    
    func testAPI_OnInitialize_ShouldNotNil() {
        XCTAssertNotNil(api)
    }
    
    func testGetLocalWeather_OnSuccess() {
        api.apiResult = .success
        api.getLocalWeather(with: "DaN") { response in
            XCTAssertNotNil(response)
            XCTAssertNotNil(response.data.request.first?.query)
            XCTAssertNotNil(response.data.currentCondition.first?.weatherDesc)
            XCTAssertNotNil(response.data.currentCondition.first?.weatherIconURL)
            XCTAssertNotNil(response.data.currentCondition.first?.humidity)
            XCTAssertNotNil(response.data.currentCondition.first?.tempC)
        } onError: { error in
            XCTAssertNil(error)
        }
    }
    
    func testGetLocalWeather_OnFail() {
        api.apiResult = .failure(NWError.noData)
        api.getLocalWeather(with: "DaN") { response in
            XCTAssertNil(response)
        } onError: { error in
            XCTAssertNotNil(error)
        }
    }
    
    func testSearchWeather_OnSuccess() {
        api.apiResult = .success
        api.searchWeather(with: "HaN") { response in
            XCTAssertNotNil(response)
            XCTAssertNotNil(response.searchApi.result.first)
        } onError: { error in
            XCTAssertNil(error)
        }
    }
    
    func testSearchWeather_OnFail() {
        api.apiResult = .failure(NWError.noData)
        api.searchWeather(with: "HaN") { response in
            XCTAssertNil(response)
        } onError: { error in
            XCTAssertNotNil(error)
        }
    }
}
