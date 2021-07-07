//
//  DSAppInfoTool.swift
//  DfsxAnalysis
//
//  Created by lotawei on 2020/11/30.
//

import Foundation
import UIKit
import Alamofire
import CoreTelephony
class DSAppInfoTool: NSObject {
    private let  netManager = NetworkReachabilityManager.init(host: "www.baidu.com")
    public  var  generalInfo:DSGeneralInfo = DSGeneralInfo.init()
    static  var  shared:DSAppInfoTool = DSAppInfoTool.init()
    private var  listenquene:DispatchQueue = DispatchQueue.init(label: "dsanalysisquene")
    override init() {
        super.init()
        loaddefaultInfo()
        listenNetSatatus()
    }
    
    fileprivate func loaddefaultInfo(){
        generalInfo.deviceId = getDeviceUUID()
        generalInfo.appId = ""
        generalInfo.appChannel = "App Store"
        generalInfo.appVersion =  getAppVersion()
        generalInfo.osType = "2"
        generalInfo.osVersion =  getSystemVersion()
        generalInfo.resolution = getDeviceResolution()
        generalInfo.operator = getcarrierName()
        generalInfo.deviceModel = getDevicenModel()
        generalInfo.deviceBrand = getDevicenName()
        generalInfo.networkType = "0"
    }
    public func configAppId(_ appid:String) {
        generalInfo.appId = appid
        DSLogger.shared.debug("--- appid 初始化成功")
    }
    public func getAppid() -> String? {
        
        return  generalInfo.appId
    }
    /// 获取当前设备uuid
    /// - Returns:
    public func  getDeviceUUID() -> String?{
        return  UIDevice.current.identifierForVendor?.uuidString ?? ""
    }
    
    /// 获取设备名称
    /// - Returns: <#description#>
    public func  getDevicenName() -> String{
        return  UIDevice.current.name
        
    }
    /// 获取设备类别
    /// - Returns: <#description#>
    public func  getDevicenModel() -> String{
        return  UIDevice.current.model
        
    }
    /// 获取系统版本
    /// - Returns: <#description#>
    public func  getSystemVersion() -> String{
        return  UIDevice.current.systemVersion
    }
    /// 获取系统名称
    /// - Returns: <#description#>
    public func  getSystemName() -> String{
        return  UIDevice.current.systemName
    }
    /// 获取电量
    /// - Returns: <#description#>
    public func  getBatteryLevel() -> String{
        return  "\(UIDevice.current.batteryLevel*100)%"
    }
    //MARK: 运营商信息
    /// 运营商信息
    /// - Returns:
    public func  getcarrierName() -> String{
        return   CTTelephonyNetworkInfo.init().subscriberCellularProvider?.carrierName ?? "0"
    }
    
    /// 获取分辨率
    /// - Returns: <#description#>
    public func  getDeviceResolution() -> String{
        let  scale = UIScreen.main.scale
        let  screenwidth = Int(UIScreen.main.bounds.size.width * scale)
        let  screenheight = Int(UIScreen.main.bounds.size.height * scale)
        return String.init("\(screenwidth)*\(screenheight)")
    }
    
    //MARK: APP相关信息
    public  func getAppInfo() -> [String:Any]?{
        return Bundle.main.infoDictionary
    }
    //MARK: 获取APP name
    public  func getAppName() -> String?{
        return getAppInfo()?["CFBundleDisplayName"] as? String ?? ""
    }
    //MARK: 获取APP version
    public  func getAppVersion() -> String?{
        return getAppInfo()?["CFBundleShortVersionString"] as? String ?? ""
    }
    //MARK: 获取APP  build
    public  func getAppbuildVersion() -> String?{
        return getAppInfo()?["CFBundleVersion"] as? String ?? ""
    }
    fileprivate  func  listenNetSatatus() {
        self.netManager?.startListening(onQueue: self.listenquene, onUpdatePerforming: {[weak self]
               st in
            switch st{
            case .notReachable:
                self?.generalInfo.networkType = "0"
                break
            case  .reachable(let type):
                switch type {
                case .ethernetOrWiFi :
                    self?.generalInfo.networkType = "1"
                    break
                case .cellular:
                    self?.generalInfo.networkType = "\(String(describing: self?.getGNetStatus()))"
                    break
                    
                }
            case .unknown:
                self?.generalInfo.networkType = "0"
        }
            
    })
    }
    
    public  func  getGNetStatus() -> Int{
        let gstatus = CTTelephonyNetworkInfo.init().currentRadioAccessTechnology
        let   tg2Types = [CTRadioAccessTechnologyEdge,CTRadioAccessTechnologyGPRS,CTRadioAccessTechnologyCDMA1x]
        let   tg3Types = [CTRadioAccessTechnologyHSDPA,CTRadioAccessTechnologyWCDMA,CTRadioAccessTechnologyHSUPA,CTRadioAccessTechnologyCDMAEVDORev0,CTRadioAccessTechnologyCDMAEVDORevA,CTRadioAccessTechnologyCDMAEVDORevB,CTRadioAccessTechnologyeHRPD]
        let   tg4Types = [CTRadioAccessTechnologyLTE]
        guard let  status = gstatus else {
            return 0
        }
        if tg2Types.contains(status) {
            return  2
        }
        if tg3Types.contains(status) {
            return  3
        }
        if tg4Types.contains(status) {
            return  4
        }
        return 0
    }
    ///   更新上一界面
    /// - Parameter page:
    public  func  updatePrePage(_ page:String) {
        self.generalInfo.prePage = page
        DSDataBaseManager.shared.updateGeneralInfo()
    }
    ///   当前界面
    /// - Parameter page:
    public  func  updateExistPage(_ page:String) {
        self.generalInfo.exitPage = page
        DSDataBaseManager.shared.updateGeneralInfo()
    }
    
}

