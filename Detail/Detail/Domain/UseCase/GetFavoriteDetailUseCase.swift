//
//  GetFavoriteDetailUseCase.swift
//  Detail
//
//  Created by Dzulfaqar on 20/06/22.
//

import Foundation
import Core
import Common
import Combine
import Cleanse

public class GetFavoriteDetailUseCase: UseCase {
  public typealias Request = Int
  public typealias Response = [FavoriteModel]

  private let repository: Provider<GetFavoriteDetailRepository<DetailLocaleDataSource, FavoriteTransformer>>

  public init(repository: Provider<GetFavoriteDetailRepository<DetailLocaleDataSource, FavoriteTransformer>>) {
    self.repository = repository
  }

  public func execute(request: Int?) -> AnyPublisher<[FavoriteModel], Error> {
    repository.get().execute(request: request)
  }
}
