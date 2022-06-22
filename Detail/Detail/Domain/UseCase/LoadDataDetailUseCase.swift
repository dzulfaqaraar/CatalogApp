//
//  LoadDataDetailUseCase.swift
//  Detail
//
//  Created by Dzulfaqar on 20/06/22.
//

import Foundation
import Core
import Common
import Combine
import Cleanse

public class LoadDataDetailUseCase: UseCase {
  public typealias Request = Int
  public typealias Response = GameModel?

  private let repository: Provider<LoadDataDetailRepository<DetailRemoteDataSource, GameTransformer>>

  public init(repository: Provider<LoadDataDetailRepository<DetailRemoteDataSource, GameTransformer>>) {
    self.repository = repository
  }

  public func execute(request: Int?) -> AnyPublisher<GameModel?, Error> {
    repository.get().execute(request: request)
  }
}

