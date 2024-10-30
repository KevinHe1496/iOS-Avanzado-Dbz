//
//  iOS_Avanzado_DbzTests.swift
//  iOS-Avanzado-DbzTests
//
//  Created by Kevin Heredia on 19/10/24.
//

import XCTest
@testable import iOS_Avanzado_Dbz



final class StoreProviderTests: XCTestCase {
    
    var sut: StoreDataProvider!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = StoreDataProvider(persistency: .inMemory)
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func test_addHeroes_shouldReturnItemsInserted() throws {
        // Given
        let initialCount = sut.fetchHeroes(filter: nil).count
        let apiHero = ApiHero(id: "123", name: "name", description: "description", photo: "photo", favorite: false)
        // When
        sut.add(heroes: [apiHero])
        let heroes = sut.fetchHeroes(filter: nil)
        let finalCount = heroes.count
        // Then
        XCTAssertEqual(finalCount, initialCount + 1)
        let hero = try XCTUnwrap(heroes.first)
        XCTAssertEqual(hero.id, apiHero.id)
        XCTAssertEqual(hero.name, apiHero.name)
        XCTAssertEqual(hero.info, apiHero.description)
        XCTAssertEqual(hero.photo, apiHero.photo)
        XCTAssertEqual(hero.favorite, apiHero.favorite)
        
    }
    
    func test_fetchHeroes_shouldBeSortedAsc() throws {
        // Given
        let initialCount = sut.fetchHeroes(filter: nil).count
        let apiHero = ApiHero(id: "123", name: "Kevin", description: "description", photo: "photo", favorite: false)
        let apiHero2 = ApiHero(id: "1234", name: "Goku", description: "description", photo: "photo", favorite: false)
        //When
        sut.add(heroes: [apiHero, apiHero2])
        let heroes = sut.fetchHeroes(filter: nil)
        //Then
        XCTAssertEqual(initialCount, 0)
        let hero = try XCTUnwrap(heroes.first)
        XCTAssertEqual(hero.id, apiHero2.id)
        XCTAssertEqual(hero.name, apiHero2.name)
        XCTAssertEqual(hero.info, apiHero2.description)
        XCTAssertEqual(hero.photo, apiHero2.photo)
        XCTAssertEqual(hero.favorite, apiHero2.favorite)
        
    }

    func test_addLocations_ShouldInsertLocationAndAssociateHero() throws {
 
        // Given
        
        let apiHero = ApiHero(id: "123", name: "Kevin", description: "description", photo: "photo", favorite: false)
        let apiLocation = ApiLocation(id: "id", date: "date", latitude: "0000", longitude: "1111", hero: apiHero)
        // When
        sut.add(heroes: [apiHero])
        sut.add(locations: [apiLocation])
        let heroes = sut.fetchHeroes(filter: nil)
        
        // Then
        let hero = try XCTUnwrap(heroes.first)
        XCTAssertEqual(hero.locations?.count, 1)
        let location = try XCTUnwrap(hero.locations?.first)
        XCTAssertEqual(location.id, apiLocation.id)
        XCTAssertEqual(location.date, apiLocation.date)
        XCTAssertEqual(location.latitude, apiLocation.latitude)
        XCTAssertEqual(location.longitude, apiLocation.longitude)
        XCTAssertEqual(location.hero?.id, hero.id)
        
    }
   
    
    func test_addTransformations_ShouldInsertTransformationAndAssociateHero() throws {
 
        // Given
        
        let apiHero = ApiHero(id: "123", name: "Kevin", description: "description", photo: "photo", favorite: false)
        let apiTransformation = ApiTransformation(id: "id", name: "sayayin", photo: "photo", description: "description", hero: apiHero)
        // When
        sut.add(heroes: [apiHero])
        sut.add(transformations: [apiTransformation])
        let heroes = sut.fetchHeroes(filter: nil)
        
        // Then
        let hero = try XCTUnwrap(heroes.first)
        XCTAssertEqual(hero.transformations?.count, 1)
        let transformation = try XCTUnwrap(hero.transformations?.first)
        XCTAssertEqual(transformation.id, apiTransformation.id)
        XCTAssertEqual(transformation.name, apiTransformation.name)
        XCTAssertEqual(transformation.photo, apiTransformation.photo)
        XCTAssertEqual(transformation.info, apiTransformation.description)
        XCTAssertEqual(transformation.hero?.id, hero.id)
        
    }
    

}
