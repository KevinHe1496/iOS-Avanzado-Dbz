//
//  Hero.swift
//  iOS-Avanzado-Dbz
//
//  Created by Kevin Heredia on 22/10/24.
//

import Foundation

struct Hero: Equatable, Decodable, Hashable {
    let identifier: String
    let name: String
    let description: String
    let photo: String
    let favorite: Bool
    
    enum CondingKeys: String, CodingKey{
        case identifier = "id"
        case name
        case description
        case photo
        case favorite
        
    }
}
