//
//  SearchUseCase.swift
//  Search
//
//  Created by Dzulfaqar on 19/06/22.
//

import Foundation
import Core
import Common
import Combine
import Cleanse

public class SearchUseCase: UseCase {
  public typealias Request = [String: Any?]
  public typealias Response = [GameModel]

  private let repository: Provider<SearchRepository<SearchRemoteDataSource, GameTransformer>>

  public init(repository: Provider<SearchRepository<SearchRemoteDataSource, GameTransformer>>) {
    self.repository = repository
  }

  public func execute(request: [String : Any?]?) -> AnyPublisher<[GameModel], Error> {
    repository.get().execute(request: request)
  }
}
