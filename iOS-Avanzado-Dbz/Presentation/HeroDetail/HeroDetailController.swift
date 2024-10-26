//
//  HeroDetailController.swift
//  iOS-Avanzado-Dbz
//
//  Created by Kevin Heredia on 25/10/24.
//

import UIKit

enum StatusHeroDetail {
    case locationUpdated
    case error(_ reason: String)
    case none
}

class HeroDetailViewModel {
    
    private let hero: Hero
    private var heroLocations: [Location] = []
    private var useCase: HeroDetailUseCaseProtocol
    var status: Binding<StatusHeroDetail> = Binding(.none)
    
    init(useCase: HeroDetailUseCaseProtocol = HeroDetailUseCase(), hero: Hero) {
        self.useCase = useCase
        self.hero = hero
    }
    
    func loadData() {
        loadLocations()
    }
    
    private func loadLocations() {
        useCase.loadLocationsForHero(id: hero.id) { [weak self] result in
            switch result {
                
            case .success(let locations):
                self?.heroLocations = locations
                self?.createAnnotations()
            case .failure(let error):
                self?.status.value = .error(error.description)
            }
        }
    }
    private func createAnnotations() {
        
        self.status.value = .locationUpdated
    }
}

class HeroDetailController: UIViewController {
    
    private let viewModel: HeroDetailViewModel
    
    init(viewModel: HeroDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: HeroDetailController.self), bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadData()
     
    }




}
