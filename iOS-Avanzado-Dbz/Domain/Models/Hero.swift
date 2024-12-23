//
//  Hero.swift
//  iOS-Avanzado-Dbz
//
//  Created by Kevin Heredia on 22/10/24.
//

import Foundation

struct Hero: Equatable, Decodable, Hashable {
    let id: String
    let name: String
    let info: String
    let photo: String
    let favorite: Bool
    
    init(id: String, name: String? = nil, favorite: Bool? = nil, photo: String? = nil, description: String? = nil) {
        self.id = id
        self.name = name ?? ""
        self.favorite = favorite ?? false
        self.photo = photo ?? ""
        self.info = description ?? ""
    }
    
    
    init(moHero: MOHero) {
        self.id = moHero.id ?? ""
        self.name = moHero.name ?? ""
        self.info = moHero.info ?? ""
        self.photo = moHero.photo ?? ""
        self.favorite = moHero.favorite
    }
    
    init(apiHero: ApiHero) {
        self.id = apiHero.id
        self.name = apiHero.name ?? ""
        self.favorite = apiHero.favorite ?? false
        self.photo = apiHero.photo ?? ""
        self.info = apiHero.description ?? ""
    }
}
