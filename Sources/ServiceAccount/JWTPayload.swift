//
//  JWTPayload.swift
//  google-service-account-kit
//
//  Created by Bunga Mungil on 03/10/24.
//

import JWTKit

/// The payload for requesting an OAuth token to make API calls to Google APIs.
/// https://developers.google.com/identity/protocols/OAuth2ServiceAccount#authorizingrequests
struct JWTPayload: JWTKit.JWTPayload {
    
    /// The email address of the service account.
    var iss: IssuerClaim
    
    /// A space-delimited list of the permissions that the application requests.
    var scope: String
    
    /// A descriptor of the intended target of the assertion. When making an access token request this value is always https://www.googleapis.com/oauth2/v4/token.
    var aud: AudienceClaim
    
    /// The expiration time of the assertion, specified as seconds since 00:00:00 UTC, January 1, 1970. This value has a maximum of 1 hour after the issued time.
    var exp: ExpirationClaim
    
    /// The time the assertion was issued, specified as seconds since 00:00:00 UTC, January 1, 1970.
    var iat: IssuedAtClaim
    
    /// The email address of the user for which the application is requesting delegated access.
    var sub: String?
    
    public func verify(using signer: JWTSigner) throws {
        try exp.verifyNotExpired()
    }
    
}
