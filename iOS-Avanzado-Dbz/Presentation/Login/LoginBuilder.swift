//
//  LoginBuilder.swift
//  iOS-Avanzado-Dbz
//
//  Created by Kevin Heredia on 20/10/24.
//

import UIKit

final class LoginBuilder {
    func build() -> UIViewController {
        let useCase = LoginUseCase()
        let viewModel = LoginViewModel(useCase: useCase)
        let viewController = LoginViewController(viewModel: viewModel)
        viewController.modalPresentationStyle = .fullScreen
        return viewController
    }
}
