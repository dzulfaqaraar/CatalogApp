//
//  InsertFavoriteDetailUseCase.swift
//  Detail
//
//  Created by Dzulfaqar on 20/06/22.
//

import Foundation
import Core
import Common
import Combine
import Cleanse

public class InsertFavoriteDetailUseCase: UseCase {
  public typealias Request = FavoriteModel
  public typealias Response = Bool

  private let repository: Provider<InsertFavoriteDetailRepository<DetailLocaleDataSource, FavoriteTransformer>>

  public init(repository: Provider<InsertFavoriteDetailRepository<DetailLocaleDataSource, FavoriteTransformer>>) {
    self.repository = repository
  }

  public func execute(request: FavoriteModel?) -> AnyPublisher<Bool, Error> {
    repository.get().execute(request: request)
  }
}
