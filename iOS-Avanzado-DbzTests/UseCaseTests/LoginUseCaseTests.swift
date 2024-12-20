//
//  LoginUseCaseTests.swift
//  iOS-Avanzado-DbzTests
//
//  Created by Kevin Heredia on 12/11/24.
//

import XCTest
@testable import iOS_Avanzado_Dbz

final class ApiProviderLoginMock {
    
}

final class LoginUseCaseTests: XCTestCase {
    
    var sut: LoginUseCaseContract!
    var apiProviderMock: ApiProviderProtocol!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        apiProviderMock = ApiProvider()
        sut = LoginUseCase(apiProvider: apiProviderMock)
        
    }
    
    override func tearDownWithError() throws {
        sut = nil
        apiProviderMock = nil
        try super.tearDownWithError()
    }
    
    func test_loginSuccess() async {
        //When
        let userName = "kevin_heredia10@hotmail.com"
        let password = "123456"
        var success: Bool?
        
        //When
        let expectation = expectation(description: "Login Success")
        sut.execute(username: userName, password: password) { result in
            switch result {
                
            case .success(let successReponse):
                success = successReponse
                expectation.fulfill()
            case .failure(_):
                XCTFail("Expected Sucess")
            }
        }
        //Then
        await fulfillment(of: [expectation], timeout: 5)
//        wait(for: [expectation], timeout: 0.1)
        XCTAssertEqual(success, true)
    }
}
