//
//  Credentials.swift
//  google-service-account-kit
//
//  Created by Bunga Mungil on 03/10/24.
//

public protocol Credentials {
    
    func token() async throws -> Token
    
    func refresh() async throws -> Token
    
    func needToRefreshAccessToken() -> Bool
    
}
