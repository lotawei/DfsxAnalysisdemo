//
//  String+DBPath.swift
//  DfsxAnalysis
//
//  Created by lotawei on 2020/12/1.
//

import Foundation
// MARK: - 文件路径相关
public extension String {
    // 数据记录 文件存储路径, AAWingsPeripheral 使用旧的方法， Manager中使用此extension中的方法拼接
    /// 获取document路径
    static var ducumentDirURL: URL {
        let fileManager = FileManager.default
        let urlForDocument = fileManager.urls(for: .documentDirectory, in:.userDomainMask)
        let url = urlForDocument[0] as URL
        return url
    }
    /// 获取documentation路径，没有权限写入
    static var documentationDirURL: URL {
        let manager = FileManager.default
        let urlFor = manager.urls(for: .documentationDirectory, in: .userDomainMask)
        let url = urlFor[0] as URL
        return url
    }
    /// 获取libraryDirectory路径，有权限写入, iTunce
    static var libraryDirURL: URL {
        let manager = FileManager.default
        let urlFor = manager.urls(for: .libraryDirectory, in: .userDomainMask)
        let url = urlFor[0] as URL
        return url
    }
    static var fitDirPathUrl: URL {
        
        var url = String.ducumentDirURL
        url.appendPathComponent("Wings")
        url.appendPathComponent("WingsFit")
        return url
    }
    
    static func fitDirPathUrl(of userId: Int) -> URL {
        var fitDirUrl = String.fitDirPathUrl
        fitDirUrl.appendPathComponent("\(userId)")
        return fitDirUrl
    }
    
    static func fitPathUrl(of userId: Int, fitFileName: String) -> URL {
        var fitDirUrl = String.fitDirPathUrl
        fitDirUrl.appendPathComponent("\(userId)")
        fitDirUrl.appendPathComponent("\(fitFileName)")
        return fitDirUrl
    }
    
    
    static func modifyFitName(of userId: Int, fitFileName: String, newname:String)  {
        let  url = fitPathUrl(of: userId, fitFileName: fitFileName)
        var   purl = fitDirPathUrl
        purl.appendPathComponent("\(userId)")
        purl.appendPathComponent("\(newname).fit")
        
        try?  FileManager.default.copyItem(at: url, to: purl)
        //被迫写了这句 我客户端单独验证不了 虽然有一万种方法去解决bug
//       try! FileManager.default.removeItem(at: url)
    }
    
    static var userDBPathUrl: URL {
//        var url = String.ducumentDirURL
        var url = String.libraryDirURL
        url.appendPathComponent("xoss_user.sqlite3")
        return url
    }
}
