//
//  APIRouter.swift
//
//  Created by Md. Mehedi Hasan on 29/9/21.
//

import Foundation

protocol URLRequestConvertible {
    func asURLRequest() throws -> URLRequest
}

//protocol URLConvertible {
//    func asURL() throws -> URL
//}

typealias Parameters = [String : Any]

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

//protocol APIRouter: URLRequestConvertible, URLConvertible {
protocol APIRouter: URLRequestConvertible {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
    var bodyData: Data? { get }
    var contentType: ContentType? { get }
    var imageDataTuple: (String, Data)? { get }
    var sessionCheck: Bool { get }

    func asURLRequest() throws -> URLRequest
    //func asURL() throws -> URL
}


extension APIRouter {
    /// Default content type, you can always provide your own
    var contentType: ContentType? { .json }

    /// Default implementaion
    //var parameters: Parameters? { nil }

    /// Default implementaion
    //var bodyData: Data? { nil }
}


extension APIRouter {
    
    /// Default  implementation, you can always provide your own
    func asURLRequest() throws -> URLRequest {
        
        //let url = try Configuration.baseURL.asURL()
        
        var urlComponents = URLComponents(string: "baseURL" + path)!
        
        // Parameters
        var httpBody: Data?
        if let parameters = parameters {
            do {
                if method == .get {
                    if let items = paramsToQueryItems(parameters) {
                        urlComponents.queryItems = items
                    }
                } else {
                    //POST
                    httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                }
            } catch {
                //throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
                throw error
            }
        } else if let bodyData = bodyData {
            //POST only
            httpBody = bodyData
        }

        //var request = URLRequest(url: url.appendingPathComponent(path))
        var request = URLRequest(url: urlComponents.url!)
        
        request.httpMethod = method.rawValue
        request.httpBody = httpBody
        request.timeoutInterval = 60
        //request.cachePolicy = cachePolicy
        
        //Common Headers
//        request.setValue(basicAuthString(username: Configuration.authUsername, password: Configuration.authPassword),
//                         forHTTPHeaderField: HTTPHeaderField.authorization.rawValue)
        request.setValue(ContentType.json.rawValue,
                         forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        if let contentType = contentType?.rawValue {
            request.setValue(contentType, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        }

//      let request = try JSONEncoding.default.encode(request, with: parameters)
        return request
    }
    
    
    /// Default  implementation, you can always provide your own
//    func asURL() throws -> URL {
//        let url = try Configuration.baseURL.asURL()
//        return url.appendingPathComponent(path)
//    }
}


extension APIRouter  {
    
    func basicAuthString(username: String, password: String) -> String {
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        return "Basic \(base64LoginString)"
    }
    
    // Encode complex key/value objects in URLQueryItem pairs
    private func queryItems(_ key: String, _ value: Any?) -> [URLQueryItem] {
        var result = [] as [URLQueryItem]

        if let dictionary = value as? [String: AnyObject] {
            for (nestedKey, value) in dictionary {
                result += queryItems("\(key)[\(nestedKey)]", value)
            }
        } else if let array = value as? [AnyObject] {
            //let arrKey = key + "[]"
            let arrKey = key
            for value in array {
                result += queryItems(arrKey, value)
            }
        } else if let value = value {
            result.append(URLQueryItem(name: key, value: "\(value)"))
        } else {
            result.append(URLQueryItem(name: key, value: nil))
        }

        return result
    }

    
    // Encodes complex [String: AnyObject] params into array of URLQueryItem
    private func paramsToQueryItems(_ params: [String: Any]?) -> [URLQueryItem]? {
        guard let params = params else { return nil }

        var result = [] as [URLQueryItem]

        for (key, value) in params {
            result += queryItems(key, value)
        }
        //return result.sorted(by: { $0.name < $1.name })
        return result
    }
}
