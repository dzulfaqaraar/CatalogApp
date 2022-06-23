//
//  MockGameTransformer.swift
//  SearchTests
//
//  Created by Dzulfaqar on 23/06/22.
//

import Common
import Core

class MockGameTransformer: Mapper {
  typealias Response = [GameResultResponse]
  typealias Entity = Any
  typealias Domain = [GameModel]

  private var functionWasCalled = false
  var responseDomain: [GameModel] = []

  func verify() -> Bool {
    return functionWasCalled
  }

  func transformResponseToDomain(response: [GameResultResponse]) -> [GameModel] {
    functionWasCalled = true
    return responseDomain
  }

  func transformResponseToEntity(response: [GameResultResponse]) -> Any {
    fatalError()
  }

  func transformEntityToDomain(entity: Any) -> [GameModel] {
    fatalError()
  }

  func transformDomainToEntity(domain: [GameModel]?) -> Any {
    fatalError()
  }
}
