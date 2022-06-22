//
//  GameSectionController.swift
//  Catalog
//
//  Created by Dzulfaqar on 04/06/22.
//

import UIKit
import IGListKit
import Common

class GameSectionModel: NSObject {
  var list: [GameModel] = []

  init(list: [GameModel]) {
    self.list = list
  }
}

class GameSectionController: ListSectionController {
  var game: GameSectionModel!
  var callback: ((Int) -> Void)?

  override init() {
    super.init()
    inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }
}

// MARK: - Data Provider
extension GameSectionController {
  override func numberOfItems() -> Int {
    return 1
  }

  override func sizeForItem(at index: Int) -> CGSize {
    guard let context = collectionContext else { return .zero }
    let width: CGFloat = context.containerSize.width
    let height: CGFloat = context.containerSize.height
    return CGSize(width: width, height: height)
  }

  override func cellForItem(at index: Int) -> UICollectionViewCell {
    if let cell = collectionContext?.dequeueReusableCell(
      of: GameSectionCell.self, for: self, at: index
    ) as? GameSectionCell {
      cell.callback = callback
      cell.build(data: game.list)
      return cell
    }

    return UICollectionViewCell()
  }

  override func didUpdate(to object: Any) {
    game = object as? GameSectionModel
  }
}
