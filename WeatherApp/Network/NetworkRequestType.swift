//
//  NetworkRequestType.swift
//  WeatherApp
//
//  Created by Nguyen Tran on 26/05/2022.
//

import Foundation

protocol RequestType {
    associatedtype ResponseType: Codable
    var data: RequestData { get }
    var requestInput: RequestInput? { get }
}

extension RequestType {
    func execute (
        dispatcher: NetworkDispatcher = URLSessionNetworkDispatcher(),
        onSuccess: @escaping (ResponseType) -> Void,
        onError: @escaping (Error) -> Void
    ) {
        dispatcher.dispatch(
            request: self.data,
            onSuccess: { (responseData: Data) in
                print(responseData.jsonString)
                do {
                    let jsonDecoder = JSONDecoder()
                    let result = try jsonDecoder.decode(ResponseType.self, from: responseData)
                    DispatchQueue.main.async {
                        onSuccess(result)
                    }
                } catch let error {
                    let er = parseError(data: responseData) ?? error
                    DispatchQueue.main.async {
                        onError(er)
                    }
                }
            },
            onError: { (error: Error) in
                DispatchQueue.main.async {
                    onError(error)
                }
            }
        )
    }
    
    private func parseError(data: Data) -> Error? {
        do {
            let apiError = try JSONDecoder().decode(APIError.self, from: data)
            return NWError.apiError(apiError)
        } catch {
            return nil
        }
    }
}
