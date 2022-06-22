//
//  FavoriteUseCase.swift
//  Catalog
//
//  Created by Dzulfaqar on 19/06/22.
//

import Foundation
import Combine
import Common

protocol FavoriteUseCase {
  func getAllFavorite() -> AnyPublisher<[FavoriteModel], Error>
}
