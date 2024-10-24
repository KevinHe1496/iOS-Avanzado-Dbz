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
