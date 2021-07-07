//
//  DSSessionEventInfo.swift
//  DfsxAnalysis
//
//  Created by lotawei on 2020/11/30.
//

import Foundation
import WCDBSwift



class DSSessionEventInfo: Codable ,TableCodable,ColumnJSONCodable{
    var id:Int?
    var `operator` : String?
    var networkType : String?
    var sessionId : String?
    var eventKvJson : String?
    var eventType : Int?
    var userId : String?
    var eventId:String?
    var triggerTime : Int64?
    var generalinfo:DSGeneralInfo?
    enum CodingKeys: String, CodingKey,CodingTableKey {
        typealias Root  =  DSSessionEventInfo
        case `operator` = "operator"
        case networkType = "networkType"
        case sessionId = "sessionId"
        case eventKvJson = "eventKvJson"
        case eventType = "eventType"
        case generalinfo = "generalinfo"
        case userId = "userId"
        case eventId = "eventId"
        case id = "id"
        case triggerTime = "triggerTime"
        static var objectRelationalMapping = TableBinding(CodingKeys.self)
        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                id: ColumnConstraintBinding(isPrimary: true,isAutoIncrement: true)
            ]
        }
       
    }
}
extension  DSSessionEventInfo {
    static func  createTable(){
        let database = Database.init(withFileURL: dbsq)
        do{
            try database.create(table: usercustomEventTable, of: DSSessionEventInfo.self)
            DSLogger.shared.debug("创建事件信息表成功")
        }catch {
            DSLogger.shared.debug("创建表失败\(error)")
        }
    }
    func  datatojson() -> [String:String] {
        var   dicdata = [String:String]()
        dicdata["eventId"]  = eventId
        dicdata["operator"] = `operator`
        dicdata["networkType"] = networkType
        dicdata["sessionId"] = sessionId
        if let eventType = eventType {
            dicdata["eventType"] = "\(eventType)"
        }
    
        dicdata["eventKvJson"] = eventKvJson
        if let triggerTime = triggerTime {
            dicdata["triggerTime"] = "\(triggerTime)"
        }
        dicdata["userId"] = userId
        
        return dicdata
    }
    
    
    static  func eventsBodyJson(_ events:[DSSessionEventInfo]) -> [String:Any] {
        var  dicbody = [String:Any]()
        dicbody = DSAppInfoTool.shared.generalInfo.datatojson()
        let  details = events.map { (dsevent) -> [String:String] in
            return  dsevent.datatojson()
        }
        dicbody["details"] = details
        return dicbody
    }
}
