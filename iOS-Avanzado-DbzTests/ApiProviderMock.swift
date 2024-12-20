//
//  ApiProviderMock.swift
//  iOS-Avanzado-DbzTests
//
//  Created by Kevin Heredia on 12/11/24.
//

import Foundation
@testable import iOS_Avanzado_Dbz

final class ApiProviderMock: ApiProviderProtocol{
    func loginWith(username: String, password: String, completion: @escaping (Result<Bool, iOS_Avanzado_Dbz.GAError>) -> Void) {
        completion(.success(true))
    }
    
    func loadHeroes(name: String, completion: @escaping (Result<[iOS_Avanzado_Dbz.ApiHero], iOS_Avanzado_Dbz.GAError>) -> Void) {
        do{
            try completion(.success(MockData.mockHeroes()))
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loadLocations(id: String, completion: @escaping (Result<[iOS_Avanzado_Dbz.ApiLocation], iOS_Avanzado_Dbz.GAError>) -> Void) {
        do {
            try completion(.success(MockData.mockLocations()))
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loadTransformations(id: String, completion: @escaping (Result<[iOS_Avanzado_Dbz.ApiTransformation], iOS_Avanzado_Dbz.GAError>) -> Void) {
        do {
            try completion(.success(MockData.mockTransformation()))
        } catch {
            print(error.localizedDescription)
        }
    }
   
}

final class ApiProviderErrorMock: ApiProviderProtocol {
    func loginWith(username: String, password: String, completion: @escaping (Result<Bool, iOS_Avanzado_Dbz.GAError>) -> Void) {
        completion(.failure(GAError.dataNoReveiced))
    }
    
    func loadHeroes(name: String, completion: @escaping (Result<[iOS_Avanzado_Dbz.ApiHero], iOS_Avanzado_Dbz.GAError>) -> Void) {
        completion(.failure(GAError.dataNoReveiced))
    }
    
    func loadLocations(id: String, completion: @escaping (Result<[iOS_Avanzado_Dbz.ApiLocation], iOS_Avanzado_Dbz.GAError>) -> Void) {
        completion(.failure(GAError.dataNoReveiced))
    }
    
    func loadTransformations(id: String, completion: @escaping (Result<[iOS_Avanzado_Dbz.ApiTransformation], iOS_Avanzado_Dbz.GAError>) -> Void) {
        completion(.failure(GAError.dataNoReveiced))
    }
    
    
}
