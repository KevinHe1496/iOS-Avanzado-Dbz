//
//  ApiProvider.swift
//  iOS-Avanzado-Dbz
//
//  Created by Kevin Heredia on 23/10/24.
//

import Foundation

enum GAError: Error, CustomStringConvertible {
    
    
    case requestWasNil
    case errorFromServer(reason: Error)
    case errorFromApi(statusCode: Int)
    case dataNoReveiced
    case errorParsingData
    
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
        }
    }
}

enum GAEndpoint {
    case heroes
    case locations
    case transformations
    
    func path() -> String {
        switch self {
        case .heroes:
            return "/api/heros/all"
        case .locations:
            return "api/heros/locations"
        case .transformations:
            return "api/heros/tranformations"
        }
    }
    
    func httpMethod() -> String {
        switch self {
        case .heroes, .locations, .transformations:
            "POST"
        }
    }
}

class GARequestBuilder {
    private let host = "dragonball.keepcoding.education"
    private var request: URLRequest?
    let token = "eyJraWQiOiJwcml2YXRlIiwiYWxnIjoiSFMyNTYiLCJ0eXAiOiJKV1QifQ.eyJleHBpcmF0aW9uIjo2NDA5MjIxMTIwMCwiZW1haWwiOiJrZXZpbl9oZXJlZGlhMTBAaG90bWFpbC5jb20iLCJpZGVudGlmeSI6IkY2QTMyREQ5LTEwREYtNDEzMi1BQTI2LUFENTZEMURGN0U2RSJ9.DjTM9QRu5zFtFftxeti07olNxtBLCJqikI1RE7XlGIU"
    
    private func url(endPoint: GAEndpoint) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = self.host
        components.path = endPoint.path()
        return components.url
        
    }
    
    private func setHeaders(params: [String: String]?) {
        request?.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        if let params {
            request?.httpBody = try? JSONSerialization.data(withJSONObject: params)
        }
        request?.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }
    
    func buildRequest(endPoint: GAEndpoint, params: [String: String]) -> URLRequest? {
        guard let url = self.url(endPoint: endPoint) else{
            return nil
        }
        request = URLRequest(url: url)
        request?.httpMethod = endPoint.httpMethod()
        setHeaders(params: params)
        return request
    }
}

class ApiProvider {
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
