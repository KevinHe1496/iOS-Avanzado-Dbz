//
//  SecureDataStore.swift
//  iOS-Avanzado-Dbz
//
//  Created by Kevin Heredia on 24/10/24.
//

import Foundation
import KeychainSwift

protocol SecureDataStoreProtocol {
    func set(token: String)
    func getToken() -> String?
    func deleteToken()
}

final class SecureDataStore: SecureDataStoreProtocol {
    private let kToken = "kToken"
    private let keychain = KeychainSwift()
    
    static let shared: SecureDataStore = .init()
    
    func set(token: String) {
        keychain.set(token, forKey: kToken)
    }
    
    func getToken() -> String? {
        keychain.get(kToken)
    }
    
    func deleteToken() {
        keychain.delete(kToken)
    }
}
