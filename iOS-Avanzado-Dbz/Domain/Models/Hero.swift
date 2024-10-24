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
    
    
    init(moHero: MOHero) {
        self.id = moHero.id ?? ""
        self.name = moHero.name ?? ""
        self.info = moHero.info ?? ""
        self.photo = moHero.photo ?? ""
        self.favorite = moHero.favorite
    }
}
