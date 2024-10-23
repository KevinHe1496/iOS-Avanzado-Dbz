//
//  HeroesListBuilder.swift
//  iOS-Avanzado-Dbz
//
//  Created by Kevin Heredia on 22/10/24.
//

import UIKit

final class HeroesListBuilder {
    func build() -> UIViewController {
        let viewModel = HeroesListViewModel()
        let viewController = HeroesListViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        return navigationController
    }
}
