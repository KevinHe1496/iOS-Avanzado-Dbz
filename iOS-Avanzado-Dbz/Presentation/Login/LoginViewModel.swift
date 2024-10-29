//
//  LoginViewModel.swift
//  iOS-Avanzado-Dbz
//
//  Created by Kevin Heredia on 20/10/24.
//

import Foundation

enum LoginState{
    
    case loading
    case success
    case error(reason: String)
    case none
    
}

final class LoginViewModel {
    
    let onStateChaged: Binding<LoginState> = Binding(.none)
    private let loginUseCase: LoginUseCaseContract
    
 
    init(loginUseCase: LoginUseCaseContract) {
        self.loginUseCase = loginUseCase
    }
    
    func signIn(userName: String?, password: String?) -> (Bool, String){
        guard let userName, isValidUsername(userName), !userName.isEmpty else {
            return (false, "Usario no correcto")
        }
        
        guard let password, isValidPassword(password), !password.isEmpty else {
            return (false, "Password no correcto")
        }
        
        return (true, "")

    }
    
    func login(username: String, password: String) {
        onStateChaged.value = .loading
        loginUseCase.execute(username: username, password: password) { [weak self] result in
            switch result {
                
            case .success(_):
                DispatchQueue.main.async {
                    self?.onStateChaged.value = .success
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.onStateChaged.value = .error(reason: error.localizedDescription)
                }
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
