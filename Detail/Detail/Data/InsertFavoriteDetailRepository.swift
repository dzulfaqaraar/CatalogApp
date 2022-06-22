//
//  InsertFavoriteDetailRepository.swift
//  Detail
//
//  Created by Dzulfaqar on 20/06/22.
//

import Foundation
import Core
import Combine
import Cleanse
import Common

public struct InsertFavoriteDetailRepository<Locale: LocaleDataSource, Transformer: Mapper>: Repository
where Locale.Response == FavoriteEntity,
      Transformer.Response == Any,
      Transformer.Entity == [FavoriteEntity],
      Transformer.Domain == [FavoriteModel] {

  public typealias Request = FavoriteModel
  public typealias Response = Bool

  private let locale: Provider<Locale>
  private let mapper: Provider<Transformer>

  public init(
    locale: Provider<Locale>,
    mapper: Provider<Transformer>
  ) {
    self.locale = locale
    self.mapper = mapper
  }

  public func execute(request: FavoriteModel?) -> AnyPublisher<Bool, Error> {
    let dataMapped = mapper.get().transformDomainToEntity(domain: [request ?? FavoriteModel()])
    return locale.get().add(data: dataMapped)
  }
}
