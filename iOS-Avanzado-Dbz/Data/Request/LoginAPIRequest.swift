//
//  LoginAPIRequest.swift
//  iOS-Avanzado-Dbz
//
//  Created by Kevin Heredia on 22/10/24.
//

import Foundation


struct LoginAPIRequest: APIRequest {
    typealias Response = String
    var headers: [String : String]
    var method: HTTPMethod = .POST
    var path: String = "/api/auth/login"
    
    init(credentials: Credentials) {
        let loginData = Data(String(format: "%@:%@", credentials.userName, credentials.password).utf8)
        let base64String = loginData.base64EncodedString()
        headers = ["Authorization": "Basic \(base64String)"]
    }
}
