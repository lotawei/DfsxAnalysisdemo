//
//  CMSPaike.swift
//  DfsxAnalysis
//
//  Created by 伟龙 on 2021/1/10.
//

import Foundation
import WCDBSwift
class CMSPerson : Codable ,TableCodable,ColumnJSONCodable{
    
    var  id:Int?
    var  cmsdog:CMSDog?
    var  name:String?
    enum CodingKeys: String, CodingKey,CodingTableKey {
        typealias Root  =  CMSPerson
        static var objectRelationalMapping = TableBinding(CodingKeys.self)
        case id = "id"
        case name = "name"
        case cmsdog = "cmsdog"
        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                id: ColumnConstraintBinding(isPrimary: true)
                
            ]
        }
        
    }
    
}


class Sample: TableCodable {
    var identifier: Int? = nil
    var description: String? = nil
 
    enum CodingKeys: String, CodingTableKey {
        typealias Root = Sample
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case identifier
        case description
 
        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                identifier: ColumnConstraintBinding(isPrimary: true),
            ]
        }
    }
}
