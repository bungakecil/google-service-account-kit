//
//  Token.swift
//  google-service-account-kit
//
//  Created by Bunga Mungil on 03/10/24.
//

import Foundation

public struct Token: Codable {
    
    public let accessToken: String
    
    public let tokenType: String
    
    public let expiresIn: Int
    
}
