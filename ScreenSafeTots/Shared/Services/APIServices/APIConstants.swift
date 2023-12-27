//
//  APIConstants.swift
//
//  Created by Md. Mehedi Hasan on 29/9/21.
//

import Foundation

enum HTTPHeaderField: String {
    case authorization = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    //case acceptEncoding = "Accept-Encoding"
    //case accessToken = "access-Token"
    //case userAgent = "User-Agent"
}

enum ContentType: String {
    case json = "application/json"
    case multipartFormData = "multipart/form-data"
}


enum APIStatusCode: String, Codable {
    case success = "200"
    case accessDenied = "400"
    case error = "404"
    /// Unknown Status Code
    case unknown = "xxx"
    
    init(from decoder: Decoder) throws {
        let stringValue = try decoder.singleValueContainer().decode(String.self)
        //let uppercasedValue = stringValue.uppercased()
        self = APIStatusCode(rawValue: stringValue.uppercased()) ?? .unknown
    }
    
    init(stringValue: String) {
        self = APIStatusCode(rawValue: stringValue) ?? .unknown
    }
}
