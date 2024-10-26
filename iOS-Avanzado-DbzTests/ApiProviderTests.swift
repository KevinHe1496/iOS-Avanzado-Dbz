//
//  ApiProviderTests.swift
//  iOS-Avanzado-DbzTests
//
//  Created by Kevin Heredia on 26/10/24.
//

import XCTest
@testable import iOS_Avanzado_Dbz

final class ApiProviderTests: XCTestCase {
    
    var sut: ApiProvider!

    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = []
        let session = URLSession(configuration: configuration)
        sut = ApiProvider(session: session, requestBuilder: GARequestBuilder())
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

}
