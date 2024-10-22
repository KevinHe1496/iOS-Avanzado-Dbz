//
//  LoginUseCase.swift
//  iOS-Avanzado-Dbz
//
//  Created by Kevin Heredia on 21/10/24.
//

import Foundation


protocol LoginUseCaseContract {
    func execute(credentials: Credentials, completion: @escaping (Result<Void, LoginUseCaseError>) -> Void)
}

final class LoginUseCase: LoginUseCaseContract {
    
    private let dataSource: SessionDataSourceContract
    
    init(dataSource: SessionDataSourceContract = SessionDataSource()) {
        self.dataSource = dataSource
    }
    
    func execute(credentials: Credentials, completion: @escaping (Result<Void, LoginUseCaseError>) -> Void) {
        
        
        guard validateUserName(credentials.userName) else {
            return completion(.failure(LoginUseCaseError(reason: "Invalid Username")))
        }
        
        guard validatePassword(credentials.password) else {
            return completion(.failure(LoginUseCaseError(reason: "Invalid Password")))
        }
        
        LoginAPIRequest(credentials: credentials)
            .perform { [weak self] result in
                switch result {
                    
                case .success(let token):
                    self?.dataSource.storeSession(token)
                    completion(.success(()))
                case .failure(_):
                    completion(.failure(LoginUseCaseError(reason: "Network failed")))
                }
            }
    }
    
    private func validateUserName(_ userName: String) -> Bool {
        userName.contains("@") && !userName.isEmpty
    }
    
    private func validatePassword(_ password: String) -> Bool {
        password.count >= 5
    }

}

// MARK: LoginUseCase Error

struct LoginUseCaseError: Error {
    let reason: String
}
