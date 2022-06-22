//
//  DetailModule.swift
//  Detail
//
//  Created by Dzulfaqar on 19/06/22.
//

import Foundation
import Cleanse
import Common
import Core

struct DetailLocaleDataSourceModule: Module {
  static func configure(binder: Binder<Singleton>) {
    binder.bind(DetailLocaleDataSource.self)
      .sharedInScope()
      .to(factory: DetailLocaleDataSource.init)
  }
}

struct DetailRemoteDataSourceModule: Module {
  static func configure(binder: Binder<Singleton>) {
    binder.bind(NetworkManager.self)
      .sharedInScope()
      .to(factory: NetworkManager.init)

    binder.bind(DetailRemoteDataSource.self)
      .sharedInScope()
      .to(factory: DetailRemoteDataSource.init)
  }
}

struct DetailMapperModule: Module {
  static func configure(binder: Binder<Singleton>) {
    binder.bind(GameTransformer.self)
      .sharedInScope()
      .to(factory: GameTransformer.init)
    binder.bind(FavoriteTransformer.self)
      .sharedInScope()
      .to(factory: FavoriteTransformer.init)
  }
}

struct DetailRepositoryModule: Module {
  static func configure(binder: Binder<Singleton>) {
    binder.include(module: DetailLocaleDataSourceModule.self)
    binder.include(module: DetailRemoteDataSourceModule.self)
    binder.include(module: DetailMapperModule.self)

    binder.bind(GetFavoriteDetailRepository<DetailLocaleDataSource, FavoriteTransformer>.self)
      .sharedInScope()
      .to(factory: GetFavoriteDetailRepository<DetailLocaleDataSource, FavoriteTransformer>.init)

    binder.bind(InsertFavoriteDetailRepository<DetailLocaleDataSource, FavoriteTransformer>.self)
      .sharedInScope()
      .to(factory: InsertFavoriteDetailRepository<DetailLocaleDataSource, FavoriteTransformer>.init)

    binder.bind(DeleteFavoriteDetailRepository<DetailLocaleDataSource>.self)
      .sharedInScope()
      .to(factory: DeleteFavoriteDetailRepository<DetailLocaleDataSource>.init)

    binder.bind(LoadDataDetailRepository<DetailRemoteDataSource, GameTransformer>.self)
      .sharedInScope()
      .to(factory: LoadDataDetailRepository<DetailRemoteDataSource, GameTransformer>.init)
  }
}

struct DetailUseCaseModule: Module {
  static func configure(binder: Binder<Singleton>) {
    binder.include(module: DetailRepositoryModule.self)

    binder.bind(GetFavoriteDetailUseCase.self)
      .sharedInScope()
      .to(factory: GetFavoriteDetailUseCase.init)
    binder.bind(Interactor<Int, [FavoriteModel], GetFavoriteDetailRepository<DetailLocaleDataSource, FavoriteTransformer>>.self)
      .sharedInScope()
      .to(factory: Interactor.init)

    binder.bind(InsertFavoriteDetailUseCase.self)
      .sharedInScope()
      .to(factory: InsertFavoriteDetailUseCase.init)
    binder.bind(Interactor<FavoriteModel, Bool, InsertFavoriteDetailRepository<DetailLocaleDataSource, FavoriteTransformer>>.self)
      .sharedInScope()
      .to(factory: Interactor.init)

    binder.bind(DeleteFavoriteDetailUseCase.self)
      .sharedInScope()
      .to(factory: DeleteFavoriteDetailUseCase.init)
    binder.bind(Interactor<Int, Bool, DeleteFavoriteDetailRepository<DetailLocaleDataSource>>.self)
      .sharedInScope()
      .to(factory: Interactor.init)

    binder.bind(LoadDataDetailUseCase.self)
      .sharedInScope()
      .to(factory: LoadDataDetailUseCase.init)
    binder.bind(Interactor<Int, GameModel?, LoadDataDetailRepository<DetailRemoteDataSource, GameTransformer>>.self)
      .sharedInScope()
      .to(factory: Interactor.init)
  }
}

public struct DetailModule: Module {
  public static func configure(binder: Binder<Singleton>) {
    binder.include(module: DetailUseCaseModule.self)
  }
}
