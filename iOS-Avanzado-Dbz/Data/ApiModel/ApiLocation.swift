//
//  ApiLocation.swift
//  iOS-Avanzado-Dbz
//
//  Created by Kevin Heredia on 23/10/24.
//

import Foundation

struct ApiLocation: Codable {
    let id: String?
    let date: String?
    let latitude: String?
    let longitude: String?
    let hero: ApiHero?
    
    enum CodingKeys: String, CodingKey {
        case id
        case date = "dateShow"
        case latitude = "latitud"
        case longitude = "longitud"
        case hero
    }
}
