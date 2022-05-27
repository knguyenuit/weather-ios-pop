//
//  URLSessionMock.swift
//  WeatherAppTests
//
//  Created by cristian on 27/05/2022.
//

import Foundation
@testable import WeatherApp

public final class URLSessionMock : DHURLSession {
  var url: URL?
  var request: URLRequest?
  private let dataTaskMock: URLSessionDataTaskMock
  
  public init(data: Data?, response: URLResponse?, error: Error?) {
      dataTaskMock = URLSessionDataTaskMock()
      dataTaskMock.taskResponse = (data, response, error)
  }
  
  public func dataTaskWithRequest(request: URLRequest,
    completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
      self.request = request
      self.dataTaskMock.completionHandler = completionHandler
      return self.dataTaskMock
  }
  
  final private class URLSessionDataTaskMock : URLSessionDataTask {

    typealias CompletionHandler = (Data, URLResponse, Error) -> Void
    var completionHandler: CompletionHandler?
    var taskResponse: (Data?, URLResponse?, Error?)?
      
    override func resume() {
        completionHandler?((taskResponse?.0)!, (taskResponse?.1)!, taskResponse?.2 as! Error )
    }
  }
}
