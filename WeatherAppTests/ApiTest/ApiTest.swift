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
    }
    
    override func tearDown() {
        api = nil
        super.tearDown()
    }
    
    func testGetLocalWeather_OnSuccess() {
        guard let path = Bundle.main.path(forResource: "local_weather_mock_response", ofType: "json"),
              let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        else {
            return
        }
        api = API(session: URLSessionMock(data: jsonData, response: nil, error: nil))

        api.getLocalWeather(with: "Danang") { response in
            XCTAssertNotNil(response)
        } onError: { error in
            XCTAssertNil(error)
        }
    }
    
    func testGetLocalWeather_OnFail() {
        api = API(session: URLSessionMock(data: nil, response: nil, error: NSError()))
        api.getLocalWeather(with: "Danang") { response in
            XCTAssertNil(response)
        } onError: { error in
            XCTAssertNotNil(error)
        }
    }
    
    func testSearchWeather_OnSuccess() {
        guard let path = Bundle.main.path(forResource: "search_weather_mock_response", ofType: "json"),
              let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        else {
            return
        }
        api = API(session: URLSessionMock(data: jsonData, response: nil, error: nil))

        api.searchWeather(with: "Danang") { response in
            XCTAssertNotNil(response)
        } onError: { error in
            XCTAssertNil(error)
        }
    }
    
    func testSearchlWeather_OnFail() {
        api = API(session: URLSessionMock(data: nil, response: nil, error: NSError()))
        api.searchWeather(with: "Danang") { response in
            XCTAssertNil(response)
        } onError: { error in
            XCTAssertNotNil(error)
        }
    }
}
