//
//  HeroDetailUseCaseProtocol.swift
//  iOS-Avanzado-Dbz
//
//  Created by Kevin Heredia on 25/10/24.
//

import Foundation

protocol HeroDetailUseCaseProtocol {
    func loadLocationsForHero(id: String, completion: @escaping (Result<[Location], GAError>)-> Void)
    
}

class HeroDetailUseCase: HeroDetailUseCaseProtocol {
    
    private var apiProvider: ApiProviderProtocol
    private var storeDataProvider: StoreDataProvider
    
    init(apiProvider: ApiProviderProtocol = ApiProvider(), storeDataProvider: StoreDataProvider = .shared) {
        self.apiProvider = apiProvider
        self.storeDataProvider = storeDataProvider
    }
    
    func loadLocationsForHero(id: String, completion: @escaping (Result<[Location], GAError>) -> Void) {
        guard let hero = self.getHeroWith(id: id) else {
            debugPrint("Hero with id \(id) not found")
            completion(.failure(.heroNotFound(idHero: id)))
            return
        }
        let bdLocations = hero.locations ?? []
        if bdLocations.isEmpty {
            apiProvider.loadLocations(id: id) { [weak self] result in
                switch result{
                    
                case .success(let locations):
                    self?.storeDataProvider.add(locations: locations)
                    let bdLocations = hero.locations ?? []
                    let domainLocations = bdLocations.map({Location(moLocation: $0)})
                    completion(.success(domainLocations))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            let domainLocations = bdLocations.map({Location(moLocation: $0)})
            completion(.success(domainLocations))
        }
        
    }
    
    
    private func getHeroWith(id: String) -> MOHero? {
        let predicate = NSPredicate(format: "id == %@", id)
        let heroes = storeDataProvider.fetchHeroes(filter: predicate)
        return heroes.first
    }
}
