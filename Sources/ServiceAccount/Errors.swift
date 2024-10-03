//
//  Errors.swift
//  google-service-account-kit
//
//  Created by Bunga Mungil on 03/10/24.
//

import NIOHTTP1

public protocol ServiceAccountError: Error {}

enum LoadCredentialsError: ServiceAccountError {
    
    case failedToLoadFile(String)
    
    var localizedDescription: String {
        switch self {
        case .failedToLoadFile(let path):
            return "Failed to load Google Service Account credentials from the file path : \(path)"
        }
    }
    
}

enum RefreshTokenError: ServiceAccountError {
    
    case failedToLoadPrivateKey(String)
    
    case failedToGenerateRequestBody(String)
    
    case failedToFetchAccessToken(HTTPResponseStatus)
    
    var localizedDescription: String {
        switch self {
        case .failedToLoadPrivateKey(let privateKeyString):
            return "Failed to load the private key provided : \(privateKeyString)"
        case .failedToGenerateRequestBody(let token):
            return "Failed to generate request body from generated token : \(token)"
        case .failedToFetchAccessToken(let httpStatusCode):
            return "Failed to fetch access token. Response code from server : \(httpStatusCode)"
        }
    }
    
}
