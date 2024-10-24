//
//  ApiHero.swift
//  iOS-Avanzado-Dbz
//
//  Created by Kevin Heredia on 23/10/24.
//

import Foundation

struct ApiHero: Codable {
    let id: String?
    let name: String?
    let description: String?
    let photo: String?
    var favorite: Bool = false
}
