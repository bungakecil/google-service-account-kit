//
//  ServiceAccountTest.swift
//  google-service-account-kit
//
//  Created by Bunga Mungil on 03/10/24.
//

import XCTest
import AsyncHTTPClient
import ServiceAccount

final class ServiceAccountTest: XCTestCase {
    
    func testServiceAccount() async throws {
        guard let serviceAccountFilePath = ProcessInfo.processInfo.environment["SERVICE_ACCOUNT_FILE"] else {
            XCTFail("SERVICE_ACCOUNT_FILE environment variable not set")
            return
        }
        let serviceAccount = try ServiceAccount(
            properties: .init(fromFilePath: serviceAccountFilePath),
            scopes: [
                "https://www.googleapis.com/auth/spreadsheets",
                "https://www.googleapis.com/auth/youtube.readonly",
                "https://www.googleapis.com/auth/drive"
            ]
        )
        let token = try await serviceAccount.token()
        print(token)
    }
    
}
