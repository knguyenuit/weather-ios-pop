//
//  LocalWeatherViewModelTests.swift
//  WeatherAppTests
//
//  Created by Nguyen Tran on 19/05/2022.
//

@testable import WeatherApp
import XCTest

class LocalWeatherViewModelTests: XCTestCase {
    private var viewModel: LocalWeatherViewModelMock!
    private var api: APIMock!
    
    override func setUp() {
        super.setUp()
        api = APIMock()
        viewModel = LocalWeatherViewModelMock(api: api, city: "danang")
    }
    
    override func tearDown() {
        api = nil
        viewModel = nil
        super.tearDown()
    }
    
    func testAPI_OnInitialize_ShouldNotNil() {
        XCTAssertNotNil(api)
    }
    
    func testLocalWeatherViewModel_OnInitialize_ShouldNotNil() {
        XCTAssertNotNil(viewModel)
    }
    
    func testGetLocalWeather_OnSuccess() {
        api.apiResult = .success
        viewModel.getLocalWeather()
        XCTAssertTrue(viewModel.getLocalWeatherSuccess)
        XCTAssertNotNil(viewModel.weatherResponse)
    }
    
    func testGetLocalWeather_OnError() {
        api.apiResult = .failure(NWError.noData)
        viewModel.getLocalWeather()
        XCTAssertFalse(viewModel.getLocalWeatherSuccess)
        XCTAssertNil(viewModel.weatherResponse)
    }
}
