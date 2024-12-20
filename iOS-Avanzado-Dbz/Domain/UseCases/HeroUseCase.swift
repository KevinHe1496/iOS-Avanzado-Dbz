    //
    //  HeroUseCaseProtocol.swift
    //  iOS-Avanzado-Dbz
    //
    //  Created by Kevin Heredia on 24/10/24.
    //
    import Foundation

    protocol HeroUseCaseProtocol {
        func loadHeros(filter: NSPredicate?, completion: @escaping (Result<[Hero], GAError>) -> Void)
    }

    final class HeroUseCase: HeroUseCaseProtocol {
        private var apiProvider: ApiProviderProtocol
        private var storeDataProvider: StoreDataProvider
        
        init(apiProvider: ApiProviderProtocol = ApiProvider(), storeDataProvider: StoreDataProvider = .shared) {
            self.apiProvider = apiProvider
            self.storeDataProvider = storeDataProvider
        }
        
        func loadHeros(filter: NSPredicate? = nil, completion: @escaping (Result<[Hero], GAError>) -> Void) {
            
            let localHeroes = storeDataProvider.fetchHeroes(filter: filter)
            
            if localHeroes.isEmpty {
                apiProvider.loadHeroes(name: "") { [weak self] result in
                    switch result {
                        
                    case .success(let heroes):
                        DispatchQueue.main.async {
                            self?.storeDataProvider.add(heroes: heroes)
                            let bdHeroes = self?.storeDataProvider.fetchHeroes(filter: filter) ?? []
                            let heroes = bdHeroes.map({Hero(moHero: $0)})
                            completion(.success(heroes))
                        }
                        
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
                
            } else {
                let heroes = localHeroes.map { moHero in
                    Hero(moHero: moHero)
                }
                completion(.success(heroes))
            }
            
        }
    }
