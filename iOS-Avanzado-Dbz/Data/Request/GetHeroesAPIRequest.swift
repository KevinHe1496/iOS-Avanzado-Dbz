//
//  GetHeroesAPIRequest.swift
//  iOS-Avanzado-Dbz
//
//  Created by Kevin Heredia on 22/10/24.
//

import Foundation

struct GetHeroesAPIRequest: APIRequest {
    typealias Response = [Hero]
    
    var method: HTTPMethod = .POST
    
    var path: String = "/api/heros/all"
    
    let body: (any Encodable)?
    
    init(name: String?) {
        body = RequestEntity(name: name ?? "")
       
    }
    
}

private extension GetHeroesAPIRequest {
    struct RequestEntity: Encodable {
        let name: String
    }
}
