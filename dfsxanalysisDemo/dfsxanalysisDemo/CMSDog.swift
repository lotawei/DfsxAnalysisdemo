//
//  CMSDog.swift
//  DfsxAnalysis
//
//  Created by 伟龙 on 2021/1/10.
//

import Foundation
import WCDBSwift
//MARK:- Codable解析未知枚举变量时，提供默认值
public protocol EnumCodable: RawRepresentable, Codable where RawValue: Codable {
    static var defaultCase: Self { get }
}

extension EnumCodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            let decoded = try container.decode(RawValue.self)
            self = Self.init(rawValue: decoded) ?? Self.defaultCase
        } catch {
            self = Self.defaultCase
        }
    }
}
/// 内容类型
public enum ContentType: String,ColumnJSONCodable {

    case unknow         = "unknow"              //  未知
    case article        = "default"             //  图文
    case video          = "video"               //  视频
    case live           = "live"                //  直播
    case pictureset     = "pictureset"          //  图组
    case questionnaire  = "questionnaire"       //  问卷
    case vote           = "vote"                //  投票
    case link           = "link"                //  链接
    case special        = "special"             //  专题
    case signup         = "signup"              //  报名
    case audio          = "audio"               //  音频
    case show           = "show"                //  直播
    case ad             = "ad"                  //  广告
    case host           = "host"                //  主持人
    case banner         = "banner"              //  横幅
    case lottery        = "lottery"             //  抽奖
    case coinRule       = "coin_rule"           //  金币规则
    case dianshiju      = "dianshiju"           //  电视剧
    case column         = "column"              //  栏目
    case community      = "community"           //  圈子
    case hotSpecial     = "hot_special"         //  专题榜单
    case quickEntry     = "quick-entry"         // 动态入口
    case paike          = "paike"               // 拍客
    case chain          = "chain"               // 串联活动
}

class CMSFiedls:NSObject,Codable,ColumnJSONCodable {
    var  type:Int?
}

class CMSDog : Codable ,TableCodable,ColumnJSONCodable{

    var  id:Int?
    var  name:String?
    var  type:ContentType?
    var  fieds:CMSFiedls?
    
    
    enum CodingKeys:String,CodingTableKey {
        case id
        case name
        case type
        case fieds
        typealias Root  =  CMSDog
        
        static var objectRelationalMapping = TableBinding(CodingKeys.self)
   
        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                id: ColumnConstraintBinding(isPrimary: true)
            ]
        }
    }
    
  
    
    
}
