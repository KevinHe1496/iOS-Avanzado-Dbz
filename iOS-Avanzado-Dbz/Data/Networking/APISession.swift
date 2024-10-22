//
//  APISession.swift
//  iOS-Avanzado-Dbz
//
//  Created by Kevin Heredia on 21/10/24.
//

import Foundation

protocol APISessionContract {
    func request<Request: APIRequest>(apiRequest: Request, completion: @escaping (Result<Data, Error>) -> Void)
}

struct APISession: APISessionContract {
    static var shared: APISessionContract = APISession()
    
    private let session = URLSession(configuration: .default)
    
    func request<Request: APIRequest>(apiRequest: Request, completion: @escaping (Result<Data, any Error>) -> Void)  {
        
        do {
            var request = try apiRequest.getRequest()
            session.dataTask(with: request) { data, response, error in
                <#code#>
            }
        } catch {
            completion(.failure(error))
        }
    }
}
