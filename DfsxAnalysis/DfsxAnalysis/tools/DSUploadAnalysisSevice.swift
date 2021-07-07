//
//  DSUploadAnalysisTool.swift
//  DfsxAnalysis
//
//  Created by lotawei on 2020/12/1.
//

import Foundation
class DSUploadAnalysisSevice: NSObject {
    
    static var  shared:DSUploadAnalysisSevice = DSUploadAnalysisSevice.init()
    fileprivate var  subthread:Thread?
    func startUploadQueneTask()  {
        subthread =  Thread.init(block: {
            DSLogger.shared.debug("自己的----- 我开始了")
            let runloop = RunLoop.current
            runloop.add(Port.init(), forMode: .default)
            runloop.run()
           debugPrint("1123123----- 哇哈哈")
        })
        subthread?.start()
    }
   
    
}
extension  DSUploadAnalysisSevice{
    /// 上传会话日志
    /// - Parameter object: <#object description#>
    static  func  uploadSessionRecord(_ object:DSSessionGeneralInfo ){
        DSanalysisProvider.request(.uploadSessionRecord(object)) { (result) in
            switch  result {
            case .success(let  response):
                do {
                    let  mapjson = try response.mapJSON() as? [String:Any]
                    if let resultcode  = mapjson?["code"] as? Int {
                        if resultcode == 1000 {
                            guard let  sessionid  = object.sessionId else {
                                return
                            }
                            DSDataBaseManager.shared.deleteSessionGeneral([sessionid])
                        }
                    }
                    
                }catch {
                    
                    DSLogger.shared.debug("上传会话失败")
                }
                
            case .failure(let _):
                
                DSLogger.shared.debug("上传失败")
            }
        }
    }
    /// 上传page 日志
    /// - Parameter object: <#object description#>
    static  func  uploadPageSession(_ objects:[DSPageTrackInfo] ){
        DSanalysisProvider.request(.uploadPageRecord(objects)) { (result) in
            switch  result {
            case .success(let  response):
                do {
                    let  mapjson = try response.mapJSON() as? [String:Any]
                    if let resultcode  = mapjson?["code"] as? Int {
                        if resultcode == 1000 {
                            DSDataBaseManager.shared.deletepageSession(objects.map({ (page) -> String in
                                return  (page.sessionId ?? "")
                            }))
                        }
                    }
                    
                }catch {
                    
                    DSLogger.shared.debug("上传页面会话失败")
                }
                
            case .failure(let _):
                DSLogger.shared.debug("上传页面失败")
            }
        }
    }
    
    /// 上传page 日志
    /// - Parameter object: object description
    static  func  uploadEventRecord(_ events:[DSSessionEventInfo] ){
        DSanalysisProvider.request(.uploadTrackEvent(events)) { (result) in
            switch  result {
            case .success(let  response):
                do {
                    let  mapjson = try response.mapJSON() as? [String:Any]
                    if let resultcode  = mapjson?["code"] as? Int {
                        if resultcode == 1000 {
                            DSDataBaseManager.shared.deleteCustomEvent(events.map({ (event) -> String in
                                return  (event.eventId ?? "")
                            }))
                        }
                    }
                    
                }catch {
                    
                    DSLogger.shared.debug("上传定义事件失败")
                }
                
            case .failure(let _):
                DSLogger.shared.debug("上传自定义事件失败")
            }
        }
    }
}
