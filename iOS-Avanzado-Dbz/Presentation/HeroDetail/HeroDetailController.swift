//
//  HeroDetailController.swift
//  iOS-Avanzado-Dbz
//
//  Created by Kevin Heredia on 25/10/24.
//

import UIKit



class HeroDetailViewModel {
    
    private var useCase: HeroUseCaseProtocol
    
    init(useCase: HeroUseCaseProtocol = HeroUseCase()) {
        self.useCase = useCase
    }
    
}

class HeroDetailController: UIViewController {
    
    private let viewModel: HeroDetailViewModel
    
    init(viewModel: HeroDetailViewModel = HeroDetailViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: HeroDetailController.self), bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

     
    }




}
