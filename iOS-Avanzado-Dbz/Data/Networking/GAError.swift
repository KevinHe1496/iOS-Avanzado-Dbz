//
//  GAError.swift
//  iOS-Avanzado-Dbz
//
//  Created by Kevin Heredia on 24/10/24.
//

import Foundation

enum GAError: Error, CustomStringConvertible {
    
    
    case requestWasNil
    case errorFromServer(reason: Error)
    case errorFromApi(statusCode: Int)
    case dataNoReveiced
    case errorParsingData
    case sessionTokenMissing
    case badUrl
    case heroNotFound(idHero: String)
    
    var description: String {
        switch self {
            
        case .requestWasNil:
            return "Error creating request"
        case .errorFromServer(reason: let reason):
            return "Received error from server \((reason as NSError).code)"
        case .errorFromApi(statusCode: let statusCode):
            return "Received error from api status code \(statusCode)"
        case .dataNoReveiced:
            return "Data no received from server"
        case .errorParsingData:
            return "There was un error parsing data"
        case .sessionTokenMissing:
            return "Seesion token is missing"
        case .badUrl:
            return "Bad url"
        case .heroNotFound(idHero: let idHero):
            return "Hero with id \(idHero) not found"
        }
    }
}
