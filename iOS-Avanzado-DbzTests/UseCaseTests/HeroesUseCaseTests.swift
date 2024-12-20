//
//  HeroesUseCaseTests.swift
//  iOS-Avanzado-DbzTests
//
//  Created by Kevin Heredia on 9/11/24.
//


@testable import iOS_Avanzado_Dbz
import XCTest

final class ApiProviderHeroesMock: ApiProviderProtocol {
    func loginWith(username: String, password: String, completion: @escaping (Result<Bool, iOS_Avanzado_Dbz.GAError>) -> Void) {
        //
    }
    
    func loadLocations(id: String, completion: @escaping (Result<[iOS_Avanzado_Dbz.ApiLocation], iOS_Avanzado_Dbz.GAError>) -> Void) {
        //
    }
    
    func loadTransformations(id: String, completion: @escaping (Result<[iOS_Avanzado_Dbz.ApiTransformation], iOS_Avanzado_Dbz.GAError>) -> Void) {
        //
    }
    
    func loadHeroes(name: String, completion: @escaping (Result<[ApiHero], GAError>) -> Void) {
        let heroes = mockApiHeroes()
        completion(.success(heroes))
    }

    func mockApiHeroesData() throws -> Data {
        guard let urlMock = Bundle(for: ApiProviderHeroesMock.self).url(forResource: "Heroes", withExtension: "json"),
              let data = try? Data(contentsOf: urlMock) else {
            throw GAError.dataNoReveiced
        }
        return data
    }

    func mockApiHeroes() -> [ApiHero] {
        guard let data = try? mockApiHeroesData(),
              let heroes = try? JSONDecoder().decode([ApiHero].self, from: data) else {
            return []
        }
        return heroes
    }
}


final class HeroesUseCaseTests: XCTestCase {
    
    var sut: HeroUseCaseProtocol!
    var storeDataProvider: StoreDataProvider!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        storeDataProvider = StoreDataProvider(persistency: .inMemory)
        sut = HeroUseCase(apiProvider: ApiProviderHeroesMock())
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
}

