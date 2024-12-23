//
//  HeroDetailUseCaseTests.swift
//  iOS-Avanzado-DbzTests
//
//  Created by Kevin Heredia on 23/12/24.
//

import XCTest
@testable import iOS_Avanzado_Dbz

final class HeroDetailUseCaseTests: XCTestCase {
 
    var sut: HeroDetailUseCaseProtocol!
    var storeDataProvider: StoreDataProvider!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        storeDataProvider = StoreDataProvider(persistency: .inMemory)
        sut = HeroDetailUseCase(apiProvider: ApiProviderMock(), storeDataProvider: storeDataProvider)
    }
    
    override func tearDownWithError() throws {
        storeDataProvider = nil
        sut = nil
        try super.tearDownWithError()
    }
    
    func test_loadLocationsForHeroId() throws {
        //Given
        let hero = try XCTUnwrap(MockData.apiHeroGoku())
        storeDataProvider.add(heroes: [hero])
        let bdHeros = storeDataProvider.fetchHeroes(filter: nil)
        XCTAssertEqual(bdHeros.count, 1)
        XCTAssertEqual(bdHeros.first?.locations?.count, 0)
        var locationsResponse: [HeroLocation]?
        
        //When
        let expectation = expectation(description: "Load Locations")
        sut.loadLocationsForHero(id: hero.id) { result in
            switch result {
                
            case .success(let response):
                locationsResponse = response
                expectation.fulfill()
            case .failure(_):
                XCTFail("Expected Success")
            }
        }
        waitForExpectations(timeout: 5)
        
        //Then
        XCTAssertEqual(locationsResponse?.count, 2)
        XCTAssertEqual(bdHeros.first?.locations?.count, 2)
    }
    
    func test_loadLocationsForHero_Error() throws {
        // Given
        sut = HeroDetailUseCase(apiProvider: ApiProviderErrorMock(), storeDataProvider: storeDataProvider)
        let hero = try XCTUnwrap(MockData.apiHeroGoku())
        var error: Error?
        
        //When
        let expectation = expectation(description: "Error loading Locations")
        sut.loadLocationsForHero(id: hero.id) { result in
            expectation.fulfill()
            
            switch result {
            case .success(let data):
                XCTFail("Expected Error")
            case .failure(let errorResponse):
                error = errorResponse
            }
        }
        waitForExpectations(timeout: 5)
        
        //Then
        XCTAssertNotNil(error)
    }
}
