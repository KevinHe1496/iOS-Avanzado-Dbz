//
//  HerosViewModelTest.swift
//  iOS-Avanzado-DbzTests
//
//  Created by Kevin Heredia on 23/12/24.
//

import XCTest
@testable import iOS_Avanzado_Dbz

///Success
final class HerosUseCaseMock: HeroUseCaseProtocol {
    func loadHeros(filter: NSPredicate?, completion: @escaping (Result<[iOS_Avanzado_Dbz.Hero], iOS_Avanzado_Dbz.GAError>) -> Void) {
        let heros = try! MockData.mockHeroes().map({Hero(apiHero: $0)})
        completion(.success(heros))
    }
}

///Error
final class HerosUseCaseErrorMock: HeroUseCaseProtocol {
    func loadHeros(filter: NSPredicate?, completion: @escaping (Result<[iOS_Avanzado_Dbz.Hero], iOS_Avanzado_Dbz.GAError>) -> Void) {
        let error = GAError.dataNoReveiced
        completion(.failure(error))
    }
}


final class HerosViewModelTest: XCTestCase {
    
    var sut: HeroesListViewModel!
    var heroesUseCase: HerosUseCaseMock!

    override func setUpWithError() throws {
        try super.setUpWithError()
        heroesUseCase = HerosUseCaseMock()
        sut = HeroesListViewModel(useCase: heroesUseCase)
    }

    override func tearDownWithError() throws {
        heroesUseCase = nil
        sut = nil
        try super.tearDownWithError()
    }
    
    func test_loadData() {
        // Given
        let expectation = expectation(description: "Load Heros")
        sut.statusHeroes.bind { status in
            switch status {
                
            case .dateUpdated:
                expectation.fulfill()
            case .error(_):
                XCTFail("Expected Success")
            case .none:
                break
            }
        }
        
        //When
        sut.loadData()
        
        //Then
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(sut.heroes.count, 15)
    }
    
    func test_loadData_Error() {
        //Given
        sut = HeroesListViewModel(useCase: HerosUseCaseErrorMock())
        let expected = expectation(description: "Load Heros")
        sut.statusHeroes.bind { status in
            switch status {
                
            case .dateUpdated:
                XCTFail("Expected Error")
            case .error(_):
                expected.fulfill()
            case .none:
                break
            }
        }
        
        //When
        sut.loadData()
        
        //Then
        wait(for: [expected], timeout: 5)
        XCTAssertEqual(sut.heroes.count, 0)
    }

    func test_GetHeroAtIndex() throws {
        // Given
        let expectedHero = Hero(id: "D88BE50B-913D-4EA8-AC42-04D3AF1434E3",
                        name: "Krilin",
                        favorite: false,
                        photo: "https://cdn.alfabetajuega.com/alfabetajuega/2020/08/Krilin.jpg?width=300",
                        description: "")
        let expectation = expectation(description: "Load Heros")
        sut.statusHeroes.bind { status in
            switch status {
                
            case .dateUpdated:
                expectation.fulfill()
            case .error(_):
                XCTFail("Expected Success")
            case .none:
                break
            }
        }
        
        //When
        sut.loadData()
        
        //Then
        wait(for: [expectation], timeout: 5)
        let hero = try XCTUnwrap(sut.heroAt(index: 2))
        XCTAssertEqual(hero.id, expectedHero.id)
        XCTAssertEqual(hero.name, expectedHero.name)
        XCTAssertEqual(hero.favorite, expectedHero.favorite)
        XCTAssertEqual(hero.photo, expectedHero.photo)
        
    }

}
