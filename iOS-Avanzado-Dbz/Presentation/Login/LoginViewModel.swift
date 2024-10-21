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
    
}

final class LoginViewModel {
    
    let onStateChanged = Binding<LoginState>()
    
    func signIn(_ username: String?, _ password: String?) {
        guard let username, validateUserName(username) else {
            return onStateChanged.update(newValue: .error(reason: "Invalid Username"))
        }
        
        guard let password, validatePassword(password) else {
            return onStateChanged.update(newValue: .error(reason: "Invalid Password"))
        }
        onStateChanged.update(newValue: .loading)
        DispatchQueue.global().asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.onStateChanged.update(newValue: .success)
            
        }
    }
    
    
    private func validateUserName(_ userName: String) -> Bool {
        userName.contains("@") && !userName.isEmpty
    }
    
    private func validatePassword(_ password: String) -> Bool {
        password.count >= 5
    }
    
}
