//
//  DSPageTrackInfo.swift
//  DfsxAnalysis
//
//  Created by lotawei on 2020/11/30.
//

import Foundation
import WCDBSwift
class DSPageTrackInfo: Codable,ColumnJSONCodable,TableCodable {
    var  id:Int?
    var `operator` : String?
    var networkType : String?
    var sessionId : String?
    var pageDuration : Int64?
    var prePage : String?
    var page : String?
    var pageStart : Int64?
    var pageEnd : Int64?
    var userId : String?
    var generalInfo:DSGeneralInfo?
    enum CodingKeys: String, CodingKey,CodingTableKey {
        typealias Root  =  DSPageTrackInfo
        case   id = "id"
        case `operator` = "operator"
        case networkType = "networkType"
        case sessionId = "sessionId"
        case pageDuration = "pageDuration"
        case prePage = "prePage"
        case page = "page"
        case pageEnd = "pageEnd"
        case pageStart = "pageStart"
        case userId = "userId"
        case generalInfo = "generalInfo"
        static var objectRelationalMapping = TableBinding(CodingKeys.self)
        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                id: ColumnConstraintBinding(isPrimary: true,isAutoIncrement: true)
            ]
        }
    }
}

extension DSPageTrackInfo {
    
        static func  createTable(){
            let database = Database.init(withFileURL: dbsq)
            do{
                try database.create(table: userpageTable, of: DSPageTrackInfo.self)
                DSLogger.shared.debug("创建基础信息表成功")
            }catch {
                DSLogger.shared.debug("创建表失败\(error)")
            }
        }
    func  datatojson() -> [String:String] {
        var   dicdata = [String:String]()
        dicdata["operator"] = `operator`
        dicdata["networkType"] = networkType
        dicdata["sessionId"] = sessionId
        if let pageduration = pageDuration {
            dicdata["pageDuration"] = "\(pageduration)"
        }
    
        dicdata["prePage"] = prePage
        if let pageend = pageEnd {
            dicdata["pageEnd"] = "\(pageend)"
        }
        if let pagestart = pageStart {
            dicdata["pageStart"] = "\(pagestart)"
        }
        dicdata["userId"] = userId
        
        return dicdata
    }
    
    
    static  func pageSessionsBody(_ trackInfos:[DSPageTrackInfo]) -> [String:Any] {
        var  dicbody = [String:Any]()
        dicbody = DSAppInfoTool.shared.generalInfo.datatojson()
        let  details = trackInfos.map { (dsinfo) -> [String:String] in
            return  dsinfo.datatojson()
        }
        dicbody["details"] = details
        return dicbody
    }
    
}
