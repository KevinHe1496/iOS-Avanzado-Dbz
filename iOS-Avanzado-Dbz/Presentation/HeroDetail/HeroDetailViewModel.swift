//
//  HeroDetailViewModel.swift
//  iOS-Avanzado-Dbz
//
//  Created by Kevin Heredia on 26/10/24.
//
import Foundation

enum StatusHeroDetail {
    case loading
    case locationUpdated
    case error(_ reason: String)
    case none
}

class HeroDetailViewModel {
    
    let hero: Hero
    private var heroLocations: [HeroLocation] = []
    var heroTransformations: [Transformation] = []
    private var useCase: HeroDetailUseCaseProtocol
    var status: Binding<StatusHeroDetail> = Binding(.none)
    
    
    var annotations: [HeroAnnotation] = []
    
    init(useCase: HeroDetailUseCaseProtocol = HeroDetailUseCase(), hero: Hero) {
        self.useCase = useCase
        self.hero = hero
    }
    
    func loadData() {
        status.value = .loading
        loadLocations()
        loadTransformations()
        
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
    
    private func loadTransformations() {
        useCase.loadTransformationsForHero(id: hero.id) { [weak self] result in
            
            switch result {
                
            case .success(let transformations):
                self?.heroTransformations = transformations
                self?.status.value = .locationUpdated
            case .failure(let error):
                self?.status.value = .error(error.description)
            }
        }
    }
    
    private func createAnnotations() {
        self.annotations = []
        heroLocations.forEach { [weak self] location in
            guard let coordinate = location.coordinate else {
                return
            }
            let annotation = HeroAnnotation(title: self?.hero.name, coordinate: coordinate)
            self?.annotations.append(annotation)
        }
        self.status.value = .locationUpdated
    }
    
    func TransformationAt(index: Int) -> Transformation? {
        guard index < heroTransformations.count else {
            return nil
        }
        return heroTransformations[index]
    }
}
