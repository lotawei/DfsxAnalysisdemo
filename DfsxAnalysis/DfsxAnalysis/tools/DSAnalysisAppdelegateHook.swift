//
//  DSAnalysisAppdelegateHook.swift
//  DfsxAnalysis
//
//  Created by lotawei on 2020/12/3.
//

import Foundation
import AppDelegateHooks
class DSAnalysisAppdelegateHook: AppDelegateHook {
    
    required init() {
        super.init()
        self.level = 500
    }

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        DSLogger.shared.debug("DSAnalysisAppdelegateHook didFinishLaunchingWithOptions")
        let   pageinevent = DSFactoryInfoTool.createOriginalEventTrack(.InternalEvent("AppLaunch"))
        DSDataBaseManager.shared.updateeventSessionInfo(pageinevent)
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        //事件记录
        
        DSAnalysisManager.shared.trackActiveBegin()
    }
    
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        UIApplication.shared.beginBackgroundTask(expirationHandler: nil);
        DSAnalysisManager.shared.trackActiveEnd()
        DSAnalysisManager.shared.commitCurrentSession()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        DSAnalysisManager.shared.trackActiveEnd()
        
    }
}

