//
//  HeroDetailViewModelTest.swift
//  iOS-Avanzado-DbzTests
//
//  Created by Kevin Heredia on 23/12/24.
//

import XCTest
@testable import iOS_Avanzado_Dbz

final class HeroDetailUseCaseMock: HeroDetailUseCaseProtocol {
    func loadLocationsForHero(id: String, completion: @escaping (Result<[HeroLocation], GAError>) -> Void) {
        do {
            let apiLocations = try MockData.mockLocations()
            completion(.success(apiLocations.map({$0.mapToHeroLocation()})))
        } catch {
            print("Hubo un error en locations \(error.localizedDescription)")
        }
    }
    
    func loadTransformationsForHero(id: String, completion: @escaping (Result<[iOS_Avanzado_Dbz.HeroTransformation], iOS_Avanzado_Dbz.GAError>) -> Void) {
        do {
            let apiTransformations = try MockData.mockTransformation()
            completion(.success(apiTransformations.map({$0.mapToHeroTransformation()})))
        } catch {
            print("Hubo un error en transformaciones \(error.localizedDescription)")
        }
    }
}


final class HeroDetailUseCaseErrorMock: HeroDetailUseCaseProtocol {
    func loadLocationsForHero(id: String, completion: @escaping (Result<[iOS_Avanzado_Dbz.HeroLocation], iOS_Avanzado_Dbz.GAError>) -> Void) {
        completion(.failure(.dataNoReveiced))
    }
    
    func loadTransformationsForHero(id: String, completion: @escaping (Result<[iOS_Avanzado_Dbz.HeroTransformation], iOS_Avanzado_Dbz.GAError>) -> Void) {
        completion(.failure(.dataNoReveiced))
    }
}

final class HeroDetailViewModelTest: XCTestCase {
    
    var sut: HeroDetailViewModel!
    var heroDetailUseCase: HeroDetailUseCaseProtocol!
    var hero: Hero!

    override func setUpWithError() throws {
        try super.setUpWithError()
        heroDetailUseCase = HeroDetailUseCaseMock()
        hero = try Hero(apiHero: MockData.apiHeroGoku())
        sut = HeroDetailViewModel(useCase: heroDetailUseCase, hero: hero)
    }

    override func tearDownWithError() throws {
        hero = nil
        heroDetailUseCase = nil
        sut = nil
        try super.tearDownWithError()
    }
    
    func test_loadLocations() {
        // Given
        let expectation = expectation(description: "Load Locations")
        var didFulfill = false
        
        sut.status.bind { status in
            guard !didFulfill else { return }
            switch status {
            case .loading:
                break
            case .locationUpdated:
                didFulfill = true
                expectation.fulfill()
            case .error(_):
                XCTFail("Expected Success")
            case .none:
                break
            }
        }
        // When
        sut.loadData()
        
        // Then
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(sut.annotations.count, 2)
    }

    func test_loadLocations_Error() {
        //Given
        sut = HeroDetailViewModel(useCase: HeroDetailUseCaseErrorMock(), hero: hero)
        var error: String?
        var didFulfill = false
        
        let expectation = expectation(description: "Load Locations Error")
        sut.status.bind { status in
            guard !didFulfill else { return }
            switch status {
                
            case .loading:
                break
            case .locationUpdated:
                XCTFail("Expected Error")
            case .error(let msg):
                didFulfill = true
                error = msg
                expectation.fulfill()
            case .none:
                break
            }
        }
        //When
        sut.loadData()
        
        //Then
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(error, "Data no received from server")
        
    }
    
    //TODO: Arreglar este test
    
    
    func test_loadData_Transformations() {
        //Given
        var transformations: [HeroTransformation]?
        let expectation = expectation(description: "Load Transformations")
        var didFulfill = false
        
        sut.status.bind { status in
            guard !didFulfill else { return }
            switch status {
                
            case .loading:
                break
            case .locationUpdated:
                didFulfill = true
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
        XCTAssertEqual(transformations?.count, nil)
    }
    
    func test_loadData_TransformationsError() {
        // Given
        sut = HeroDetailViewModel(useCase: HeroDetailUseCaseErrorMock(), hero: hero)
        var errorMsg: String?
        var didFulfill = false
        
        let expectation = expectation(description: "Load Transformations Error")
        
        sut.status.bind { status in
            guard !didFulfill else { return }
            switch status {
                
            case .loading:
                break
            case .locationUpdated:
                XCTFail("Expected Error")
            case .error(let msg):
                didFulfill = true
                errorMsg = msg
                expectation.fulfill()
            case .none:
                break
            }
        }
        
        //When
        sut.loadData()
        
        //Then
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(errorMsg, "Data no received from server")
    }
}


extension ApiLocation {
    func mapToHeroLocation() -> HeroLocation {
        return HeroLocation(id: self.id ?? "",
                            latitude: self.latitude ?? "",
                            longitude: self.longitude ?? "",
                            date: self.date ?? "")
    }
}
                            
extension ApiTransformation {
    func mapToHeroTransformation() -> HeroTransformation {
        return HeroTransformation(id: self.id ?? "",
                                  name: self.name ?? "",
                                  photo: self.photo,
                                  description: self.description)
    }
}
