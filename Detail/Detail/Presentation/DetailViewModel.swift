//
//  DetailViewModel.swift
//  Detail
//
//  Created by Dzulfaqar on 19/06/22.
//

import UIKit
import Combine
import Cleanse
import Common
import Core

public class DetailViewModel<GetUseCase: UseCase, InsertUseCase: UseCase, DeleteUseCase: UseCase, LoadUseCase: UseCase>: ObservableObject
where GetUseCase.Request == Int,
      GetUseCase.Response == [FavoriteModel],
      InsertUseCase.Request == FavoriteModel,
      InsertUseCase.Response == Bool,
      DeleteUseCase.Request == Int,
      DeleteUseCase.Response == Bool,
      LoadUseCase.Request == Int,
      LoadUseCase.Response == GameModel? {

  @Published var isError: Bool = false
  @Published var isLoading: Bool = true
  @Published var isFavorited: Bool = false
  @Published var detailData: GameModel?

  public var gameId: Int?
  public var isFromFavorite: Bool = false

  var isFavoriteChanged: Bool = false

  private var cancellables: Set<AnyCancellable> = []

  private let getUseCase: Provider<GetUseCase>
  private let insertUseCase: Provider<InsertUseCase>
  private let deleteUseCase: Provider<DeleteUseCase>
  private let loadUseCase: Provider<LoadUseCase>

  public init(
    getUseCase: Provider<GetUseCase>,
    insertUseCase: Provider<InsertUseCase>,
    deleteUseCase: Provider<DeleteUseCase>,
    loadUseCase: Provider<LoadUseCase>
  ) {
    self.getUseCase = getUseCase
    self.insertUseCase = insertUseCase
    self.deleteUseCase = deleteUseCase
    self.loadUseCase = loadUseCase
  }

  func loadDetail() {
    isError = false
    isLoading = true

    loadUseCase.get().execute(request: gameId)
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { [weak self] completion in
        switch completion {
        case .failure:
          self?.isError = true
        case .finished:
          self?.isLoading = false
        }
      }, receiveValue: { [weak self] result in
        self?.detailData = result
        self?.checkFavorite()
      })
      .store(in: &cancellables)
  }

  func getTopInsets() -> CGFloat {
    let keyWindow = UIApplication.shared.connectedScenes
      .filter({$0.activationState == .foregroundActive})
      .compactMap({$0 as? UIWindowScene})
      .first?.windows
      .filter({$0.isKeyWindow}).first
    let top = keyWindow?.safeAreaInsets.top

    let navHeight = UINavigationController().navigationBar.frame.size.height

    return CGFloat(1.0) + navHeight + (top ?? 0.0)
  }

  private func checkFavorite() {
    if let data = detailData, let dataId = data.id {
      getUseCase.get().execute(request: dataId)
        .receive(on: RunLoop.main)
        .sink(receiveCompletion: { _ in
        }, receiveValue: { [weak self] favorites in
          if !favorites.isEmpty {
            self?.isFavorited = true
          }
        })
        .store(in: &cancellables)
    }
  }

  func favoriteGame() {
    if let data = detailData, let dataId = data.id {
      if isFavorited {
        deleteUseCase.get().execute(request: dataId)
          .receive(on: RunLoop.main)
          .sink(receiveCompletion: { _ in
          }, receiveValue: { [weak self] status in
            if status {
              self?.isFavorited = false
              self?.isFavoriteChanged = true
            }
          })
          .store(in: &cancellables)

      } else {
        let favoriteModel = FavoriteModel(
          id: Int32(data.id ?? -1),
          image: data.image,
          name: data.name,
          released: data.released,
          rating: data.rating,
          date: Date()
        )

        insertUseCase.get().execute(request: favoriteModel)
          .receive(on: RunLoop.main)
          .sink(receiveCompletion: { _ in
          }, receiveValue: { [weak self] status in
            if status {
              self?.isFavorited = true
              self?.isFavoriteChanged = true
            }
          })
          .store(in: &cancellables)
      }
    }
  }
}
