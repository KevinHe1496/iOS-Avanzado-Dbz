//
//  GAEndpoint.swift
//  iOS-Avanzado-Dbz
//
//  Created by Kevin Heredia on 24/10/24.
//

import Foundation

enum GAEndpoint {
    case heroes
    case locations
    case transformations
    case login
    
    func path() -> String {
        switch self {
        case .heroes:
            return "/api/heros/all"
        case .locations:
            return "/api/heros/locations"
        case .transformations:
            return "/api/heros/tranformations"
        case .login:
            return "/api/auth/login"
        }
    }
    
    func httpMethod() -> String {
        switch self {
        case .heroes, .locations, .transformations, .login:
            "POST"
        }
    }
}
