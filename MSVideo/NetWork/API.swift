//
//  API.swift
//  MSIM-Swift
//
//  Created by benny wang on 2021/12/21.
//

import Foundation
import Moya
import Alamofire

enum API {
    case videoList(field: String)
    case register(phone: String,nickName: String,avatar: String)
    case download(url: String,destination: String)
}

extension API: TargetType {
    var baseURL: URL {
        switch self {
        case .download(let url, _):
            return URL(string: url)!
        default:
            let serverUrl = "https://playvideo.qcloud.com/getplayinfo/v4/1500005830/"
            return URL(string: serverUrl)!
        }
    }
    
    var path: String {
        switch self {
        case .videoList(let field):
            return field
        case .register:
            return "/user/reg"
        default:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .download,.videoList:
            return .get
        default:
            return .post
        }
    }
    
    var task: Task {
        let params: [String: Any] = [:]
        switch self {
        case .download(_,let savePath):
            let destination: DownloadRequest.Destination = {_,_ in
                return (URL(fileURLWithPath: savePath),[.removePreviousFile,.createIntermediateDirectories])
            }
            return .downloadDestination(destination)
        case .videoList(field: _):
            return .requestPlain
        default:
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .download:
            return nil
        default:
            return nil
        }
    }
    
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
}
