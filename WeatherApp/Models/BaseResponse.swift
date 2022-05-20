//
//  BaseResponse.swift
//  WeatherApp
//
//  Created by Nguyen Tran on 17/05/2022.
//

import Foundation

struct BaseResponse<T: Codable>: Codable {
    let data: T
}
