//
//  HeroesListViewModel.swift
//  iOS-Avanzado-Dbz
//
//  Created by Kevin Heredia on 22/10/24.
//

import Foundation

enum HeroesListState{
    case dateUpdated
    case error(_ reason: String)
    case none
}

final class HeroesListViewModel {
 
    
    private let useCase: HeroUseCaseProtocol
    var statusHeroes: Binding<HeroesListState> = Binding(.none)
    var heroes: [Hero] = []
    
    init(useCase: HeroUseCaseProtocol = HeroUseCase()) {
        self.useCase = useCase
    }
    
    func loadData(filter: String? = nil) {
        var predicate: NSPredicate?
        if let filter {
            predicate = NSPredicate(format: "name CONTAINS[cd] %@", filter)
        }
        
        useCase.loadHeros(filter: predicate) { [weak self] result in
            switch result{
                
            case .success(let heros):
                self?.heroes = heros
                self?.statusHeroes.value = .dateUpdated
            case .failure(let error):
                self?.statusHeroes.value = .error(error.description)
            }
            
        }
    }
    
    func heroAt(index: Int) -> Hero? {
        guard index < heroes.count else {
            return nil
        }
        return heroes[index]
    }
    
}
