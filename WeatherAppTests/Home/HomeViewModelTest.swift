//
//  HomeViewModelTest.swift
//  WeatherAppTests
//
//  Created by Nguyen Tran on 19/05/2022.
//

@testable import WeatherApp
import XCTest

class HomeViewModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSearchWeather_OnSuccess() {
        let api = APIMock()
        api.apiResult = .success
        let viewModel = HomeViewModel(api: api, dataLocalManager: DataManagerMock())
        viewModel.onGetListSearchSuccess = { response in
            XCTAssertNotNil(response)
        }
        viewModel.searchWeather(with: "HaN")
    }
    
    func testSearchWeather_OnError() {
        let api = APIMock()
        api.apiResult = .failure(NWError.noData)
        let viewModel = HomeViewModel(api: api, dataLocalManager: DataManagerMock())
        viewModel.onGetListSearchFail = { errorMessage in
            XCTAssertNotNil(errorMessage)
        }
        viewModel.searchWeather(with: "H")
    }

    func testExistLocalData() {
        let dataManager = DataManagerMock()
        let dataMock = [SearchWeatherCityModel].mock(from: "local_data_mock")!
        dataManager.saveWeatherLocations(dataMock)
        let viewModel = HomeViewModel(api: APIMock(), dataLocalManager: dataManager)
        XCTAssertTrue(!viewModel.getWeatherLocations().isEmpty)
    }

    func testLocalDataEmpty() {
        let dataManager = DataManagerMock()
        dataManager.clear()
        let viewModel = HomeViewModel(api: APIMock(), dataLocalManager: dataManager)
        XCTAssertEqual(viewModel.getWeatherLocations().count, 0)
    }
    
    func testInsertWeatherDataSuccess() {
        let weatherMock = SearchWeatherCityModel.mock(from: "weather_data_mock")!
        let dataManager = DataManagerMock()
        let viewModel = HomeViewModel(api: APIMock(), dataLocalManager: dataManager)
        viewModel.saveWeatherLocations(weatherMock)
        XCTAssertTrue(!viewModel.getWeatherLocations().isEmpty)
        XCTAssertEqual(viewModel.getWeatherLocations()[0].getAreaName(), weatherMock.getAreaName())
    }
}
