//
//  Date+ms.swift
//  DfsxAnalysis
//
//  Created by lotawei on 2020/12/3.
//

import Foundation
extension Date {

   /// 获取当前 秒级 时间戳 - 10位
   var timeStamp : Int {
       let timeInterval: TimeInterval = self.timeIntervalSince1970
       let timeStamp = Int(timeInterval)
       return timeStamp
   }
    
   /// 获取当前 毫秒级 时间戳 - 13位
   var milliStamp : Int64 {
       let timeInterval: TimeInterval = self.timeIntervalSince1970
       let millisecond = CLongLong(round(timeInterval*1000))
       return millisecond
   }
}
