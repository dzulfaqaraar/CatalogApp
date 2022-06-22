//
//  SearchRepository.swift
//  Search
//
//  Created by Dzulfaqar on 19/06/22.
//

import Foundation
import Common
import Combine
import Cleanse
import Core

public struct SearchRepository<Remote: RemoteDataSource, Transformer: Mapper>: Repository
where Remote.Request == [String: Any?],
      Remote.Response == GameResponse?,
      Transformer.Response == [GameResultResponse],
      Transformer.Entity == Any,
      Transformer.Domain == [GameModel] {

  public typealias Request = [String: Any?]
  public typealias Response = [GameModel]

  private let remote: Provider<Remote>
  private let mapper: Provider<Transformer>

  init(
    remote: Provider<Remote>,
    mapper: Provider<Transformer>
  ) {
    self.remote = remote
    self.mapper = mapper
  }

  public func execute(request: [String : Any?]?) -> AnyPublisher<[GameModel], Error> {
    remote.get().execute(request: request)
      .map { response in
        mapper.get().transformResponseToDomain(response: response?.results ?? [])
      }.eraseToAnyPublisher()
  }
}
