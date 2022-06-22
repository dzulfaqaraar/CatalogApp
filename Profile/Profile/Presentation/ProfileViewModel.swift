//
//  ProfileViewModel.swift
//  Catalog
//
//  Created by Dzulfaqar on 07/06/22.
//

import Foundation
import Combine
import Cleanse
import Core

public class ProfileViewModel {

  private var cancellables: Set<AnyCancellable> = []

  var profileData: ProfileModel?
  var isShowingData = CurrentValueSubject<Bool, Never>(false)
  var profileUpdated = CurrentValueSubject<Bool, Never>(false)

  private let getUseCase: Provider<Interactor<Int, ProfileModel, GetProfileRepository<ProfileLocaleDataSource, ProfileTransformer>>>
  private let updateUseCase: Provider<Interactor<ProfileModel, Bool, UpdateProfileRepository<ProfileLocaleDataSource, ProfileTransformer>>>

  public init(
    getUseCase: Provider<Interactor<Int, ProfileModel, GetProfileRepository<ProfileLocaleDataSource, ProfileTransformer>>>,
    updateUseCase: Provider<Interactor<ProfileModel, Bool, UpdateProfileRepository<ProfileLocaleDataSource, ProfileTransformer>>>
  ) {
    self.getUseCase = getUseCase
    self.updateUseCase = updateUseCase
  }

  func loadProfile() {
    getUseCase.get().execute(request: nil)
      .receive(on: RunLoop.main)
      .sink { _ in
      } receiveValue: { [weak self] response in
        self?.profileData = response
        self?.isShowingData.send(true)
      }
      .store(in: &cancellables)
  }

  func saveProfile(
    _ image: Data,
    _ name: String,
    _ website: String
  ) {
    let request = ProfileModel(image: image, name: name, website: website)
    updateUseCase.get().execute(request: request)
      .receive(on: RunLoop.main)
      .sink { _ in
      } receiveValue: { [weak self] status in
        self?.profileUpdated.send(true)
      }
      .store(in: &cancellables)
  }
}
