//
//  DSFactoryInfoTool.swift
//  DfsxAnalysis
//
//  Created by lotawei on 2020/12/4.
//

import Foundation
//数据加工处理
class DSFactoryInfoTool {
    static var  shared:DSFactoryInfoTool = DSFactoryInfoTool.init()
    
    /// 生成page页面会话
    /// - Returns: <#description#>
    static func createOriginalPageTrack() -> DSPageTrackInfo {
        let   trackInfo = DSPageTrackInfo.init()
        trackInfo.generalInfo = DSAppInfoTool.shared.generalInfo
        trackInfo.operator =  DSAppInfoTool.shared.generalInfo.operator
        trackInfo.networkType = DSAppInfoTool.shared.generalInfo.networkType
        trackInfo.page = DSAppInfoTool.shared.generalInfo.exitPage
        trackInfo.prePage =  DSAppInfoTool.shared.generalInfo.prePage
        trackInfo.pageDuration =  0
        trackInfo.sessionId = DSAnalysisManager.shared.getCurrentSessionId()
        trackInfo.pageStart = Date().milliStamp
        trackInfo.pageEnd = 0
        trackInfo.userId = DSAnalysisManager.shared.getUserId()
        return trackInfo
    }
    
    
    ///生成事件会话
    /// - Parameters:
    ///   - eventype: <#eventype description#>
    ///   - page: <#page description#>
    /// - Returns: <#description#>
    static func createOriginalEventTrack(_ eventype:DSEventType , exdic:[String:Any]? = nil) -> DSSessionEventInfo {
        let   eventinfo = DSSessionEventInfo.init()
        eventinfo.generalinfo = DSAppInfoTool.shared.generalInfo
        eventinfo.operator =  DSAppInfoTool.shared.generalInfo.operator
        eventinfo.networkType = DSAppInfoTool.shared.generalInfo.networkType
        eventinfo.triggerTime = Date.init().milliStamp
        var  defaulttype = 0
        switch eventype {
        case .InternalEvent(let  eventid):
            defaulttype = 0
            eventinfo.eventId = eventid
        case .CustomType(let eventid):
            eventinfo.eventId = eventid
            defaulttype = 1
        default:
            defaulttype = 1
            
        }
        eventinfo.eventType = defaulttype
        eventinfo.sessionId = DSAnalysisManager.shared.getCurrentSessionId()
        if let bodyjson = exdic {
            let  jsonex = String.convertDictionaryToJSONString(dict: bodyjson)
            eventinfo.eventKvJson = jsonex
        }else{
            eventinfo.eventKvJson = ""
        }
        
        eventinfo.userId = DSAnalysisManager.shared.getUserId()
        
        return eventinfo
    }
    
}
