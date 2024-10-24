//
//  ApiProvider.swift
//  iOS-Avanzado-Dbz
//
//  Created by Kevin Heredia on 23/10/24.
//

import Foundation

protocol ApiProviderProtocol {
    func loadHeroes(name: String, completion: @escaping (Result<[ApiHero], GAError>) -> Void)
    func loadLocations(id: String, completion: @escaping (Result<[ApiLocation], GAError>) -> Void)
    func loadTransformations(id: String, completion: @escaping (Result<[ApiTransformation], GAError>) -> Void)
}


class ApiProvider: ApiProviderProtocol {
    private let session: URLSession
    private let requestBuilder: GARequestBuilder
    
    init(session: URLSession = .shared, requestBuilder: GARequestBuilder = GARequestBuilder()) {
        self.session = session
        self.requestBuilder = requestBuilder
    }
    
    func loadHeroes(name: String = "", completion: @escaping (Result<[ApiHero], GAError>) -> Void) {
        if let request = requestBuilder.buildRequest(endPoint: .heroes, params: ["name": name]) {
            makeRequest(request: request, completion: completion)
        } else {
            completion(.failure(.requestWasNil))
        }
    }
    
    func loadLocations(id: String, completion: @escaping (Result<[ApiLocation], GAError>) -> Void) {
        if let request = requestBuilder.buildRequest(endPoint: .locations, params: ["id": id]) {
            makeRequest(request: request, completion: completion)
        } else {
            completion(.failure(.requestWasNil))
        }
    }
    
    func loadTransformations(id: String, completion: @escaping (Result<[ApiTransformation], GAError>) -> Void) {
        if let request = requestBuilder.buildRequest(endPoint: .transformations, params: ["id": id]) {
            makeRequest(request: request, completion: completion)
        } else {
            completion(.failure(.requestWasNil))
        }
    }
    
    private func makeRequest<T: Decodable>(request: URLRequest,  completion: @escaping (Result<T, GAError>) -> Void ) {
        session.dataTask(with: request) { data, response, error in
            if let error {
                completion(.failure(.errorFromServer(reason: error)))
                return
            }
            
            let httpResponse = response as? HTTPURLResponse
            let statusCode = httpResponse?.statusCode
            if statusCode != 200 {
                completion(.failure(.errorFromApi(statusCode: statusCode ?? -1)))
                return
            }
            
            if let data {
                do {
                    let apiInfo = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(apiInfo))
                } catch {
                    completion(.failure(.errorParsingData))
                }
            }else{
                completion(.failure(.dataNoReveiced))
            }
        }.resume()
    }
}
