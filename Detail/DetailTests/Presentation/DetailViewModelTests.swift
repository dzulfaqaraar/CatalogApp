//
//  DetailViewModelTests.swift
//  DetailTests
//
//  Created by Dzulfaqar on 23/06/22.
//

import XCTest
import Combine
import Common
import Core
import Cleanse

@testable import Detail
class DetailViewModelTests: XCTestCase {

  private var networkError: NetworkError?
  var cancellables = Set<AnyCancellable>()

  override func tearDown() {
    cancellables = []
  }

  func testLoadDetailSuccess() {
    // ARRANGE
    let getUseCase = MockGetFavoriteDetailUseCase<MockGetFavoriteDetailRepository<DetailLocaleDataSource, FavoriteTransformer>>()
    let insertUseCase = MockInsertFavoriteDetailUseCase<MockInsertFavoriteDetailRepository<DetailLocaleDataSource, FavoriteTransformer>>()
    let deleteUseCase = MockDeleteFavoriteDetailUseCase<MockDeleteFavoriteDetailRepository<DetailLocaleDataSource>>()
    let loadUseCase = MockLoadDataDetailUseCase<MockLoadDataDetailRepository<DetailRemoteDataSource, GameTransformer>>()

    let mockResponse = DummyData.dataGameModel
    loadUseCase.responseValue = mockResponse
    
    let viewModel = DetailViewModel(
      getUseCase: Provider(value: getUseCase),
      insertUseCase: Provider(value: insertUseCase),
      deleteUseCase: Provider(value: deleteUseCase),
      loadUseCase: Provider(value: loadUseCase)
    )

    let expectation = self.expectation(description: "Awaiting publisher")
    viewModel.$detailData
      .filter { $0 != nil }
      .sink { completion in
        XCTFail()
      } receiveValue: { value in
        expectation.fulfill()
      }.store(in: &cancellables)

    // ACT
    viewModel.loadDetail()

    // ASSERT
    XCTAssertEqual(false, viewModel.isError)
    XCTAssertEqual(true, viewModel.isLoading)

    // ACT
    waitForExpectations(timeout: 3)

    // ASSERT
    XCTAssert(loadUseCase.verify())
    XCTAssertEqual(false, viewModel.isError)
    XCTAssertEqual(false, viewModel.isLoading)
    XCTAssertEqual(mockResponse, viewModel.detailData)
  }

  func testLoadDetailFailure() {
    // ARRANGE
    let getUseCase = MockGetFavoriteDetailUseCase<MockGetFavoriteDetailRepository<DetailLocaleDataSource, FavoriteTransformer>>()
    let insertUseCase = MockInsertFavoriteDetailUseCase<MockInsertFavoriteDetailRepository<DetailLocaleDataSource, FavoriteTransformer>>()
    let deleteUseCase = MockDeleteFavoriteDetailUseCase<MockDeleteFavoriteDetailRepository<DetailLocaleDataSource>>()
    let loadUseCase = MockLoadDataDetailUseCase<MockLoadDataDetailRepository<DetailRemoteDataSource, GameTransformer>>()

    loadUseCase.isSuccess = false
    loadUseCase.errorValue = NetworkError.invalidResponse

    let viewModel = DetailViewModel(
      getUseCase: Provider(value: getUseCase),
      insertUseCase: Provider(value: insertUseCase),
      deleteUseCase: Provider(value: deleteUseCase),
      loadUseCase: Provider(value: loadUseCase)
    )

    // ACT
    let expectation = self.expectation(description: "Awaiting publisher")
    viewModel.$isError
      .sink { value in
        if value {
          expectation.fulfill()
        }
      }
      .store(in: &cancellables)

    viewModel.loadDetail()

    // ASSERT
    XCTAssertEqual(false, viewModel.isError)
    XCTAssertEqual(true, viewModel.isLoading)

    // ACT
    waitForExpectations(timeout: 13)

    // ASSERT
    XCTAssert(loadUseCase.verify())
    XCTAssertEqual(true, viewModel.isError)
  }
}
