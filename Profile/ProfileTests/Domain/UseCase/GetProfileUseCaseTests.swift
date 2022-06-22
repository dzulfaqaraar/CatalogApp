//
//  GetProfileUseCaseTests.swift
//  ProfileTests
//
//  Created by Dzulfaqar on 20/06/22.
//

import XCTest
import Combine
import Common
import Core

@testable import Profile
class GetProfileUseCaseTests: XCTestCase {

  private var databaseError: DatabaseError?

  func testLoadProfileSuccess() throws {
    // ARRANGE
    let repository = MockGetProfileRepository<ProfileLocaleDataSource, ProfileTransformer>()

    let image = UIImage(named: "me", in: profileBundle, with: nil)!
    let imageData = image.jpegData(compressionQuality: 1)
    let mockResponse = ProfileModel(image: imageData, name: "Dzulfaqar", website: "www.dzulfaqar.com")
    repository.responseValue = mockResponse

    let useCase = Interactor(repository: repository)

    // ACT
    let resultPublisher = useCase.execute(request: nil)
    var response: ProfileModel?
    do {
      response = try awaitPublisher(resultPublisher).get()
    } catch {
      databaseError = error as? DatabaseError
    }

    // ASSERT
    XCTAssert(repository.verify())
    XCTAssertNil(databaseError)
    XCTAssertEqual(imageData, response?.image)
    XCTAssertEqual(mockResponse.image, response?.image)
    XCTAssertEqual(mockResponse.name, response?.name)
    XCTAssertEqual(mockResponse.website, response?.website)
  }

  func testLoadProfileFailure() throws {
    // ARRANGE
    let repository = MockGetProfileRepository<ProfileLocaleDataSource, ProfileTransformer>()
    repository.isSuccess = false
    repository.errorValue = DatabaseError.requestFailed

    let useCase = Interactor(repository: repository)

    // ACT
    let resultPublisher = useCase.execute(request: nil)
    do {
      _ = try awaitPublisher(resultPublisher).get()
    } catch {
      databaseError = error as? DatabaseError
    }

    // ASSERT
    XCTAssert(repository.verify())
    XCTAssertNotNil(databaseError)
    XCTAssertEqual(DatabaseError.requestFailed, databaseError)
  }
}
