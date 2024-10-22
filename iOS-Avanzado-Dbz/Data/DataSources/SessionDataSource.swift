//
//  SessionDataSource.swift
//  iOS-Avanzado-Dbz
//
//  Created by Kevin Heredia on 22/10/24.
//

import Foundation
import KeychainSwift

protocol SessionDataSourceContract {
    func storeSession(_ session: String)
    
    func getSession() -> String?
    
    func deleteSession()
}


final class SessionDataSource: SessionDataSourceContract{
    
    
    
    private let token = "KToken"
    private let keychain = KeychainSwift()
    
    func storeSession(_ session: String) {
        keychain.set(session, forKey: token)
    }
    
    func getSession() -> String? {
        keychain.get(token)
    }
    
    func deleteSession() {
        keychain.delete(token)
    }
    
}
