//
//  FavoriteInteractor.swift
//  Catalog
//
//  Created by Dzulfaqar on 14/06/22.
//

import Foundation
import Combine
import Cleanse
import Common

class FavoriteInteractor {
  private let repository: Provider<HomeRepositoryProtocol>

  required init(repository: Provider<HomeRepositoryProtocol>) {
    self.repository = repository
  }
}

extension FavoriteInteractor: FavoriteUseCase {
  func getAllFavorite() -> AnyPublisher<[FavoriteModel], Error> {
    return repository.get().getAllFavorite()
  }
}
