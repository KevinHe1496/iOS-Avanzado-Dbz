//
//  APIRequest.swift
//  iOS-Avanzado-Dbz
//
//  Created by Kevin Heredia on 21/10/24.
//

import Foundation


enum HTTPMethod: String{
    case GET, POST, PUT, UPDATE, HEAD, PATCH, DELETE
}

protocol APIRequest {
    var host: String { get }
    var method: HTTPMethod { get }
    var body: Encodable? { get }
    var path: String { get }
    var headers: [String: String] { get }
    var queryParameters: [String: String] { get }
    
    associatedtype Response: Decodable
    typealias APIRequestResponse = Result<Response, APIErrorResponse>
    typealias APIRequestCompletion = (APIRequestResponse) -> Void
}


extension APIRequest {
    var host: String { "dragonball.keepcoding.education" }
    var queryParameters: [String: String] { [:] }
    var body: Encodable? { nil }
    
    func getRequest() throws -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = path
        if !queryParameters.isEmpty {
            components.queryItems = queryParameters.map {URLQueryItem(name: $0.key, value: $0.value)}
        }
        guard let finalUrl = components.url else {
            throw APIErrorResponse.malformedUrl(path)
        }
        var request = URLRequest(url: finalUrl)
        request.httpMethod = method.rawValue
        
        if method != .GET, let body {
            request.httpBody = try JSONEncoder().encode(body)
        }
        request.allHTTPHeaderFields = ["Accept": "application/json", "Content-Type": "application/json"].merging(headers) { $1 }
        request.timeoutInterval = 10
        return request
    }
}
