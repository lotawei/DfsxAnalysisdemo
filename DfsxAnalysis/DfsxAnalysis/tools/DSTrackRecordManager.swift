//
//  TrackDataBaseRecordManager.swift
//  DfsxAnalysis
//
//  Created by 伟龙 on 2021/1/10.
//

import Foundation
import WCDBSwift


public protocol DatasourceInitializable:AnyObject {
    init()
    
    /// 创建表
    /// - Parameters:
    ///   - dbpath: <#dbpath description#>
    ///   - name: <#name description#>
    ///   - rootType: <#rootType description#>
    func create<Root>(dbpath:URL,table name: String, of rootType: Root.Type)  -> Bool where Root : WCDBSwift.TableDecodable
    
    /// 插入新的记录
    /// - Parameters:
    ///   - objects: <#objects description#>
    ///   - propertyConvertibleList: <#propertyConvertibleList description#>
    ///   - table: <#table description#>
    func insertOrReplace<Object>(objects: [Object], on propertyConvertibleList: [WCDBSwift.PropertyConvertible]?, intoTable table: String) -> Bool where Object : WCDBSwift.TableEncodable
    
    /// 获取所有数据
    /// - Parameters:
    ///   - propertyConvertibleList: <#propertyConvertibleList description#>
    ///   - table: <#table description#>
    ///   - condition: <#condition description#>
    ///   - orderList: <#orderList description#>
    ///   - limit: <#limit description#>
    ///   - offset: <#offset description#>
    func getObjects<Object>(on propertyConvertibleList: WCDBSwift.PropertyConvertible..., fromTable table: String, where condition: WCDBSwift.Condition?, orderBy orderList: [WCDBSwift.OrderBy]?, limit: WCDBSwift.Limit?, offset: WCDBSwift.Offset?) -> [Object] where Object : WCDBSwift.TableDecodable
    
    ///
    /// - Parameters:
    ///   - propertyConvertibleList: <#propertyConvertibleList description#>
    ///   - table: <#table description#>
    ///   - condition: <#condition description#>
    ///   - orderList: <#orderList description#>
    ///   - offset: <#offset description#>
    func getObject<Object>(on propertyConvertibleList: [WCDBSwift.PropertyConvertible]?, fromTable table: String, where condition: WCDBSwift.Condition, orderBy orderList: [WCDBSwift.OrderBy]?, offset: WCDBSwift.Offset?)  -> Object? where Object : WCDBSwift.TableDecodable
    
    /// 删除某条记录
    /// - Parameters:
    ///   - table: <#table description#>
    ///   - condition: <#condition description#>
    ///   - orderList: <#orderList description#>
    ///   - limit: <#limit description#>
    ///   - offset: <#offset description#>
    func delete(fromTable table: String, where condition: WCDBSwift.Condition?, orderBy orderList: [WCDBSwift.OrderBy]?, limit: WCDBSwift.Limit?, offset: WCDBSwift.Offset?)
    
    /// 获取表
    /// - Parameters:
    ///   - name: <#name description#>
    ///   - type: <#type description#>
    func getTable<Root: TableCodable>(
        named name: String,
        of type: Root.Type)  -> Table<Root>?
}


//部分参数进行扩展
public extension  DatasourceInitializable {
    @discardableResult  func insertOrReplace<Object>(objects: [Object], on propertyConvertibleList: [WCDBSwift.PropertyConvertible]? = nil , intoTable table: String) ->  Bool where Object : WCDBSwift.TableEncodable{
        return self.insertOrReplace(objects: objects, on: propertyConvertibleList, intoTable:table )
    }
    
    func getObjects<Root>(named name: String,of type: Root.Type,where condition: WCDBSwift.Condition? = nil) -> [Root]? where   Root : TableDecodable, Root : TableEncodable {
        let table = self.getTable(named: name, of: type)
        do{
            if condition != nil {
                return try  table?.getObjects( where: condition)
            }
            return  try  table?.getObjects()
        }catch{
            return  nil
        }
        
    }
    
}
private var instances = [String: DatasourceInitializable]()

public func singletonInstanceGeneric<T: DatasourceInitializable>(_ ty: T.Type = T.self) -> T {
    let name = NSStringFromClass(ty)
    if let o = (instances[name] as? T) {
        return o
    }
    let o = ty.init()
    instances[name] = o
    return o
}

public class DSTrackRecordManager:DatasourceInitializable {
    var database:Database?
    required public init() {
        
    }
    @discardableResult  public func create<Root>(dbpath: URL, table name: String, of rootType: Root.Type) -> Bool where Root : TableDecodable {
        database = Database.init(withFileURL: dbpath)
        do{
            try database?.create(table:  name, of: rootType.self)
            
            debugPrint("---创建表位置\(dbpath)")
            return true
        }catch {
            return false
        }
    }
    @discardableResult  public func insertOrReplace<Object>(objects: [Object], on propertyConvertibleList: [WCDBSwift.PropertyConvertible]?, intoTable table: String)->Bool where Object : WCDBSwift.TableEncodable {
        guard let database = self.database else {
            return false
        }
        do {
            try database.insertOrReplace(objects: objects, on: propertyConvertibleList, intoTable: table)
            return true
        }catch{
            return false
        }
    }
    
    
    public func delete(fromTable table: String, where condition: Condition?, orderBy orderList: [OrderBy]?, limit: Limit?, offset: Offset?) {
        guard let database = self.database else {
            return
        }
        do {
            return try  database.delete(fromTable: table, where: condition, orderBy: orderList, limit: limit, offset: offset)
            
            
        }catch{
            return
        }
    }
    
    public func getObjects<Object>(on propertyConvertibleList: PropertyConvertible..., fromTable table: String, where condition: Condition?, orderBy orderList: [OrderBy]?, limit: Limit?, offset: Offset?) -> [Object] where Object : TableDecodable {
        guard let database = self.database  else {
            return []
        }
        do {
            return try database.getObjects(on: propertyConvertibleList, fromTable: table, where: condition, orderBy: orderList, limit: limit, offset: offset)
        }catch{
            return []
        }
    }
    
    public func getObject<Object>(on propertyConvertibleList: [PropertyConvertible]?, fromTable table: String, where condition: Condition, orderBy orderList: [OrderBy]?, offset: Offset?) -> Object? where Object : TableDecodable {
        guard let database = self.database  else {
            return nil
        }
        do {
            if let  propertylist = propertyConvertibleList {
                return try  database.getObject(on: propertylist, fromTable: table, where: condition, orderBy: orderList, offset: offset)
            }
            return try  database.getObject( fromTable: table, where: condition, orderBy: orderList, offset: offset)
            
        }catch{
            return nil
        }
    }
    public func getTable<Root>(named name: String, of type: Root.Type) -> Table<Root>? where Root : TableDecodable, Root : TableEncodable {
        guard let database = self.database else {
            return nil
        }
        do {
            return try  database.getTable(named: name, of: type)
            
        }catch{
            return nil
        }
    }
    
}





