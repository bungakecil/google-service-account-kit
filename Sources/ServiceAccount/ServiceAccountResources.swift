//
//  ServiceAccountResources.swift
//  google-service-account-kit
//
//  Created by Bunga Mungil on 03/10/24.
//

import Foundation

public struct ServiceAccountResources: Codable {
    
    public let type: String
    
    public let projectId: String
    
    public let privateKeyId: String
    
    public let privateKey: String
    
    public let clientEmail: String
    
    public let clientId: String
    
    public let authUri: URL
    
    public let tokenUri: URL
    
    public let authProviderX509CertUrl: URL
    
    public let clientX509CertUrl: URL
    
    public init(fromFilePath path: String) throws {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        if let contents = try String(contentsOfFile: path).data(using: .utf8) {
            self = try decoder.decode(ServiceAccountResources.self, from: contents)
        } else {
            throw LoadCredentialsError.failedToLoadFile(path)
        }
    }
    
}
