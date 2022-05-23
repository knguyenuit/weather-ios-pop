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
    private var dataManager: DataManagerMock!
    
    override func setUp() {
        super.setUp()
        api = APIMock()
        dataManager = DataManagerMock()
        viewModel = HomeViewModelMock(api: api, dataManager: dataManager)
    }
    
    override func tearDown() {
        api = nil
        viewModel = nil
        dataManager.clear()
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
        viewModel.searchWeather(with: "HaN")
        XCTAssertTrue(viewModel.searchWeatherSuccess)
        XCTAssertNotNil(viewModel.listWeather)
    }
    
    func testSearchWeather_OnError() {
        api.apiResult = .failure(NWError.noData)
        viewModel.searchWeather(with: "HaN")
        XCTAssertFalse(viewModel.searchWeatherSuccess)
        XCTAssertNil(viewModel.listWeather)
    }
    
    func testExistLocalData() {
        let dataMock = [SearchWeatherCityModel].mock(from: "local_data_mock")!
        dataManager.saveWeatherLocations(dataMock)
        XCTAssertTrue(!viewModel.getDataLocalWeather().isEmpty)
    }
    
    func testLocalDataEmpty() {
        dataManager.clear()
        XCTAssertTrue(viewModel.getDataLocalWeather().isEmpty)
    }
}
