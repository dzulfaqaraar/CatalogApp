//
//  DetailViewController.swift
//  Detail
//
//  Created by Dzulfaqar on 19/06/22.
//

import SwiftUI
import Common

public class DetailViewController: UIViewController {

  public typealias GetType = GetFavoriteDetailUseCase<GetFavoriteDetailRepository<DetailLocaleDataSource, FavoriteTransformer>>
  public typealias InsertType = InsertFavoriteDetailUseCase<InsertFavoriteDetailRepository<DetailLocaleDataSource, FavoriteTransformer>>
  public typealias DeleteType = DeleteFavoriteDetailUseCase<DeleteFavoriteDetailRepository<DetailLocaleDataSource>>
  public typealias LoadType = LoadDataDetailUseCase<LoadDataDetailRepository<DetailRemoteDataSource, GameTransformer>>

  private var viewModel: DetailViewModel<GetType, InsertType, DeleteType, LoadType>
  public var callback: (() -> Void)?

  public init(viewModel: DetailViewModel<GetType, InsertType, DeleteType, LoadType>) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.title = ""

    let rootView = DetailSwiftUIView(viewModel: viewModel)
    let childView = UIHostingController(rootView: rootView)
    addChild(childView)

    let detailView: UIView = childView.view
    view.addSubview(detailView)

    detailView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      detailView.leftAnchor.constraint(equalTo: view.leftAnchor),
      detailView.topAnchor.constraint(equalTo: view.topAnchor),
      detailView.rightAnchor.constraint(equalTo: view.rightAnchor),
      detailView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }

  public override func viewDidDisappear(_ animated: Bool) {
    if viewModel.isFromFavorite && viewModel.isFavoriteChanged {
      callback?()
    }
    super.viewDidDisappear(animated)
  }
}
