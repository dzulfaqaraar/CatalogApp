//
//  UpdateProfileUseCaseTests.swift
//  ProfileTests
//
//  Created by Dzulfaqar on 20/06/22.
//

import XCTest
import Combine
import Common
import Core

@testable import Profile
class UpdateProfileUseCaseTests: XCTestCase {

  private var databaseError: DatabaseError?

  func testUpdateProfileSuccess() throws {
    // ARRANGE
    let repository = MockUpdateProfileRepository<ProfileLocaleDataSource, ProfileTransformer>()
    repository.responseValue = true

    let useCase = Interactor(repository: repository)

    // ACT
    let image = UIImage(named: "me", in: profileBundle, with: nil)!
    let imageData = image.jpegData(compressionQuality: 1)
    let request = ProfileModel(image: imageData!, name: "Dzulfaqar", website: "www.dzulfaqar.com")

    let resultPublisher = useCase.execute(request: request)
    var response: Bool?
    do {
      response = try awaitPublisher(resultPublisher).get()
    } catch {
      databaseError = error as? DatabaseError
    }

    // ASSERT
    XCTAssertNil(databaseError)
    XCTAssertEqual(true, response)
  }

  func testUpdateProfileFailure() throws {
    // ARRANGE
    let repository = MockUpdateProfileRepository<ProfileLocaleDataSource, ProfileTransformer>()
    repository.isSuccess = false
    repository.errorValue = DatabaseError.requestFailed

    let useCase = Interactor(repository: repository)

    // ACT
    let image = UIImage(named: "me", in: profileBundle, with: nil)!
    let imageData = image.jpegData(compressionQuality: 1)
    let request = ProfileModel(image: imageData!, name: "Dzulfaqar", website: "www.dzulfaqar.com")

    let resultPublisher = useCase.execute(request: request)
    do {
      _ = try awaitPublisher(resultPublisher).get()
    } catch {
      databaseError = error as? DatabaseError
    }

    // ASSERT
    XCTAssertNotNil(databaseError)
    XCTAssertEqual(DatabaseError.requestFailed, databaseError)
  }
}
