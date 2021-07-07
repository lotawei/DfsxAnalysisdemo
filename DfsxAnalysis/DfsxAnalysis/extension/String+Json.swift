//
//  String+Json.swift
//  DfsxAnalysis
//
//  Created by lotawei on 2020/12/4.
//

import Foundation
extension  String {
    
    //字符串转json
    static public  func convertDictionaryToJSONString(_ dict:Any)->String {
        let data = try? JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.init(rawValue: 0))
        let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        return jsonStr! as String
    }

    static  func convertDictionaryToJSONString(dict:[String:Any]?)->String {
        let data = try? JSONSerialization.data(withJSONObject: dict!, options: JSONSerialization.WritingOptions.init(rawValue: 0))
        let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        return jsonStr! as String
    }
    func convertJSONStringToDictionary(text: String) -> [String:Any]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions.init(rawValue: 0)]) as? [String:AnyObject]
            } catch let error as NSError {
                 print(error)
            }
        }
        return nil
    }
    
}
