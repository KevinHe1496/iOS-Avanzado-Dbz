//
//  SecureDataStoreMock.swift
//  iOS-Avanzado-Dbz
//
//  Created by Kevin Heredia on 28/10/24.
//

import KeychainSwift
import Foundation
@testable import iOS_Avanzado_Dbz

class SecureDataStoreMock: SecureDataStoreProtocol {
    
    private let kToken = "kToken"
    private var userDefaults = UserDefaults.standard
    
    func set(token: String) {
        userDefaults.set(token, forKey: kToken)
    }
    
    func getToken() -> String? {
        userDefaults.string(forKey: kToken)
    }
    
    func deleteToken() {
        userDefaults.removeObject(forKey: kToken)
    }
    
}
