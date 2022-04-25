//
//  NetWorkManager.swift
//  MSIM-Swift
//
//  Created by benny wang on 2021/12/21.
//

import Foundation
import Moya


/// 超时时长
private var requestTimeOut: Double = 10
///endpointClosure
private let myEndPointClosure = {(target: API) -> Endpoint in
    ///主要是为了解决URL带有？无法请求正确的链接地址的bug
    let url = target.baseURL.absoluteString + target.path
    let endpoint = Endpoint(
        url: url,
        sampleResponseClosure: {.networkResponse(200, target.sampleData)},
        method: target.method,
        task: target.task,
        httpHeaderFields: target.headers
    )
    switch target {
    case .download(let url, let destination):
        requestTimeOut = 60
        return endpoint
    default:
        requestTimeOut = 10
        return endpoint
    }
}

private let requestClosure = {(endpoint: Endpoint, done: MoyaProvider.RequestResultClosure) in
    
    do {
        var request = try endpoint.urlRequest()
        //设置请求时长
        request.timeoutInterval = requestTimeOut
        // 打印请求参数
        if let requestData = request.httpBody {
            print("\(request.url!)"+"\n"+"\(request.httpMethod ?? "")"+"发送参数"+"\(String(data: request.httpBody!, encoding: .utf8) ?? "")")
        }else{
            print("\(request.url!)"+"\(String(describing: request.httpMethod))")
        }
        done(.success(request))
    } catch {
        done(.failure(MoyaError.underlying(error, nil)))
    }
}

/*   设置ssl
let policies: [String: ServerTrustPolicy] = [
    "example.com": .pinPublicKeys(
        publicKeys: ServerTrustPolicy.publicKeysInBundle(),
        validateCertificateChain: true,
        validateHost: true
    )
]
*/

/// NetworkActivityPlugin插件用来监听网络请求
private let networkPlugin = NetworkActivityPlugin.init { (changeType, targetType) in

    print("networkPlugin \(changeType)")
    //targetType 是当前请求的基本信息
    switch(changeType){
    case .began:
        print("开始请求网络")
        
    case .ended:
        print("结束")
    }
}

//let manager = ServerTrustManager(allHostsMustBeEvaluated: false,evaluators: [:])
//let session = Session(serverTrustManager: manager)


public class NetWorkManager {
    
    static let provider = MoyaProvider<API>(endpointClosure: myEndPointClosure, requestClosure: requestClosure, plugins: [networkPlugin], trackInflights: false)
    
    static  func netWorkRequest(_ target: API, success:@escaping (_ result: [String: Any]?) -> Void, fail:@escaping (_ error: NSError?) -> Void) {
        
        provider.request(target) { result in
            
            switch result {
            case let .success(response):
                if case .download(_,_) = target {
                    success(nil)
                    return
                }
                let jsonDic = try! response.mapJSON() as! [String: Any]
                guard let code = jsonDic["code"] as? Int,let msg = jsonDic["message"] as? String else {
                    fail(nil)
                    return
                }
                if code == 0 {
                    success(jsonDic)
                }else {
                    let err = NSError(domain: msg, code: code, userInfo: nil)
                    fail(err)
                }
            case let .failure(error):
                let err = NSError(domain: error.errorDescription ?? "", code: error.errorCode, userInfo: error.errorUserInfo)
                fail(err)
            }
        }
    }
    
}
