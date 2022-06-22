//
//  RemoteDataSource.swift
//  Core
//
//  Created by Dzulfaqar on 18/06/22.
//

import Foundation
import Combine

public protocol RemoteDataSource {
  associatedtype Request
  associatedtype Response

  func execute(request: Request?) -> AnyPublisher<Response, Error>
}
