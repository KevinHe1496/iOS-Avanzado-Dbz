//
//  ApiTransformation.swift
//  iOS-Avanzado-Dbz
//
//  Created by Kevin Heredia on 23/10/24.
//

import Foundation

struct ApiTransformation: Codable {
    let id: String?
    let name: String?
    let photo: String?
    let description: String?
    let hero: ApiHero?
}
