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
            throw GAError.dataNoReveiced
        }
        

        return data
    }
    
    static func mockHeroes() throws -> [ApiHero] {
        guard let data = try? self.loadHeroesData(),
              let heroes = try? JSONDecoder().decode([ApiHero].self, from: data) else {
            return []
        }
            return heroes

    }
    
    
    static func loadLocationsData() throws -> Data {
        let bundle = Bundle(for: MockData.self)
        guard let url = bundle.url(forResource: "Locations", withExtension: "json"),
              
              let data = try? Data.init(contentsOf: url) else {
            throw NSError(domain: "io.keepcoding.iOS-Avanzado-Dbz", code: -1)
        }
        

        return data
    }
    
    static func mockLocations() throws -> [ApiLocation] {
        
            guard let data = try? self.loadLocationsData(),
                  let locations = try? JSONDecoder().decode([ApiLocation].self, from: data) else {
                return []
            }
            return locations
    }
    
    
    static func loadTransformationsData() throws -> Data {
        let bundle = Bundle(for: MockData.self)
        guard let url = bundle.url(forResource: "Transformations", withExtension: "json"),
              
              let data = try? Data.init(contentsOf: url) else {
            throw NSError(domain: "io.keepcoding.iOS-Avanzado-Dbz", code: -1)
        }
        

        return data
    }
    
    static func mockTransformation() throws -> [ApiTransformation] {
       
        guard let data = try? self.loadTransformationsData(),
              let transformations = try? JSONDecoder().decode([ApiTransformation].self, from: data) else {
            return []
        }
            return transformations
     
    }
    
    static func apiHeroGoku() throws -> ApiHero {
        guard let goku = try self.mockHeroes().first(where: {$0.id == "D13A40E5-4418-4223-9CE6-D2F9A28EBE94"}) else {
            throw GAError.dataNoReveiced
        }
        return goku
    }
    
    
}
