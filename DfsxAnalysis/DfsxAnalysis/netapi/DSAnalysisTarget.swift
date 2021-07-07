//
//  DSAnalysisTarget.swift
//  DfsxAnalysis
//
//  Created by lotawei on 2020/11/27.
//

import Foundation
import Moya

internal enum DSAnalysisTarget {

    // page——view
    case  uploadPageRecord(_ pagesessions:[DSPageTrackInfo],_ customHead:[String:String]? = nil)
    // 会话日志
    case  uploadSessionRecord(_ session:DSSessionGeneralInfo,_ customHead:[String:String]? = nil)
    //custom event
    case  uploadTrackEvent(_ events:[DSSessionEventInfo],_ customHead:[String:String]? = nil)
    
}
extension  DSAnalysisTarget:TargetType{
    var baseURL: URL {
        return  URL.init(string: "http://192.168.6.30:10004")!
    }
    
    var path: String {
        switch self {
        case .uploadSessionRecord:
            return  "report/log/session"
        case .uploadPageRecord:
            return "report/log/page_view"
        case  .uploadTrackEvent:
            return "report/log/event"
        }
    }
    
    var method: Moya.Method {
        switch self {
        
        default:
            return .post
        }
    }
    
    var sampleData: Data {
        
        return Data.init()
    }
    
    var task: Task {
        switch self {
        case .uploadSessionRecord(let session,_):
            let constructparams = session.datatojson()
            DSLogger.shared.debug(String.convertDictionaryToJSONString(constructparams))
            return  .requestParameters(parameters: constructparams, encoding: JSONEncoding.default)
        case  .uploadPageRecord(let pages, _):
            let   constructparams = DSPageTrackInfo.pageSessionsBody(pages)
            DSLogger.shared.debug(String.convertDictionaryToJSONString(constructparams))
            return  .requestParameters(parameters:constructparams , encoding: JSONEncoding.default)
        case  .uploadTrackEvent(let events, _):
            let   constructparams = DSSessionEventInfo.eventsBodyJson(events)
            DSLogger.shared.debug(String.convertDictionaryToJSONString(constructparams))
            return  .requestParameters(parameters:constructparams , encoding: JSONEncoding.default)
        }
        return  .requestPlain
    }
    
    var headers: [String : String]? {
        var defaulthead = [String:String]()
        defaulthead["X-DFSX-AppId"] = DSAppInfoTool.shared.getAppid()
        defaulthead["X-DFSX-Timestamp"] = "\(Date.init().milliStamp)"
        defaulthead["X-DFSX-Signature"] = ""
        switch self {
        case .uploadPageRecord:
            return defaulthead
        default:
           return defaulthead
        }
    }
}
