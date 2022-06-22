//
//  GamesUseCase.swift
//  Catalog
//
//  Created by Dzulfaqar on 19/06/22.
//

import Foundation
import Combine
import Common

protocol GamesUseCase {
  func loadAllGames(param: [String: Any?], withGenres: Bool) -> AnyPublisher<([GenreModel], [GameModel]), Error>
}
