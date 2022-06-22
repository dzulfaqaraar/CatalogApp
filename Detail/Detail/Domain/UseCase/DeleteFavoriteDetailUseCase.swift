//
//  DeleteFavoriteDetailUseCase.swift
//  Detail
//
//  Created by Dzulfaqar on 20/06/22.
//

import Foundation
import Core
import Combine
import Cleanse

public class DeleteFavoriteDetailUseCase: UseCase {
  public typealias Request = Int
  public typealias Response = Bool

  private let repository: Provider<DeleteFavoriteDetailRepository<DetailLocaleDataSource>>

  public init(repository: Provider<DeleteFavoriteDetailRepository<DetailLocaleDataSource>>) {
    self.repository = repository
  }

  public func execute(request: Int?) -> AnyPublisher<Bool, Error> {
    repository.get().execute(request: request)
  }
}
