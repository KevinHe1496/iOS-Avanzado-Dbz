//
//  HeroesUseCaseTests.swift
//  iOS-Avanzado-DbzTests
//
//  Created by Kevin Heredia on 9/11/24.
//


@testable import iOS_Avanzado_Dbz
import XCTest

final class HeroesUseCaseTests: XCTestCase {
    
    var sut: HeroUseCaseProtocol!
    var storeDataProvider: StoreDataProvider!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        storeDataProvider = StoreDataProvider(persistency: .inMemory)
        sut = HeroUseCase(apiProvider: ApiProviderMock(), storeDataProvider: StoreDataProvider())
    }
    
    override func tearDownWithError() throws {
        storeDataProvider = nil
        sut = nil
        try super.tearDownWithError()

    }
    
    func test_getAllHeroes() throws {
        
        var heroesResponse: [Hero] = []
        
        let expectation = expectation(description: "Load Heroes")
        sut.loadHeros(filter: nil) { result in
            switch result {
                
            case .success(let heroes):
                heroesResponse = heroes
                expectation.fulfill()
            case .failure(_):
                XCTFail("Expected success")
            }
        }
        
        waitForExpectations(timeout: 5)
        XCTAssertEqual(heroesResponse.count, 15)
    }
    
    func test_getAllHeros_Error() throws {
        // given
        sut = HeroUseCase(apiProvider: ApiProviderErrorMock(), storeDataProvider: storeDataProvider)
        var errorHeros: GAError?
        
        //When
        let expectation = expectation(description: "Get Heros")
        sut.loadHeros(filter: nil) { result in
            switch result {
                
            case .success(_):
                XCTFail("Expected error")
            case .failure(let error):
                errorHeros = error
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5)
        
        XCTAssertEqual(errorHeros?.description, "Data no received from server")
    }
}

