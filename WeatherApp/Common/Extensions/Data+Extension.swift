//
//  Data+Extension.swift
//  WeatherApp
//
//  Created by Nguyen Tran on 17/05/2022.
//

import Foundation

extension Data {
    var jsonString: String {
        do {
            guard let json = try JSONSerialization.jsonObject(with: self) as? [String: Any] else { return "" }
            return json.jsonString
        } catch _ {
            return ""
        }
    }
}
