//
//  DSBaseGeneralInfo.swift
//  DfsxAnalysis
//
//  Created by lotawei on 2020/11/30.
//

import Foundation
import WCDBSwift

class DSGeneralInfo : Codable ,TableCodable,ColumnJSONCodable{
    //基础信息这个只存一条
    var  id:Int = 1
    var appChannel : String?
    var appId : String?
    var appVersion : String?
    var deviceBrand : String?
    var deviceId : String?
    var deviceModel : String?
    var prePage:String?
    var exitPage : String? = nil {
        didSet {
            DSLogger.shared.debug("currentpage:\(String(describing: exitPage))")
        }
    }
    var networkType : String? = nil {
        didSet {
            DSLogger.shared.debug("networkType:\(String(describing: networkType))")
        }
    }
    
    var `operator` : String? 
    var osType : String?
    var osVersion : String?
    var preAppVersion : String?
    var preChannel : String?
    var resolution : String?
    
    
    
    enum CodingKeys: String, CodingKey,CodingTableKey {
        typealias Root  =  DSGeneralInfo
        static var objectRelationalMapping = TableBinding(CodingKeys.self)
        case id = "id"
        case appChannel = "appChannel"
        case appId = "appId"
        case appVersion = "appVersion"
        case deviceBrand = "deviceBrand"
        case deviceId = "deviceId"
        case deviceModel = "deviceModel"
        case exitPage = "exitPage"
        case networkType = "networkType"
        case `operator` = "operator"
        case  prePage = "prePage"
        case osType = "osType"
        case osVersion = "osVersion"
        case preAppVersion = "preAppVersion"
        case preChannel = "preChannel"
        case resolution = "resolution"
        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                id: ColumnConstraintBinding(isPrimary: true)
            ]
        }
        
    }
}


extension  DSGeneralInfo {
    static func  createTable(){
        let database = Database.init(withFileURL: dbsq)
        do{
            try database.create(table: appgeneralTable, of: DSGeneralInfo.self)
            DSLogger.shared.debug("创建基础信息表成功")
        }catch {
            DSLogger.shared.debug("创建表失败\(error)")
        }
    }
    func  datatojson() -> [String:String] {
        var   dicdata = [String:String]()
        dicdata["appChannel"] = appChannel
        dicdata["appId"] = appId
        dicdata["appVersion"] = appVersion
        dicdata["deviceBrand"] = deviceBrand
        dicdata["deviceId"] = deviceId
        dicdata["deviceModel"] = deviceModel
        dicdata["prePage"] = prePage
        dicdata["networkType"] = networkType
        dicdata["operator"] = `operator`
        dicdata["osType"] = osType
        dicdata["osVersion"] = osVersion
        dicdata["preAppVersion"] = preAppVersion
        dicdata["preChannel"] = preChannel
        dicdata["resolution"] = resolution
        return dicdata
    }
}
