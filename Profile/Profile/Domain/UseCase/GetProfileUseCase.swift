//
//  GetProfileUseCase.swift
//  Profile
//
//  Created by Dzulfaqar on 19/06/22.
//

import Foundation
import Core
import Common
import Combine
import Cleanse

public class GetProfileUseCase: UseCase {
  public typealias Request = Int
  public typealias Response = ProfileModel

  private let repository: Provider<GetProfileRepository<ProfileLocaleDataSource, ProfileTransformer>>

  public init(repository: Provider<GetProfileRepository<ProfileLocaleDataSource, ProfileTransformer>>) {
    self.repository = repository
  }

  public func execute(request: Int?) -> AnyPublisher<ProfileModel, Error> {
    repository.get().execute(request: request)
  }
}
