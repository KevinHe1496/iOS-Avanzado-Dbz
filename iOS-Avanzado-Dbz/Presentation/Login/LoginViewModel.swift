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
    private let useCase: LoginUseCaseContract
    
    init(useCase: LoginUseCaseContract) {
        self.useCase = useCase
    }
    
    func signIn(_ username: String?, _ password: String?) {
        onStateChanged.update(newValue: .loading)
        let credentials = Credentials(userName: username ?? "", password: password ?? "")
        useCase.execute(credentials: credentials) { [weak self] result in
            switch result {
                
            case .success():
                self?.onStateChanged.update(newValue: .success)
            case .failure(let error):
                self?.onStateChanged.update(newValue: .error(reason: error.reason))
            }
        }
  
    }
    
    

    
}
