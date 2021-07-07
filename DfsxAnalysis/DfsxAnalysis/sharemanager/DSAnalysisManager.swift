//
//  DSAnalysisManager.swift
//  DfsxAnalysis
//
//  Created by lotawei on 2020/11/27.
//
import UIKit
import Foundation
 public class  DSAnalysisManager:NSObject{
    fileprivate  var  defaultBody:[String:Any] = [:]
    fileprivate  var  currentsessionId:String = ""
    fileprivate  var  userid:String?=nil
    public static let shared:DSAnalysisManager = DSAnalysisManager.init()
    fileprivate  var   currentSessionInfo:DSSessionGeneralInfo?=nil
    override init() {
        super.init()
        DSLogger.shared.debug("\(dbsq)")
        initalTask()
    }
}
extension  DSAnalysisManager {
    fileprivate func initalrecordTable() {
        //各种表项初始化
        DSSessionGeneralInfo.createTable()
        DSGeneralInfo.createTable()
        DSPageTrackInfo.createTable()
        DSSessionEventInfo.createTable()
        DSUploadAnalysisSevice.shared.startUploadQueneTask()
    }
    
    fileprivate func  initalTask(){
        initalrecordTable()
        //hook
        UIViewController.initializeMethod()
        
    }
    /// 停止当前session
    fileprivate  func  stopSession(){
        
    }
    /// 生成新的会话
    fileprivate  func  generateNewSessionID() -> String{
        guard let  appid = DSAppInfoTool.shared.getAppid() else {
            DSLogger.shared.debug("未设置appId")
            return ""
        }
        var  random10 = ""
        for _ in 0..<10 {
            random10 += "\(Int.randomvalue(min: 0, max: 9))"
        }
        let   sessionid = appid + "\(Int(Date.init().timeIntervalSince1970))" +  random10
        let  decrySession = sessionid.defaultDESEncrypt() ?? ""
        DSLogger.shared.debug("--- sessionid original \(String(describing: decrySession.defaultDESDecrypt()))")
        DSLogger.shared.debug("--- sessionid \(decrySession)")
        return  decrySession
    }
   
    fileprivate func  createNewSession()  -> DSSessionGeneralInfo{
        let   newsession = DSSessionGeneralInfo.init()
        newsession.generalinfo = DSAppInfoTool.shared.generalInfo
        newsession.sessionId =  self.getCurrentSessionId()
        newsession.sessionStart = Date().milliStamp
        newsession.sessionDuration = 0
        newsession.userId = self.userid
        return newsession
    }
    
}
extension DSAnalysisManager {
    /// 注册app
    /// - Parameter appid: <#appid description#>
     public  func startWithApp(_ appid:String){
        DSAppInfoTool.shared.configAppId(appid)
        
    }
    
    /// 标记某个界面开始记录
    /// - Parameter page:
    public func trackPageViewBegin(_ page:String){
        DSPageDurationManager.shared.startRecord(page)
    }
    /// 标记某个界面结束
    /// - Parameter page:
    public func trackPageViewEnd(_ page:String){
        DSPageDurationManager.shared.stopRecord(page)
    }
    /// 自定义事件 单次事件记录
    ///     /// - Parameters:
    ///   - eventid: 事件id
    public func trackEvent(_ eventid:String,_ exdic:[String:Any]? = nil){
        let   event = DSFactoryInfoTool.createOriginalEventTrack(DSEventType.CustomType(eventid), exdic: exdic)
        DSDataBaseManager.shared.updateeventSessionInfo(event)
    }
    
    /// 自定义事件 统计时长开始
    /// - Parameters:
    ///   - eventid: 事件id
    ///   - exdic: 额外信息
    public func trackCustomKeyValueEventBegin(_ eventid:String,_ exdic:[String:Any]){
        
    }
    /// 自定义事件 统计时长结束
    /// - Parameters:
    ///   - eventid: 事件id
    ///   - exdic: 额外信息
    public func trackCustomKeyValueEventEnd(_ eventid:String,_ exdic:[String:Any]){
        
    }

    public func  commitCurrentSession(){
        guard let currentsession = self.currentSessionInfo else {
            return
        }
        DSUploadAnalysisSevice.uploadSessionRecord(currentsession)
    }
    ///进入前台的方式统计
    public  func  trackActiveBegin(){
        self.currentsessionId = self.generateNewSessionID()
        currentSessionInfo = self.createNewSession()
    }
    
    /// 离开前台后的统计
    public func trackActiveEnd(){
        guard let cureentsession = self.currentSessionInfo else {
            return
        }
        let currentdate = Date().milliStamp
        cureentsession.sessionEnd = currentdate
        
        if let stardate = cureentsession.sessionStart {
            let duration = Int64(currentdate) - stardate
            if duration > Int(DSSessionConfig.shared.pageMaxWait) {
                cureentsession.sessionDuration = duration
                DSDataBaseManager.shared.updatepageSessionInfo(cureentsession)
            }
        }
    }
    
    public func  getCurrentSessionId() -> String{
        return self.currentsessionId
    }
    public func  getUserId() -> String?{
        return self.userid
    }
    
}
/// 预留内置事件拦截
extension  DSAnalysisManager {
    
    /// 记录加载完毕的事件
    internal func  trackAppLaunch(){
        let   pageinevent = DSFactoryInfoTool.createOriginalEventTrack(.InternalEvent("AppLaunch"))
        DSDataBaseManager.shared.updateeventSessionInfo(pageinevent)
    }
    /// 记录进入后台的事件
    internal func  trackAppEnterBackground(){
        let   pageinevent = DSFactoryInfoTool.createOriginalEventTrack(.InternalEvent("AppEnterBackground"))
        DSDataBaseManager.shared.updateeventSessionInfo(pageinevent)
    }
    /// 记录进入前台的事件
    internal func  trackAppEnterForground(){
        let   pageinevent = DSFactoryInfoTool.createOriginalEventTrack(.InternalEvent("AppEnterForground"))
        DSDataBaseManager.shared.updateeventSessionInfo(pageinevent)
    }
    /// 记录强制中断的事件
    internal func  trackAppExit(){
        let   pageinevent = DSFactoryInfoTool.createOriginalEventTrack(.InternalEvent("AppExit"))
        DSDataBaseManager.shared.updateeventSessionInfo(pageinevent)
    }
    /// 记录页面出现的事件
    /// - Parameter page: <#page description#>
    internal func  trackPageIn(page:String){
        let   pageinevent = DSFactoryInfoTool.createOriginalEventTrack(.InternalEvent("PageIn"), exdic: ["page":page])
        DSDataBaseManager.shared.updateeventSessionInfo(pageinevent)
    }
    
    /// 记录页面消失的事件
    /// - Parameter page: <#page description#>
    internal func  trackPageOut(page:String){
        let   pageinevent = DSFactoryInfoTool.createOriginalEventTrack(.InternalEvent("PageOut"), exdic: ["page":page])
        DSDataBaseManager.shared.updateeventSessionInfo(pageinevent)
    }
    
}
