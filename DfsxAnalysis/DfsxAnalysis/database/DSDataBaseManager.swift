//
//  DSDataBaseManager.swift
//  DfsxAnalysis
//
//  Created by lotawei on 2020/11/30.
//

import Foundation
import WCDBSwift
internal  let  dbsq = String.libraryDirURL.appendingPathComponent("DfsxAnalysis/Analysis.sqlite3")
internal  let  appgeneralTable = "appgeneralTable" //基本信息表
internal  let  usersessionTable:String = "usersessionTable" //会话信息表
internal  let  userpageTable:String =  "userpageTable" // 页面会话表
internal  let  usercustomEventTable:String = "usercustomEventTable" //自定义事件表
class DSDataBaseManager: NSObject {
    static  var  shared:DSDataBaseManager = DSDataBaseManager.init()
    var  database:Database?=nil
    override init() {
        super.init()
        database = Database.init(withFileURL: dbsq)
    }
}
// db 插入更新
extension DSDataBaseManager {
    
    /// 及时更新到设备基础信息到数据库
    func updateGeneralInfo()  {
        
        guard let database = self.database else {
            return
        }
        
        do {
            try database.insertOrReplace(objects: DSAppInfoTool.shared.generalInfo , intoTable: appgeneralTable)
            DSLogger.shared.debug("更新基础信息成功")
        }catch{
            DSLogger.shared.debug("更新基础信息失败")
        }
    }
    /// 插入pageTrackInfo
    func updatepageTrackInfo(_ object:DSPageTrackInfo)  {
        
        guard let database = self.database else {
            return
        }
        
        do {
            try database.insertOrReplace(objects: object , intoTable: userpageTable)
            DSLogger.shared.debug("更新新的updatepageTrackInfo track")
        }catch{
            DSLogger.shared.debug("更新新的updatepageTrackInfo track失败")
        }
    }
    /// 插入每次session会话的操作
    func updatepageSessionInfo(_ object:DSSessionGeneralInfo)  {
        
        guard let database = self.database else {
            return
        }
        
        do {
            try database.insertOrReplace(objects: object , intoTable: usersessionTable)
            DSLogger.shared.debug("更新新的updatepageSessionInfo track")
        }catch{
            DSLogger.shared.debug("更新新的updatepageSessionInfo track失败")
        }
    }
    /// 插入每次sessionevent会话的操作
    func updateeventSessionInfo(_ object:DSSessionEventInfo)  {
        
        guard let database = self.database else {
            return
        }
        
        do {
            try database.insertOrReplace(objects: object , intoTable: usercustomEventTable)
            DSLogger.shared.debug("更新新的updateeventSessionInfo track")
        }catch{
            DSLogger.shared.debug("更新新的updateeventSessionInfo track失败")
        }
    }
}

//获取表信息
extension  DSDataBaseManager {
    
    /// 获取page track 会话信息
    /// - Returns: <#description#>
    func getPageTrackInfo() -> [DSPageTrackInfo] {
        guard let database = self.database else {
            return []
        }
        
        do {
            let  allObjects:[DSPageTrackInfo] =  try database.getObjects(fromTable:userpageTable)
            return  allObjects
        }catch{
            DSLogger.shared.debug("获取DSPageTrackInfo 失败")
            return  []
        }
        
    }
    /// 获取session track 会话信息
    /// - Returns: <#description#>
    func getSessionTrackInfo() -> [DSSessionGeneralInfo] {
        guard let database = self.database else {
            return []
        }
        
        do {
            let  allObjects:[DSSessionGeneralInfo] =  try database.getObjects(fromTable:usersessionTable)
            return  allObjects
        }catch{
            DSLogger.shared.debug("获取DSSessionGeneralInfo 失败")
            return  []
        }
        
    }
    
    /// 获取session track 会话信息
    /// - Returns: <#description#>
    func getEventTrackInfo() -> [DSSessionEventInfo] {
        guard let database = self.database else {
            return []
        }
        
        do {
            let  allObjects:[DSSessionEventInfo] =  try database.getObjects(fromTable:usercustomEventTable)
            return  allObjects
        }catch{
            DSLogger.shared.debug("获取DSSessionEventInfo 失败")
            return  []
        }
        
    }
}
///数据库删除
extension  DSDataBaseManager {
    
    /// 批量删除session
    /// - Parameter sessions: <#sessions description#>
    func  deleteSessionGeneral(_ sessions:[String]) {
        guard let database = self.database else {
            return
        }
        for session in sessions {
            do {
                try database.delete(fromTable: usersessionTable, where: DSSessionGeneralInfo.Properties.sessionId.isNotNull() == session)
            } catch  {
                
                DSLogger.shared.debug("删除session info 失败")
            }
        }
    }
    /// 批量删除session
    func  deleteCustomEvent(_ events:[String]) {
        guard let database = self.database else {
            return
        }
        for event in events {
            do {
                try database.delete(fromTable: usercustomEventTable, where: DSSessionEventInfo.Properties.eventId.isNotNull() == event)
            } catch  {
                
                DSLogger.shared.debug("删除event info 失败")
            }
        }
    }
    /// 批量删除页面会话日志
    func  deletepageSession(_ sessions:[String]) {
        guard let database = self.database else {
            return
        }
        for pagesession in sessions {
            do {
                try database.delete(fromTable: userpageTable, where: DSSessionGeneralInfo.Properties.sessionId.isNull() == pagesession)
            } catch  {
                
                DSLogger.shared.debug("删除pageSession info 失败")
            }
        }
    }
}
