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

public class LoadDataDetailUseCase<R: Repository>: UseCase
where R.Request == Int,
      R.Response == GameModel? {

  public typealias Request = Int
  public typealias Response = GameModel?

  private let repository: Provider<R>

  public init(repository: Provider<R>) {
    self.repository = repository
  }

  public func execute(request: Int?) -> AnyPublisher<GameModel?, Error> {
    repository.get().execute(request: request)
  }
}
