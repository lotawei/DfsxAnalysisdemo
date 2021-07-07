//
//  GeneralInfo.swift
//  DfsxAnalysis
//
//  Created by lotawei on 2020/11/30.
//

import Foundation
import WCDBSwift
class DSSessionGeneralInfo:Codable,TableCodable,ColumnJSONCodable {
    var  id:Int?
    var generalinfo:DSGeneralInfo?
    var sessionDuration : Int64?
    var sessionEnd : Int64?
    var sessionId : String?
    var sessionStart : Int64?
    var userId : String?
    enum CodingKeys: String, CodingKey,CodingTableKey {
        typealias Root  =  DSSessionGeneralInfo
        case sessionDuration = "sessionDuration"
        case sessionEnd = "sessionEnd"
        case sessionId = "sessionId"
        case sessionStart = "sessionStart"
        case userId = "userId"
        case generalinfo = "generalinfo"
        case id = "id"
        static var objectRelationalMapping = TableBinding(CodingKeys.self)
        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                id: ColumnConstraintBinding(isPrimary: true,isAutoIncrement: true)
            ]
        }
    }
}
extension  DSSessionGeneralInfo {
    static func  createTable(){
        let database = Database.init(withFileURL: dbsq)
        do{
            try database.create(table: usersessionTable, of: DSSessionGeneralInfo.self)
            DSLogger.shared.debug("创建信息表成功")
        }catch {
            DSLogger.shared.debug("创建表失败\(error)")
        }
    }
    func  datatojson() -> [String:String] {
        var   dicdata = [String:String]()
        dicdata =  generalinfo?.datatojson() ?? [String:String]()
        if let duration = sessionDuration {
            dicdata["sessionDuration"] = "\(duration)"
        }
        if let start = sessionStart {
            dicdata["sessionStart"] = "\(start)"
        }
        dicdata["sessionId"] = sessionId
        if let userid = userId {
            dicdata["userId"] = userid
        }
        if let  sessionend = sessionEnd{
            dicdata["sessionEnd"] = "\(sessionend)"
            
        }
        return dicdata
    }
}
