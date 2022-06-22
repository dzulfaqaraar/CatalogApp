//
//  InsertFavoriteDetailUseCaseTests.swift
//  DetailTests
//
//  Created by Dzulfaqar on 21/06/22.
//

import XCTest
import Combine
import Common
import Core

@testable import Detail
class InsertFavoriteDetailUseCaseTests: XCTestCase {

  private var databaseError: DatabaseError?

  func testInsertFavoriteSuccess() throws {
    // ARRANGE
    let repository = MockInsertFavoriteDetailRepository<DetailLocaleDataSource, FavoriteTransformer>()
    repository.responseValue = true

    let useCase = Interactor(repository: repository)

    // ACT
    let mapper = FavoriteTransformer()
    let favoriteModel = mapper.transformEntityToDomain(entity: DummyData.dataFavoriteEntity)
    let resultPublisher = useCase.execute(request: favoriteModel)
    var response: Bool?
    do {
      response = try awaitPublisher(resultPublisher).get()
    } catch {
      databaseError = error as? DatabaseError
    }

    // ASSERT
    XCTAssert(repository.verify())
    XCTAssertNil(databaseError)
    XCTAssertEqual(true, response)
  }

  func testInsertFavoriteFailure() throws {
    // ARRANGE
    let repository = MockInsertFavoriteDetailRepository<DetailLocaleDataSource, FavoriteTransformer>()
    repository.isSuccess = false
    repository.errorValue = DatabaseError.requestFailed

    let useCase = Interactor(repository: repository)

    // ACT
    let mapper = FavoriteTransformer()
    let favoriteModel = mapper.transformEntityToDomain(entity: DummyData.dataFavoriteEntity)
    let resultPublisher = useCase.execute(request: favoriteModel)
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
