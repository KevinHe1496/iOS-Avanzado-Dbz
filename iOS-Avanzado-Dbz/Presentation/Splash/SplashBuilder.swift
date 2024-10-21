//
//  SplashBuilder.swift
//  iOS-Avanzado-Dbz
//
//  Created by Kevin Heredia on 20/10/24.
//

import UIKit

final class SplashBuilder {
    func build() -> UIViewController {
        let viewModel = SplashViewModel()
        return SplashViewController(viewModel: viewModel)
    }
}
