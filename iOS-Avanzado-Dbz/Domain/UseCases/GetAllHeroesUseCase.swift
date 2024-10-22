//
//  GetAllHeroesUseCase.swift
//  iOS-Avanzado-Dbz
//
//  Created by Kevin Heredia on 22/10/24.
//

import Foundation

protocol GetAllHeroesUseCaseContract {
    func execute(completion: @escaping (Result<[Hero], Error>) -> Void)
}

final class GetAllHeroesUseCase: GetAllHeroesUseCaseContract{
    func execute(completion: @escaping (Result<[Hero], any Error>) -> Void) {
        GetHeroesAPIRequest(name: "")
            .perform { result in
                do {
                    try completion(.success(result.get()))
                }catch{
                    completion(.failure(error))
                }
            }
    }
    
}


