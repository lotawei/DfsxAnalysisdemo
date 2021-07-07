//
//  String+DES.swift
//  DfsxAnalysis
//
//  Created by lotawei on 2020/11/30.
//
import Foundation
import CommonCrypto

fileprivate let defaultDeskey = "d@f%s^x&"


extension String {
    
    
  public func desEncrypt(key:String) ->String? {
        return tripleDESEncryptOrDecrypt(op: CCOperation(kCCEncrypt), key: key, iv: "")
    }
    
  public func desDecrypt(key:String) -> String? {
        return tripleDESEncryptOrDecrypt(op: CCOperation(kCCDecrypt), key: key, iv: "")
    }
    
   
    public func defaultDESEncrypt() -> String?{
        return desEncrypt(key: defaultDeskey)
    }
    
    public func defaultDESDecrypt() -> String?{
        return desDecrypt(key: defaultDeskey)
    }
    
    
    /**
     DES的加密过程 和 解密过程
      说明：此次有坑：https://www.jianshu.com/p/70d02ceb5874， Java DES 模式，需要iOS CCOptions 特别设置！
     - parameter op : CCOperation： 加密还是解密
     CCOperation（kCCEncrypt）加密
     CCOperation（kCCDecrypt) 解密
     
     - parameter key: 加解密key
     - parameter iv : 可选的初始化向量，可以为nil
     - returns      : 返回加密或解密的参数
    
     */
    func tripleDESEncryptOrDecrypt(op: CCOperation,key: String,iv: String) -> String? {
        
        // Key
        let keyData: NSData = key.data(using: String.Encoding.utf8)! as NSData
        let keyBytes         = UnsafeMutableRawPointer(mutating: keyData.bytes)
        
        var data: NSData!
        if op == CCOperation(kCCEncrypt) {//加密内容
//            data  = self.data(using: String.Encoding.utf8, allowLossyConversion: true) as NSData!
            data  = self.data(using: String.Encoding.utf8)! as NSData

        }
        else {//解密内容
            data =  NSData(base64Encoded: self, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!
        }
        
        let dataLength    = size_t(data.length)
        let dataBytes     = UnsafeMutableRawPointer(mutating: data.bytes)
        
        // 返回数据
        let cryptData    = NSMutableData(length: Int(dataLength) + kCCBlockSizeDES)
        let cryptPointer = UnsafeMutableRawPointer(mutating: cryptData?.bytes)
        let cryptLength  = size_t(cryptData!.length)
        
        //  可选 的初始化向量
        let viData :NSData = iv.data(using: String.Encoding.utf8) as NSData? ?? NSData.init()
        let viDataBytes    = UnsafeMutableRawPointer(mutating: viData.bytes)
        
        // 特定的几个参数
        let keyLength              = size_t(kCCKeySizeDES)
        let operation: CCOperation = UInt32(op)
        let algoritm:  CCAlgorithm = UInt32(kCCAlgorithmDES)
        let options:   CCOptions   = UInt32(kCCOptionPKCS7Padding|kCCOptionECBMode)
        
        var numBytesCrypted :size_t = 0
        
        let cryptStatus = CCCrypt(operation, // 加密还是解密
            algoritm, // 算法类型
            options,  // 密码块的设置选项
            keyBytes, // 秘钥的字节
            keyLength, // 秘钥的长度
            viDataBytes, // 可选初始化向量的字节
            dataBytes, // 加解密内容的字节
            dataLength, // 加解密内容的长度
            cryptPointer, // output data buffer
            cryptLength,  // output data length available
            &numBytesCrypted) // real output data length
        
        
        
        if UInt32(cryptStatus) == UInt32(kCCSuccess) {
            
            cryptData!.length = Int(numBytesCrypted)
            if op == CCOperation(kCCEncrypt)  {
                let base64cryptString = cryptData?.base64EncodedString()
                return base64cryptString
            }
            else {
                let base64cryptString = String.init(data: cryptData! as Data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                return base64cryptString
            }
        } else {
            print("Error: \(cryptStatus)")
        }
        return nil
    }
}
