//
//  ServiceAccount.swift
//  google-service-account-kit
//
//  Created by Bunga Mungil on 03/10/24.
//

import Foundation
import AsyncHTTPClient
import JWTKit
import NIOHTTP1

public class ServiceAccount: Credentials {
    
    private let httpClient: HTTPClient
    
    private let resources: ServiceAccountResources
    
    private let scopes: [String]
    
    private let impersonating: String?
    
    private let decoder = JSONDecoder()
    
    private var storedAccessToken: Token? = nil
    
    private var lastRefreshed: Date? = nil
    
    private static let GoogleOAuthTokenURL = "https://www.googleapis.com/oauth2/v4/token"
    
    public init(resources: ServiceAccountResources, scopes: [String], impersonating: String? = nil, httpClient: HTTPClient = HTTPClient.shared) {
        self.resources = resources
        self.scopes = scopes
        self.impersonating = impersonating
        self.httpClient = httpClient
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    public func token() async throws -> Token {
        if let accessToken = self.storedAccessToken, !self.needToRefreshAccessToken() {
            return accessToken
        }
        return try await refresh()
    }
    
    public func refresh() async throws -> Token {
        let request = try HTTPClient.Request(
            url: Self.GoogleOAuthTokenURL,
            method: .POST,
            headers: [
                "Content-Type": "application/x-www-form-urlencoded"
            ],
            body: .string(
                generateRequestBody(from: generateJWT())
            )
        )
        let response = try await httpClient.execute(request: request).get()
        guard var byteBuffer = response.body,
              let responseData = byteBuffer.readData(length: byteBuffer.readableBytes),
              response.status == .ok else
        {
            throw RefreshTokenError.failedToFetchAccessToken(response.status)
        }
        let accessToken = try self.decoder.decode(Token.self, from: responseData)
        self.storedAccessToken = accessToken
        self.lastRefreshed = Date()
        return accessToken
    }
    
    public func needToRefreshAccessToken() -> Bool {
        guard
            let accessToken = self.storedAccessToken,
            let lastRefreshed = self.lastRefreshed
        else {
            return true
        }
        let now = Date()
        let expiration = lastRefreshed.addingTimeInterval(TimeInterval(accessToken.expiresIn - 30))
        return expiration <= now
    }
    
    private func generateJWT() throws -> String {
        let payload = JWTPayload(
            iss: IssuerClaim(value: resources.clientEmail),
            scope: scopes.joined(separator: " "),
            aud: AudienceClaim(value: ServiceAccount.GoogleOAuthTokenURL),
            exp: ExpirationClaim(value: Date().addingTimeInterval(3600)),
            iat: IssuedAtClaim(value: Date()),
            sub: impersonating
        )
        guard let privateKeyData = resources.privateKey.data(
            using: .utf8,
            allowLossyConversion: true
        ) else {
            throw RefreshTokenError.failedToLoadPrivateKey(resources.privateKey)
        }
        let privateKey = try RSAKey.private(pem: privateKeyData)
        return try JWTSigner.rs256(key: privateKey).sign(payload)
    }
    
    private func generateRequestBody(from token: String) throws -> String {
        guard let requestString = "grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer&assertion=\(token)"
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw RefreshTokenError.failedToGenerateRequestBody(token)
        }
        return requestString
    }
    
}
