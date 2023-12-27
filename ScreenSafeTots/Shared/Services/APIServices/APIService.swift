//
//  APIService.swift
//
//  Created by Md. Mehedi Hasan on 29/9/21.
//

import Foundation
import UIKit

//TODO: Rename it with `APIResult`
/// Default type of `Result` returned by Alamofire, with an `AFError` `Failure` type.
typealias AFResult<Success> = Result<Success, APIClientError>

class APIService {
    
    
    //MARK: - request functionalities
    private static func request(_ urlRequest: URLRequestConvertible, completion:@escaping (Result<Data?, APIClientError>) -> Void)
        -> URLSessionDataTask? {
        do {
            let request = try urlRequest.asURLRequest()
            let dataRequest: URLSessionDataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                
                //logResponse(response)
                
                guard let response = response as? HTTPURLResponse else {
                    completion(.failure(.uncharted(description:"server error")))
                    return
                }
                guard 200...299 ~= response.statusCode else {
                    completion(.failure(.networkError(code: response.statusCode)))
                    return
                }
                if let error = error {
                    completion(.failure(.uncharted(description: error.localizedDescription)))
                    return
                }
                
                completion(.success(data))
            }
            
            dataRequest.resume()
            return dataRequest
            
        } catch {
            let encodingError = APIClientError.encodingFailed(error: error)
            completion(.failure(encodingError))
        }
        
        return nil
    }
    
    
    @discardableResult
    static func performRequest<T:Decodable>(route: APIRouter, decoder: JSONDecoder = JSONDecoder(),
                                                         completion:@escaping (AFResult<T>) -> Void) -> URLSessionDataTask? {
                
        return APIService.request(route) { result in
            
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    guard let data = data else {
                        completion(.failure(.uncharted(description:"No data")))
                        return
                    }
                    do {
                        let decodedResponse = try decoder.decode(T.self, from: data)
                        
                        if route.sessionCheck {
                            //divertToEntrySceneIfSessionExpired(decodedResponse)
                        }
                        
                        completion(.success(decodedResponse))
                    } catch {
                        completion(.failure(.decodingFailed(error: error)))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    @discardableResult
    static func performRequestForData(route: APIRouter, completion:@escaping (AFResult<Data>) -> Void) -> URLSessionDataTask? {
                
        return APIService.request(route) { result in
            
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    guard let data = data else {
                        completion(.failure(.uncharted(description:"No data")))
                        return
                    }
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    

    //MARK: - Helpers

    
    static func isEligibleForNetworkCall(showAlert: Bool = true) -> Bool {
        
        let isEligible = ReachabilityManager.shared.status
        
        if !isEligible, showAlert {
            
            let okayButton = CustomAlertButton(
                title: "Okay",
                action: nil,
                type: .cancel,
                titleColor: UIColor.white,
                bgColor: Theme.Color.primary,
                borderSetup: nil
            )
            
            let alertView = CustomAlertView(title: nil,
                                            subTitle: "You might not have access to internet or the service may be temporarily unavailable. Please try again later.",
                                            buttons: [okayButton])
            alertView.show(animated: true)
        }
        
        return isEligible
    }
    
}



enum APIClientError: Error {
    case networkError(code: Int)
    case encodingFailed(error: Error)
    case decodingFailed(error: Error)
    case uncharted(description: String)
    case unknown
    
    var description: String {
        switch self {
        case .networkError(let code):
            return "Network error with code \(code)"
        case .encodingFailed(let error):
            return error.localizedDescription
        case .decodingFailed(let error):
            return error.localizedDescription
        case .uncharted(let description):
            return description
        default:
            return "Error"
        }
    }
    
    var localizedDescription: String {
        return description
    }
    
    var domain: String {
        return description
    }
}
