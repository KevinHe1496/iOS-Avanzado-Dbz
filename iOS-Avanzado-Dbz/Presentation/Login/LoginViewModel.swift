//
//  LoginViewModel.swift
//  iOS-Avanzado-Dbz
//
//  Created by Kevin Heredia on 20/10/24.
//

import Foundation

enum LoginState{
    case initial
    case loading
    case success
    case error(reason: String)
    
}

final class LoginViewModel {
    
    let onStateChaged: Binding<LoginState> = Binding(.initial)
    private let loginUseCase: LoginUseCaseContract
    
 
    init(loginUseCase: LoginUseCaseContract) {
        self.loginUseCase = loginUseCase
    }
    
    func signIn(userName: String?, password: String?) {
        guard let userName, isValidUsername(userName) else {
            return onStateChaged.value = .error(reason: "Invalid username. Must be an email")
        }
        
        guard let password, isValidPassword(password) else {
            return onStateChaged.value = .error(reason: "Invalid password. Must be at least 4 characters")
        }
        
        onStateChaged.value = .loading
        loginUseCase.execute(username: userName, password: password) { [weak self] result in
            switch result {
                
            case .success():
                self?.onStateChaged.value = .success
            case .failure(let error):
                self?.onStateChaged.value = .error(reason: error.localizedDescription)
            }
        }
    }
    
    // MARK: - Validate functions
    
    private func isValidUsername(_ username: String) -> Bool {
        username.contains("@") && !username.isEmpty
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        password.count >= 4
    }
}
