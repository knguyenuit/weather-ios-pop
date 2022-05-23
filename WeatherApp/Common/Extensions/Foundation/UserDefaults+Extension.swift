//
//  UserDefaults+Extension.swift
//  WeatherApp
//
//  Created by Nguyen Tran on 19/05/2022.
//

import Foundation

extension UserDefaults {
    struct Keys {
        static let weatherLocation = "weatherLocation"
        static let weatherLocationMock = "weatherLocationMock"
    }
    
    static var weatherLocationData: Data? {
        set { standard.set(newValue, forKey: Keys.weatherLocation) }
        get { standard.data(forKey: Keys.weatherLocation) ?? nil }
    }
    
    static var weatherLocationDataMock: Data? {
        set { standard.set(newValue, forKey: Keys.weatherLocationMock) }
        get { standard.data(forKey: Keys.weatherLocationMock) ?? nil }
    }
}
