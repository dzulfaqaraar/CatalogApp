//
//  ProfileDataViewController.swift
//  Catalog
//
//  Created by Dzulfaqar on 28/05/22.
//

import UIKit
import Combine
import Common

class ProfileDataViewController: UIViewController {

  private var viewModel: ProfileViewModel

  init(viewModel: ProfileViewModel) {
    self.viewModel = viewModel
    super.init(
      nibName: String(describing: ProfileDataViewController.self),
      bundle: profileBundle
    )
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  @IBOutlet weak var profileImage: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var websiteLabel: UILabel!

  private var cancellables: Set<AnyCancellable> = []

  var dismissCallback: (() -> Void)?
  var editCallback: (() -> Void)?

  private let navBar: UINavigationBar = {
    let backButton = UIBarButtonItem()
    backButton.image = UIImage(systemName: "chevron.backward")
    backButton.action = #selector(backButtonPressed)

    let editButton = UIBarButtonItem()
    editButton.title = "edit".localized()
    editButton.action = #selector(editButtonPressed)

    let navBar = UINavigationBar()
    let navItem = UINavigationItem(title: "profile_title".localized())
    navItem.leftBarButtonItem = backButton
    navItem.rightBarButtonItem = editButton

    navBar.setItems([navItem], animated: false)
    navBar.translatesAutoresizingMaskIntoConstraints = false
    return navBar
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupSubscriber()

    loadProfile()
  }

  private func setupView() {
    view.addSubview(navBar)
    NSLayoutConstraint.activate([
      navBar.leftAnchor.constraint(equalTo: view.leftAnchor),
      navBar.topAnchor.constraint(equalTo: view.topAnchor),
      navBar.rightAnchor.constraint(equalTo: view.rightAnchor),
      navBar.heightAnchor.constraint(equalToConstant: 44)
    ])

    profileImage.layer.cornerRadius = profileImage.frame.height / 2
  }

  private func setupSubscriber() {
    viewModel.isShowingData.sink { [weak self] status in
      if status {
        self?.showProfileData()
      }
    }
    .store(in: &cancellables)
  }

  func loadProfile() {
    viewModel.loadProfile()
  }

  private func showProfileData() {
    if let profileData = viewModel.profileData {
      if let image = profileData.image {
        profileImage.image = UIImage(data: image)
      }
      nameLabel.text = profileData.name
      websiteLabel.text = profileData.website
    }
  }

  @objc func backButtonPressed() {
    dismissCallback?()
  }

  @objc func editButtonPressed() {
    editCallback?()
  }
}
