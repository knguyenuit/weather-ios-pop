//
//  Decodable+Ext.swift
//  WeatherAppTests
//
//  Created by Nguyen Tran on 19/05/2022.
//

import Foundation

extension Decodable {
    static func mock(from jsonFile: String) -> Self? {
        guard let path = Bundle.main.path(forResource: jsonFile, ofType: "json"),
              let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        else {
            return nil
        }
        return try? JSONDecoder().decode(Self.self, from: jsonData)
    }
}

struct WrappedBaseResult<T: Decodable>: Decodable {
    let data: T?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try? values.decodeIfPresent(T.self, forKey: .data)
    }
}
