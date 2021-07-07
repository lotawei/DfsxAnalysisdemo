//
//  Int+Random.swift
//  DfsxAnalysis
//
//  Created by lotawei on 2020/12/1.
//

import Foundation
extension  Int {
    
    // MARK: 随机数生成
        static  func randomvalue(min: Int, max: Int) -> Int {
             let y = arc4random() % UInt32(max) + UInt32(min)
            
            return Int(y)
        }
}
