import Foundation
import JWT

public enum TokenError: Error, CustomStringConvertible {
    case tokenWasNotGeneratedCorrectly

    public var description: String {
        switch self {
        case .tokenWasNotGeneratedCorrectly:
            return "Couldn't get the token from the signed data."
        }
    }
}

public struct Token: CustomStringConvertible {
    private let expiresAt: Date
    private let value: String
    public var description: String { return value }

    public var isExpired: Bool {
        return expiresAt > Date()
    }

    public static func generate(privateKeyId: String, privateKeyPath: URL, issuerId: String, expiresIn: TimeInterval = 20 * 60) throws -> Token {
        let headers = JWTHeader(alg: "ES256", typ: "JWT", cty: nil, crit: nil, kid: privateKeyId)
        let payload = TokenPayload(issuerId: issuerId, expiresIn: expiresIn)
        let privateKey = try Data(contentsOf: privateKeyPath)
        let signer = JWTSigner(algorithm: ES256(key: privateKey))
        let jwt = JWT(header: headers, payload: payload)
        let signed = try jwt.sign(using: signer)
        guard let token = String(bytes: signed, encoding: .utf8) else {
            throw TokenError.tokenWasNotGeneratedCorrectly
        }
        return Token(expiresAt: payload.exp.value, value: token)
    }
}

fileprivate struct TokenPayload: JWTPayload {
    let iss: String
    let aud: String = "appstoreconnect-v1"
    let exp: ExpirationClaim

    init(issuerId: String, expiresIn: TimeInterval) {
        iss = issuerId
        exp = ExpirationClaim(value: Date().addingTimeInterval(expiresIn))
    }

    func verify(using _: JWTSigner) throws {
        try exp.verifyNotExpired()
    }
}
