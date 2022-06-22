//
//  MockGetProfileRepository.swift
//  ProfileTests
//
//  Created by Dzulfaqar on 20/06/22.
//

import Foundation
import Combine
import Common
import Core

@testable import Profile
public class MockGetProfileRepository<Locale: LocaleDataSource, Transformer: Mapper>: Repository
where Locale.Response == ProfileEntity,
      Transformer.Response == Any,
      Transformer.Entity == ProfileEntity,
      Transformer.Domain == ProfileModel {

  public typealias Request = Any
  public typealias Response = ProfileModel

  var isSuccess = true
  var responseValue: ProfileModel?
  var errorValue: Error?
  var functionWasCalled = false

  func verify() -> Bool {
    return functionWasCalled
  }

  public func execute(request: Any?) -> AnyPublisher<ProfileModel, Error> {
    functionWasCalled = true
    return Future<ProfileModel, Error> { completion in
      if self.isSuccess {
        if let responseValue = self.responseValue {
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
