//
//  SplashViewController.swift
//  iOS-Avanzado-Dbz
//
//  Created by Kevin Heredia on 19/10/24.
//

import UIKit

class SplashViewController: UIViewController {
    
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    
    private let viewModel: SplashViewModel
    
    init(viewModel: SplashViewModel){
        self.viewModel = viewModel
        super.init(nibName: String(describing: SplashViewController.self), bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.load()
        bind()
    }
    
    private func bind() {
        viewModel.onStateChanged.bind { [weak self] state in
            switch state {
           
            case .loading:
                self?.setAnimation(true)
            case .error:
                break
            case .success:
                self?.present(LoginBuilder().build(), animated: true)
                self?.setAnimation(false)
            }
        }
    }

    
    private func setAnimation(_ animating: Bool) {
        
        switch spinner.isAnimating {
        case true where !animating:
            spinner.stopAnimating()
        case false where animating:
            spinner.startAnimating()
        default:
            break
        }
    }
    
}
