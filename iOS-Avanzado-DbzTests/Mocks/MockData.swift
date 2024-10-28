//
//  MockData.swift
//  iOS-Avanzado-DbzTests
//
//  Created by Kevin Heredia on 26/10/24.
//

import Foundation
@testable import iOS_Avanzado_Dbz

class MockData {
    static func loadHeroesData() throws -> Data {
        let bundle = Bundle(for: MockData.self)
        guard let url = bundle.url(forResource: "Heroes", withExtension: "json"),
              
              let data = try? Data.init(contentsOf: url) else {
            throw NSError(domain: "io.keepcoding.iOS-Avanzado-Dbz", code: -1)
        }
        

        return data
    }
    
    static func mockHeroes() throws -> [ApiHero] {
        do {
            let data = try self.loadHeroesData()
            let heroes = try JSONDecoder().decode([ApiHero].self, from: data)
            return heroes
        } catch {
            throw error
        }
    }
}
