//
//  Router.swift
//  VoiceMate
//

import Foundation

enum Router: APIRouter {
    //User profile and pin related
    case getProfile(params: Dictionary<String, Any>)

    
    //MARK: method
    var method: HTTPMethod {
        switch self {
        case .getProfile:
            return .get
        default:
            return .post
        }
    }
    
    //MARK: path
    var path: String {
        switch self {
        case .getProfile:
            return "/sub/user/getprofile"
        }
    }

    //MARK: parameters
    var parameters: Parameters? {
        switch self {
        case .getProfile(let dict):
            return dict
        //default:
            //return [:]
        }
    }
    
    
    //MARK: bodyData
    var bodyData: Data? {
        switch self {
//        case .transactionData(let data):
//            return data
        default:
            return nil
        }
    }
    
//    var cachePolicy: NSURLRequest.CachePolicy {
//        switch self {
//        case .getAllNotifications:
//            return .returnCacheDataElseLoad
//        default:
//            return .useProtocolCachePolicy
//        }
//    }
    
    //MARK: ContentType
    var contentType: ContentType? {
        switch self {
//        case .uploadFile:
//            //return ContentType.multipartFormData.rawValue
//            return nil
        default:
            return .json
        }
    }
    
    var sessionCheck: Bool {
        switch self {
        default:
            return false
        }
    }
    
    var imageDataTuple: (String, Data)? {
        switch self {
        default:
            return nil
        }
    }
}
