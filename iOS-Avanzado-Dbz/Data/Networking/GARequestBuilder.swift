//
//  GARequestBuilder.swift
//  iOS-Avanzado-Dbz
//
//  Created by Kevin Heredia on 24/10/24.
//

import Foundation

class GARequestBuilder {
    private let host = "dragonball.keepcoding.education"
    private var request: URLRequest?
    
    var token: String? {
        secureStorage.getToken()
    }
    
    private let secureStorage: SecureDataStoreProtocol
    
    init(secureStorage: SecureDataStoreProtocol = SecureDataStore.shared) {
        self.secureStorage = secureStorage
    }
    
    private func url(endPoint: GAEndpoint) throws(GAError) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = self.host
        components.path = endPoint.path()
        if let url = components.url {
            return url
        } else {
            throw GAError.badUrl
        }
        
    }
    
    private func setHeaders(params: [String: String]?, requiredAuthorization: Bool = true) throws(GAError) {
        if requiredAuthorization {
            guard let token = self.token else {
                throw GAError.sessionTokenMissing
            }
            request?.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        if let params {
            request?.httpBody = try? JSONSerialization.data(withJSONObject: params)
        }
        request?.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }
    
    func buildRequest(endPoint: GAEndpoint, params: [String: String]) throws(GAError) -> URLRequest {
        do {
            let url = try self.url(endPoint: endPoint)
            request = URLRequest(url: url)
            request?.httpMethod = endPoint.httpMethod()
            try setHeaders(params: params)
            if let finalRequest = self.request {
                return finalRequest
            }
        } catch {
            throw error
        }
        throw GAError.requestWasNil
    }
}
