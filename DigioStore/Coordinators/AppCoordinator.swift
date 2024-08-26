//
//  AppCoordinator.swift
//  DigioStore
//
//  Created by Milton Leslie Sanches on 22/08/24.
//

import UIKit

class AppCoordinator {
    var navigationController: UINavigationController
    var digioStoreViewModel: DigioStoreViewModel

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.digioStoreViewModel = DigioStoreViewModel()
    }

    func start() {
        let viewController = ViewController(viewModel: digioStoreViewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
