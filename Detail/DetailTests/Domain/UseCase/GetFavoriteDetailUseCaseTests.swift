//
//  GetFavoriteDetailUseCaseTests.swift
//  DetailTests
//
//  Created by Dzulfaqar on 21/06/22.
//

import XCTest
import Combine
import Common
import Core

@testable import Detail
class GetFavoriteDetailUseCaseTests: XCTestCase {

  private var databaseError: DatabaseError?

  func testGetFavoriteSuccess() throws {
    // ARRANGE
    let repository = MockGetFavoriteDetailRepository<DetailLocaleDataSource, FavoriteTransformer>()

    let mapper = FavoriteTransformer()
    let mockResponse: [FavoriteModel] = [mapper.transformEntityToDomain(entity: DummyData.dataFavoriteEntity)]
    repository.responseValue = mockResponse

    let useCase = Interactor(repository: repository)

    // ACT
    let resultPublisher = useCase.execute(request: 1)
    var response: [FavoriteModel]?
    do {
      response = try awaitPublisher(resultPublisher).get()
    } catch {
      databaseError = error as? DatabaseError
    }

    // ASSERT
    XCTAssert(repository.verify())
    XCTAssertNil(databaseError)
    XCTAssertEqual(mockResponse, response)
  }

  func testGetFavoriteFailure() throws {
    // ARRANGE
    let repository = MockGetFavoriteDetailRepository<DetailLocaleDataSource, FavoriteTransformer>()
    repository.isSuccess = false
    repository.errorValue = DatabaseError.requestFailed

    let useCase = Interactor(repository: repository)

    // ACT
    let resultPublisher = useCase.execute(request: 1)
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
