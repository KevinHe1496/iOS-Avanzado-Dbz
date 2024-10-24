//
//  SplashViewModel.swift
//  iOS-Avanzado-Dbz
//
//  Created by Kevin Heredia on 20/10/24.
//

import Foundation

enum SplashState{
    case loading
    case error
    case success
}

class SplashViewModel {
    var onStateChanged: Binding<SplashState> = Binding(.loading)
    
    func load() {
        onStateChanged.value = .loading
        DispatchQueue.global().asyncAfter(deadline: .now() + 3) { [weak self] in
            
            self?.onStateChanged.value = .success
            
        }
    }
    
}
