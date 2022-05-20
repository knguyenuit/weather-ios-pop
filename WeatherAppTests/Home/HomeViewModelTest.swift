//
//  HomeViewModelTest.swift
//  WeatherAppTests
//
//  Created by Nguyen Tran on 19/05/2022.
//

@testable import WeatherApp
import XCTest

class HomeViewModelTests: XCTestCase {
    private var viewModel: HomeViewModelMock!
    private var api: APIMock!
    
    override func setUp() {
        super.setUp()
        api = APIMock()
        viewModel = HomeViewModelMock(api: api)
    }
    
    override func tearDown() {
        api = nil
        viewModel = nil
        super.tearDown()
    }
    
    func testAPI_OnInitialize_ShouldNotNil() {
        XCTAssertNotNil(api)
    }
    
    func testHomeViewModel_OnInitialize_ShouldNotNil() {
        XCTAssertNotNil(viewModel)
    }
    
    func testSearchWeather_OnSuccess() {
        api.apiResult = .success
        viewModel.searchWeather(with: "DaNang")
        XCTAssertTrue(viewModel.searchWeatherSuccess)
        XCTAssertNotNil(viewModel.listWeather)
    }
    
    func testSearchWeather_OnError() {
        api.apiResult = .failure(NWError.noData)
        viewModel.searchWeather(with: "DaNang")
        XCTAssertFalse(viewModel.searchWeatherSuccess)
        XCTAssertNil(viewModel.listWeather)
    }
}
