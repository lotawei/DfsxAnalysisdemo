//
//  EventType.swift
//  DfsxAnalysis
//
//  Created by lotawei on 2020/12/4.
//

import Foundation
public enum DSEventType {
     
    case InternalEvent(_ eventid:String),//内部预制事件
         CustomType(_ eventtype:String) // 自定义事件
}
