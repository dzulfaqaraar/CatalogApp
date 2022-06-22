//
//  DetailComponent.swift
//  Catalog
//
//  Created by Dzulfaqar on 14/06/22.
//

import Foundation
import Cleanse
import Detail

struct DetailComponent: RootComponent {
  typealias Root = DetailViewModel

  static func configureRoot(binder bind: ReceiptBinder<DetailViewModel>) -> BindingReceipt<DetailViewModel> {
    return bind.to(factory: DetailViewModel.init)
  }

  static func configure(binder: Binder<Singleton>) {
    binder.include(module: DetailModule.self)
  }
}
