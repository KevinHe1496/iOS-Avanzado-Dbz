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
    
    func test_load_Heroes_shouldReturn_26_Heroes() throws {
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
    
    func setToken(_ token: String) {
        SecureDataStoreMock().set(token: token)
    }

}

class SecureDataStoreMock: SecureDataStoreProtocol {
    
    private let kToken = "kToken"
    private var userDefaults = UserDefaults.standard
    
    func set(token: String) {
        userDefaults.set(token, forKey: kToken)
    }
    
    func getToken() -> String? {
        userDefaults.string(forKey: kToken)
    }
    
    func deleteToken() {
        userDefaults.removeObject(forKey: kToken)
    }
    
    
}
