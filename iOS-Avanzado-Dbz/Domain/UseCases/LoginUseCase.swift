//
//  LoginUseCase.swift
//  iOS-Avanzado-Dbz
//
//  Created by Kevin Heredia on 24/10/24.
//

import Foundation

protocol LoginUseCaseContract {
    func execute(username: String, password: String, completion: @escaping (Result<Bool, GAError>) -> Void)
}

final class LoginUseCase: LoginUseCaseContract {
    
    private var apiProvider: ApiProviderProtocol
    private let secureDataStore: SecureDataStoreProtocol
    
    
    init(secureDataStore: SecureDataStoreProtocol = SecureDataStore(), apiProvider: ApiProviderProtocol = ApiProvider()) {
        self.apiProvider = apiProvider
        self.secureDataStore = secureDataStore
    }
    
    func execute(username: String, password: String, completion: @escaping (Result<Bool, GAError>) -> Void) {

        self.apiProvider.loginWith(username: username, password: password, completion: completion)
    }
    
}
