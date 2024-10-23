//
//  APIInterceptor.swift
//  iOS-Avanzado-Dbz
//
//  Created by Kevin Heredia on 22/10/24.
//

import Foundation

protocol APIInterceptor { }

protocol APIRequestInterceptor: APIInterceptor {
    func intercept(request: inout URLRequest)
}

final class AuthenticationRequestInterceptor: APIRequestInterceptor {
    private let dataSource: SessionDataSourceContract
    
    init(dataSource: SessionDataSourceContract = SessionDataSource()) {
        self.dataSource = dataSource
    }
    func intercept(request: inout URLRequest) {
        guard let session = dataSource.getSession() else {
            
            return
        }
        request.setValue("Bearer \(session)", forHTTPHeaderField: "Authorization")

    }
    
    
}
