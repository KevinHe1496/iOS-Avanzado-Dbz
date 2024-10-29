//
//  ApiProvider.swift
//  iOS-Avanzado-Dbz
//
//  Created by Kevin Heredia on 23/10/24.
//

import Foundation

protocol ApiProviderProtocol {
    
    
    func loginWith(username: String, password: String, completion: @escaping (Result<Bool, GAError>) -> Void)
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
    
    func loginWith(username: String, password: String, completion: @escaping (Result<Bool, GAError>) -> Void) {
        guard let loginData = String(format: "%@:%@", username, password).data(using: .utf8)?.base64EncodedString() else {
            completion(.failure(.errorParsingData))
            return
        }
        do {
            var request = try requestBuilder.buildRequest(endPoint: .login, params: [:])
            request.setValue("Basic \(loginData)", forHTTPHeaderField: "Authorization")
            makeRequest(request: request, completion: completion)
        } catch {
            completion(.failure(error))
        }
    }
    
    func loadHeroes(name: String = "", completion: @escaping (Result<[ApiHero], GAError>) -> Void) {
        do {
            let request = try requestBuilder.buildRequest(endPoint: .heroes, params: ["name": name])
            makeRequest(request: request, completion: completion)
        } catch {
            completion(.failure(error))
        }
    
    }
    
    func loadLocations(id: String, completion: @escaping (Result<[ApiLocation], GAError>) -> Void) {
        do {
            let request = try requestBuilder.buildRequest(endPoint: .locations, params: ["id": id])
            makeRequest(request: request, completion: completion)
        } catch {
            completion(.failure(error))
        }
    }
    
    func loadTransformations(id: String, completion: @escaping (Result<[ApiTransformation], GAError>) -> Void) {
        do {
            let request = try requestBuilder.buildRequest(endPoint: .transformations, params: ["id": id])
            makeRequest(request: request, completion: completion)
        } catch {
            completion(.failure(error))
        }
    }
    
    func makeRequest(request: URLRequest, completion: @escaping (Result<Bool, GAError>) -> Void) {
        
        session.dataTask(with: request) { [self] data, response, error in
            guard error == nil else {
                completion(.failure(.requestWasNil))
                return
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode,
               statusCode != 200 {
                completion(.failure(.errorFromApi(statusCode: statusCode)))
                return
            }
            
            if let data {
                if let token = String(data: data, encoding: .utf8) {
                    requestBuilder.update(token: token)
                    completion(.success(true))
                } else {
                    completion(.failure(.errorParsingData))
                }
            } else {
                completion(.failure(.dataNoReveiced))
            }
        }.resume()
        
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
