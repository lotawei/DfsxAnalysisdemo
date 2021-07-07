//
//  DSPageDurationManager.swift
//  DfsxAnalysis
//
//  Created by lotawei on 2020/12/2.
//

import Foundation
class DSPageDurationManager: NSObject {
  
    static let  shared:DSPageDurationManager = DSPageDurationManager.init()
    fileprivate var  recodercmsHashMap = [String:DSPageTrackInfo]()
    func startRecord(_ id:String)  {
        let  trackInfo = DSFactoryInfoTool.createOriginalPageTrack()
        recodercmsHashMap[id] = trackInfo
    }
    
    /// 页面停止记录
    /// - Parameters:
    ///   - id: 页面id
    ///   - useduration: 停留时长  毫秒
    func stopRecord(_ id:String,_ useduration:Int64? = nil){
        guard let recordpage = recodercmsHashMap[id] else {
            return
        }
        let currentdate = Date().milliStamp
        recordpage.pageEnd = currentdate
        if let customduration = useduration {
            if customduration > Int(DSSessionConfig.shared.pageMaxWait) {
                recordpage.pageDuration = customduration
                updateTrackInfo(trackInfo:recordpage)
            }
            return
        }
   
        if let stardate = recodercmsHashMap[id]?.pageStart {
            let duration = Int64(currentdate) - stardate
            if duration > Int(DSSessionConfig.shared.pageMaxWait) {
                recordpage.pageDuration = duration
                updateTrackInfo(trackInfo:recordpage)
            }
        }
    }
    
    
    
   fileprivate func  updateTrackInfo(trackInfo:DSPageTrackInfo) {
        DSDataBaseManager.shared.updatepageTrackInfo(trackInfo)
    }
    
}
