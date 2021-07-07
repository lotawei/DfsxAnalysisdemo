//
//  MoyaPlugin.swift
//  DfsxAnalysis
//
//  Created by lotawei on 2020/11/30.
//

import Foundation
import Moya
private let requestClosure = { (endpoint: Endpoint, done: MoyaProvider.RequestResultClosure) in
    do {
        var request = try endpoint.urlRequest()
        //设置请求时长
        request.timeoutInterval = 30
        // 打印请求参数
        if let requestData = request.httpBody {
            print("[domin url:\(request.url!)"+"\n"+"\(request.httpMethod ?? "")\n"+"send url "+"\(String(data: request.httpBody!, encoding: String.Encoding.utf8) ?? "")"+"header:\(String(describing: request.allHTTPHeaderFields))]\n")
        }else{
             print("[domin url:\(request.url!)\n"+"\(String(describing: request.httpMethod))"+"header:\(String(describing: request.allHTTPHeaderFields))\n")
        }
        done(.success(request))
    } catch {
        done(.failure(MoyaError.underlying(error, nil)))
    }
}
let DSanalysisProvider = MoyaProvider<DSAnalysisTarget>(requestClosure: requestClosure,plugins: [NetworkActivityPlugin.init(networkActivityClosure: { (changetype, trarget) in
    
})])
