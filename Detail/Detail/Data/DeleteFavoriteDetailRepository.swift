//
//  DeleteFavoriteDetailRepository.swift
//  Detail
//
//  Created by Dzulfaqar on 20/06/22.
//

import Foundation
import Core
import Combine
import Cleanse

public struct DeleteFavoriteDetailRepository<Locale: LocaleDataSource>: Repository
where Locale.Request == Int {

  public typealias Request = Int
  public typealias Response = Bool

  private let locale: Provider<Locale>

  public init(locale: Provider<Locale>) {
    self.locale = locale
  }

  public func execute(request: Int?) -> AnyPublisher<Bool, Error> {
    locale.get().delete(id: request ?? -1)
  }
}
