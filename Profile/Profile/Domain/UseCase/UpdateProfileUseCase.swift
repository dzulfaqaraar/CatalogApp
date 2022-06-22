//
//  UpdateProfileUseCase.swift
//  Profile
//
//  Created by Dzulfaqar on 20/06/22.
//

import Foundation
import Core
import Common
import Combine
import Cleanse

public class UpdateProfileUseCase: UseCase {
  public typealias Request = ProfileModel
  public typealias Response = Bool

  private let repository: Provider<UpdateProfileRepository<ProfileLocaleDataSource, ProfileTransformer>>

  public init(repository: Provider<UpdateProfileRepository<ProfileLocaleDataSource, ProfileTransformer>>) {
    self.repository = repository
  }

  public func execute(request: ProfileModel?) -> AnyPublisher<Bool, Error> {
    repository.get().execute(request: request)
  }
}
