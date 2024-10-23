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
//    func getSessionAsString() -> String?  // Nuevo método para obtener la sesión como String
   
}


final class SessionDataSource: SessionDataSourceContract {
    
    private static var token: Data?
    
    
    func storeSession(_ session: Data) {
        SessionDataSource.token = session
    }
    
    func getSession() -> Data? {
        SessionDataSource.token
    }
    
//    // Nuevo método para obtener la sesión como String
//    func getSessionAsString() -> String? {
//        if let sessionData = getSession() {
//            // Convertir Data a String utilizando codificación UTF-8
//            return String(data: sessionData, encoding: .utf8)
//        }
//        return nil  // Retornar nil si no se pudo obtener o convertir
//    }
    

}
