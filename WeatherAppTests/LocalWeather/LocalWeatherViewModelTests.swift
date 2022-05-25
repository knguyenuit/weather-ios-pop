//
//  LocalWeatherViewModelTests.swift
//  WeatherAppTests
//
//  Created by Nguyen Tran on 19/05/2022.
//

@testable import WeatherApp
import XCTest

class LocalWeatherViewModelTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGetLocalWeather_OnSuccess() {
        let api = APIMock()
        api.apiResult = .success
        let viewModel =  LocalWeatherViewModel(api: api, city: "danang")
        viewModel.onGetLocalWeatherSuccess = { model in
            XCTAssertNotNil(model)
        }
        viewModel.getLocalWeather()
    }
    
    func testGetLocalWeather_OnError() {
        let api = APIMock()
        api.apiResult = .failure(NWError.noData)
        let viewModel =  LocalWeatherViewModel(api: api, city: "danang")
        viewModel.onGetLocalWeatherFail = { errorMessage in
            XCTAssertNotNil(errorMessage)
        }
        viewModel.getLocalWeather()
    }
}
