//
//  Transformation.swift
//  iOS-Avanzado-Dbz
//
//  Created by Kevin Heredia on 27/10/24.
//

import Foundation

struct HeroTransformation: Hashable {
    let id: String
    let name: String
    let photo: String
    let info: String
    
    init(moTransformation: MOTransformation) {
        self.id = moTransformation.id ?? ""
        self.name = moTransformation.name ?? ""
        self.photo = moTransformation.photo ?? ""
        self.info = moTransformation.info ?? ""
    }
}
