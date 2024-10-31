//
//  ApiProviderTests.swift
//  iOS-Avanzado-DbzTests
//
//  Created by Kevin Heredia on 26/10/24.
//

import XCTest
@testable import iOS_Avanzado_Dbz

class ApiProviderTests: XCTestCase {
    
    var sut: ApiProvider!

    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolMock.self]
        let session = URLSession(configuration: configuration)
        let requestProvider = GARequestBuilder(secureStorage: SecureDataStoreMock())
        sut = ApiProvider(session: session, requestBuilder: requestProvider)
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        SecureDataStoreMock().deleteToken()
        URLProtocolMock.handler = nil
        URLProtocolMock.error = nil
        sut = nil
        try super.tearDownWithError()
    }
    
    func test_load_Heroes_shouldReturn_15_Heroes() throws {
        // Given
        let expectedToken = "Some Token"
        let expectedHero = try MockData.mockHeroes().first!
        var heroesResponse = [ApiHero]()
        URLProtocolMock.handler = { request in
            let expectedUrl = try XCTUnwrap(URL(string: "https://dragonball.keepcoding.education/api/heros/all"))
            
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(request.url?.absoluteString, expectedUrl.absoluteString)
            XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Bearer \(expectedToken)")
            
            let data = try MockData.loadHeroesData()
            let response = HTTPURLResponse(url: expectedUrl, statusCode: 200, httpVersion: nil, headerFields: nil)!
            
            return (data, response)
        }
        // When
        let expectation = expectation(description: "Load Heroes")
        setToken(expectedToken)
        sut.loadHeroes { result in
            switch result {
                
            case .success(let apiHeroes):
                heroesResponse = apiHeroes
                expectation.fulfill()
            case .failure(_):
                XCTFail("Success expected")
            }
        }
        // Then
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(heroesResponse.count, 15)
        let heroReceived = heroesResponse.first
        XCTAssertEqual(heroReceived?.id, expectedHero.id)
        XCTAssertEqual(heroReceived?.name, expectedHero.name)
        XCTAssertEqual(heroReceived?.description, expectedHero.description)
        XCTAssertEqual(heroReceived?.favorite, expectedHero.favorite)
        XCTAssertEqual(heroReceived?.photo, expectedHero.photo)
        
    }
    
    func test_load_HeroesError_shouldReturn_Error() throws {
        // Given
        let expectedToken = "Some Token"
        var error: GAError?
        URLProtocolMock.error = NSError(domain: "ios.Keepcoding", code: 503)
        // When
        let expectation = expectation(description: "Load Heroes Error")
        setToken(expectedToken)
        sut.loadHeroes { result in
            switch result {
                
            case .success(_):
                
                XCTFail("Error expected")
            case .failure(let receivedError):
                error = receivedError
                expectation.fulfill()
            }
        }
        // Then
        wait(for: [expectation], timeout: 1)
        let receivedError = try XCTUnwrap(error)
        XCTAssertEqual(receivedError.description, "Received error from server \(503)")
        
    }
    
    func test_load_Locations_shouldReturn_2_Locations() throws {
        // Given
        let expectedToken = "Some Token"
        let id = "D88BE50B-913D-4EA8-AC42-04D3AF1434E3"
        let expectedLocation = try MockData.mockLocations().first!
        var locationResponse = [ApiLocation]()
        URLProtocolMock.handler = { request in
            let expectedUrl = try XCTUnwrap(URL(string: "https://dragonball.keepcoding.education/api/heros/locations"))
            
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(request.url?.absoluteString, expectedUrl.absoluteString)
            XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Bearer \(expectedToken)")
            
            let data = try MockData.loadLocationsData()
            let response = HTTPURLResponse(url: expectedUrl, statusCode: 200, httpVersion: nil, headerFields: nil)!
            
            return (data, response)
        }
        // When
        let expectation = expectation(description: "Load Transformations")
        setToken(expectedToken)
        
        sut.loadLocations(id: id) { result in
            switch result {
                
            case .success(let apiLocations):
                locationResponse = apiLocations
                expectation.fulfill()
            case .failure(_):
                XCTFail("Success Expected")
            }
        }

        // Then
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(locationResponse.count, 2)
        let locationReceived = locationResponse.first
        XCTAssertEqual(locationReceived?.id, expectedLocation.id)
        XCTAssertEqual(locationReceived?.latitude, expectedLocation.latitude)
        XCTAssertEqual(locationReceived?.longitude, expectedLocation.longitude)
        XCTAssertEqual(locationReceived?.date, expectedLocation.date)
        XCTAssertEqual(locationReceived?.hero?.id, expectedLocation.hero?.id)
        
    }
    
    func test_load_LocationsError_shouldReturn_Error() throws {
        // Given
        let expectedToken = "Some Token"
        var error: GAError?
        URLProtocolMock.error = NSError(domain: "ios.Keepcoding", code: 503)
        // When
        let expectation = expectation(description: "Load Heroes Error")
        setToken(expectedToken)
        
        sut.loadLocations(id: "") { result in
            switch result {
                
            case .success(_):
                XCTFail("Error expected")
            case .failure(let receivedError):
                error = receivedError
                expectation.fulfill()
            }
        }
        
        // Then
        wait(for: [expectation], timeout: 1)
        let receivedError = try XCTUnwrap(error)
        XCTAssertEqual(receivedError.description, "Received error from server \(503)")
        
    }
    
    
    func test_load_Transformations_shouldReturn_2_Tranformations() throws {
        // Given
        let expectedToken = "Some Token"
        let id = "D88BE50B-913D-4EA8-AC42-04D3AF1434E3"
        let expectedTransformation = try MockData.mockTransformation().first!
        var transformationResponse = [ApiTransformation]()
        URLProtocolMock.handler = { request in
            let expectedUrl = try XCTUnwrap(URL(string: "https://dragonball.keepcoding.education/api/heros/tranformations"))
            
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(request.url?.absoluteString, expectedUrl.absoluteString)
            XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Bearer \(expectedToken)")
            
            let data = try MockData.loadTransformationsData()
            let response = HTTPURLResponse(url: expectedUrl, statusCode: 200, httpVersion: nil, headerFields: nil)!
            
            return (data, response)
        }
        // When
        let expectation = expectation(description: "Load Transformations")
        setToken(expectedToken)
        
        sut.loadTransformations(id: id) { result in
            switch result {
                
            case .success(let apiTransformations):
                transformationResponse = apiTransformations
                expectation.fulfill()
            case .failure(_):
                XCTFail("Success Expected")
            }
        }

        // Then
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(transformationResponse.count, 2)
        let transformationReceived = transformationResponse.first
        XCTAssertEqual(transformationReceived?.id, expectedTransformation.id)
        XCTAssertEqual(transformationReceived?.name, expectedTransformation.name)
        XCTAssertEqual(transformationReceived?.description, expectedTransformation.description)
        XCTAssertEqual(transformationReceived?.photo, expectedTransformation.photo)
        
    }
    
    
    func test_load_TransformationsError_shouldReturn_Error() throws {
        // Given
        let expectedToken = "Some Token"
        var error: GAError?
        URLProtocolMock.error = NSError(domain: "ios.Keepcoding", code: 503)
        // When
        let expectation = expectation(description: "Load Heroes Error")
        setToken(expectedToken)
        
        sut.loadTransformations(id: "") { result in
            switch result {
                
            case .success(_):
                XCTFail("Error expected")
            case .failure(let receivedError):
                error = receivedError
                expectation.fulfill()
            }
        }
        
        // Then
        wait(for: [expectation], timeout: 1)
        let receivedError = try XCTUnwrap(error)
        XCTAssertEqual(receivedError.description, "Received error from server \(503)")
        
    }
    
    
    func setToken(_ token: String) {
        SecureDataStoreMock().set(token: token)
    }

}


