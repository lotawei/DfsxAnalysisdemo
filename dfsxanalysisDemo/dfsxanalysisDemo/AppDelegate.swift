//
//  AppDelegate.swift
//  dfsxanalysisDemo
//
//  Created by lotawei on 2020/11/27.
//

import UIKit
import DfsxAnalysis
import WCDBSwift
public  let  defaultcmsdatabaseUrl = String.libraryDirURL.appendingPathComponent("cms/data.sqlite3")
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var  window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        DSLogger.shared.logLevel = .debug
//        DSAnalysisManager.shared.startWithApp("sss")
        let manager = singletonInstanceGeneric() as DSTrackRecordManager
        
        manager.create(dbpath: defaultcmsdatabaseUrl, table: "cmsdog", of: CMSDog.self)
        manager.create(dbpath: defaultcmsdatabaseUrl, table: "cmsperson", of: CMSPerson.self)
        
        let cmsdog = CMSDog.init()
        cmsdog.name = "小狗"
        cmsdog.id = 120
        cmsdog.type = .article
//        cmsdog.data = Data.init(base64Encoded: "jjaja")
        let cms = CMSFiedls.init()
        cms.type = 3
        cmsdog.fieds = cms
        manager.insertOrReplace(objects: [cmsdog], intoTable: "cmsdog")
        
//        let cmsperson = CMSPerson.init()
//        cmsperson.cmsdog = cmsdog
//        cmsperson.name = "lw"
//        manager.insertOrReplace(objects: [cmsperson], on: [], intoTable: "cmsperson")
        //增加
//        manager.insertOrReplace(objects: [cmsperson], on: nil, intoTable: "cmsperson")
        //获取所有列表
//        let  resultdata:[CMSPerson] = manager.getObjects(named: "cmsperson", of: CMSPerson.self, where:CMSPerson.property) ?? []
//        for res in resultdata {
//            debugPrint("\(res.name) -- \(res.cmsdog)")
//        }
     
        let  dog:CMSDog? =   manager.getObject(  on: nil, fromTable: "cmsdog", where: CMSDog.Properties.id > 1 && CMSDog.Properties.name == "dog" , orderBy: nil, offset: nil)
        debugPrint(dog?.fieds?.type)
        let  so:CMSPerson? =   manager.getObject( on: nil, fromTable: "cmsperson", where: CMSPerson.Properties.id > 1 , orderBy: nil, offset: nil)
        debugPrint(so?.id)
        
        return true
    }

    


}

