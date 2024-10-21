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
    case ready
}

class SplashViewModel {
    var onStateChanged = Binding<SplashState>()
    
    func load() {
        onStateChanged.update(newValue: .loading)
        DispatchQueue.global().asyncAfter(deadline: .now() + 3) { [weak self] in
            
            self?.onStateChanged.update(newValue: .ready)
            
        }
    }
    
}
