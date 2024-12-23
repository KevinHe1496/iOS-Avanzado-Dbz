//
//  LoginViewModelTest.swift
//  iOS-Avanzado-DbzTests
//
//  Created by Kevin Heredia on 23/12/24.
//

import XCTest
@testable import iOS_Avanzado_Dbz


///Mock Success
final class LoginUseCaseMock: LoginUseCaseContract {
    func execute(username: String, password: String, completion: @escaping (Result<Bool, iOS_Avanzado_Dbz.GAError>) -> Void) {
        completion(.success(true))
    }
}

///Mock Error
final class LoginUseCaseErrorMock: LoginUseCaseContract {
    func execute(username: String, password: String, completion: @escaping (Result<Bool, iOS_Avanzado_Dbz.GAError>) -> Void) {
        completion(.failure(GAError.dataNoReveiced))
    }
}

final class LoginViewModelTest: XCTestCase {
    
    var sut: LoginViewModel!

    override func setUpWithError() throws {
        sut = LoginViewModel(loginUseCase: LoginUseCaseMock())
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
    
    /// Login Success
    func test_login_Success() {
        //Given
        let username = "username"
        let password = "password"
        var loginSuccess = false
        let expectation = expectation(description: "Login Success")
        sut.onStateChaged.bind { status in
            switch status {
                
            case .loading:
                break
            case .success:
                loginSuccess = true
                expectation.fulfill()
            case .error(_):
                XCTFail("Expected Success")
            case .none:
                break
            }
        }
        
        //When
        sut.login(username: username, password: password)
        
        //Then
        wait(for: [expectation], timeout: 5)
        XCTAssertTrue(loginSuccess)
    }
    
    /// Login Error
    func test_login_error() {
        //Given
        sut = LoginViewModel(loginUseCase: LoginUseCaseErrorMock())
        let username = "username"
        let password = "password"
        var error: String?
        
        let expectation = expectation(description: "Login Success")
        sut.onStateChaged.bind { status in
            switch status {
                
            case .loading:
                break
            case .success:
                XCTFail("Expected Error")
            case .error(reason: let reason):
                error = reason
                expectation.fulfill()
            case .none:
                break
            }
        }
        //When
        sut.login(username: username, password: password)
        
        //Then
        wait(for: [expectation], timeout: 5)
        XCTAssertNotNil(error)
    }
    
    func test_validateUser() {

        //When
       var (result,msg) = sut.signIn(userName: "username", password: "pas")
        //Then
        XCTAssertEqual(result, false)
        XCTAssertEqual(msg, "Usario no correcto")
        
        //When
        (result,msg) = sut.signIn(userName: "username@", password: nil)
        //Then
        XCTAssertEqual(result, false)
        XCTAssertEqual(msg, "Password no correcto")
        
        
        //When
        (result,msg) = sut.signIn(userName: nil, password: "password")
        //Then
        XCTAssertEqual(result, false)
        XCTAssertEqual(msg, "Usario no correcto")
        
        //When
        (result,msg) = sut.signIn(userName: "username@", password: "password")
        //Then
        XCTAssertEqual(result, true)
        XCTAssertEqual(msg, "")
        
        
    }

}
