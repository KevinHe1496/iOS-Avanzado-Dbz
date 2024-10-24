//
//  SessionDataSource.swift
//  iOS-Avanzado-Dbz
//
//  Created by Kevin Heredia on 22/10/24.
//

import Foundation
import KeychainSwift

protocol SessionDataSourceContract {
    func storeSession(_ session: Data)
    func getSession() -> Data?
   
}


final class SessionDataSource: SessionDataSourceContract {
    
    private static var token: Data?
    
    
    func storeSession(_ session: Data) {
        SessionDataSource.token = session
    }
    
    func getSession() -> Data? {
        SessionDataSource.token 
    }
    


}
