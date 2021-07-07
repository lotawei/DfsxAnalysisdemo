//
//  DSSessionConfig.swift
//  DfsxAnalysis
//
//  Created by lotawei on 2020/11/30.
//

import Foundation



class DSSessionConfig: NSObject {
    var   pageMaxWait:Int = 0  //ms
    var   maxcachecount:Int = 2 //最大缓存数
    var   isrealtime:Bool = false // 是否实时上传
    var   maxdurationUpload:Int = 30 //最大时间阀值
    static var  shared:DSSessionConfig = DSSessionConfig.init()
    
}
