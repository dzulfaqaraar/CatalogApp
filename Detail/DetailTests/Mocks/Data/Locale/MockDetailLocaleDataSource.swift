//
//  MockDetailLocaleDataSource.swift
//  DetailTests
//
//  Created by Dzulfaqar on 22/06/22.
//

import XCTest
import Combine
import Common
import Core
import Detail

class MockDetailLocaleDataSource<T>: LocaleDataSource {

  typealias Request = Int
  typealias Response = FavoriteEntity

  var isSuccess = true
  var responseValue: T?
  var errorValue: Error?

  func list(request: Int?) -> AnyPublisher<[FavoriteEntity], Error> {
    fatalError()
  }

  func get(id: Int?) -> AnyPublisher<FavoriteEntity, Error> {
    return Future<FavoriteEntity, Error> { completion in
      if self.isSuccess {
        if let responseValue = self.responseValue as? FavoriteEntity {
          completion(.success(responseValue))
        }
      } else {
        if let errorValue = self.errorValue {
          completion(.failure(errorValue))
        }
      }
    }.eraseToAnyPublisher()
  }

  func add(data: [FavoriteEntity]) -> AnyPublisher<Bool, Error> {
    return Future<Bool, Error> { completion in
      if self.isSuccess {
        if let responseValue = self.responseValue as? Bool {
          completion(.success(responseValue))
        }
      } else {
        if let errorValue = self.errorValue {
          completion(.failure(errorValue))
        }
      }
    }.eraseToAnyPublisher()
  }

  func update(data: FavoriteEntity) -> AnyPublisher<Bool, Error> {
    fatalError()
  }

  func delete(id: Int) -> AnyPublisher<Bool, Error> {
    return Future<Bool, Error> { completion in
      if self.isSuccess {
        if let responseValue = self.responseValue as? Bool {
          completion(.success(responseValue))
        }
      } else {
        if let errorValue = self.errorValue {
          completion(.failure(errorValue))
        }
      }
    }.eraseToAnyPublisher()
  }
}
