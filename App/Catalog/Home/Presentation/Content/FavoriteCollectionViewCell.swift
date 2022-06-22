//
//  FavoriteCollectionViewCell.swift
//  Catalog
//
//  Created by Dzulfaqar on 07/06/22.
//

import UIKit
import Common

class FavoriteCollectionViewCell: UICollectionViewCell {

  @IBOutlet weak var parentView: UIView!
  @IBOutlet weak var backgroundCover: UIView!
  @IBOutlet weak var favoriteImage: UIImageView!
  @IBOutlet weak var favoriteTitle: UILabel!
  @IBOutlet weak var favoriteRelease: UILabel!
  @IBOutlet weak var favoriteRating: UILabel!
  @IBOutlet weak var loadingView: UIActivityIndicatorView!

  var callback: ((Int) -> Void)?
  var data: FavoriteModel?

  override func awakeFromNib() {
    super.awakeFromNib()
    favoriteImage.layer.cornerRadius = 20

    contentView.layer.cornerRadius = 20
    contentView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.3)

    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(itemSelected(sender:)))
    parentView.addGestureRecognizer(tapGesture)
  }

  @objc func itemSelected(sender: UITapGestureRecognizer) {
    if let id = data?.id {
      callback?(Int(id))
    }
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    favoriteImage.image = nil
    favoriteTitle.text = ""
    favoriteRelease.text = ""
    favoriteRating.text = ""
    backgroundCover.backgroundColor = nil
  }

  func setup(with data: FavoriteModel) {
    self.data = data

    favoriteImage.load(url: data.image) { [weak self] in
      self?.showData(data)
    }
  }

  private func showData(_ data: FavoriteModel) {
    favoriteTitle.text = data.name

    favoriteRelease.text = data.released?.releasedDate()
    favoriteRating.text = data.rating?.ratingFormatted()

    loadingView.stopAnimating()
    loadingView.alpha = 0

    backgroundCover.layer.cornerRadius = 20
    backgroundCover.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
  }
}
