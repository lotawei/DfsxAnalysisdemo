//
//  UIViewController+Hook.swift
//  DfsxAnalysis
//
//  Created by lotawei on 2020/12/1.
//

import Foundation
import UIKit

private let onceToken = "dsanalysis hook"
internal func exchangeSeletor(target:AnyClass,originalSelector:Selector,swizzledSelector:Selector) {
   let originalMethod = class_getInstanceMethod(target, originalSelector)
   let swizzledMethod = class_getInstanceMethod(target, swizzledSelector)
   //在进行 Swizzling 的时候,需要用 class_addMethod 先进行判断一下原有类中是否有要替换方法的实现
   let didAddMethod: Bool = class_addMethod(target, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))
   //如果 class_addMethod 返回 yes,说明当前类中没有要替换方法的实现,所以需要在父类中查找,这时候就用到 method_getImplemetation 去获取 class_getInstanceMethod 里面的方法实现,然后再进行 class_replaceMethod 来实现 Swizzing
   if didAddMethod {
       class_replaceMethod(target, swizzledSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
   } else {
       method_exchangeImplementations(originalMethod!, swizzledMethod!)
   }
}
extension UIViewController {
    public class func initializeMethod() {
        if self != UIViewController.self {
            return
        }
        //DispatchQueue函数保证代码只被执行一次，防止又被交换回去导致得不到想要的效果
        DispatchQueue.once(token: onceToken) {
            let originalSelector = #selector(UIViewController.viewWillAppear(_:))
            let swizzledSelector = #selector(UIViewController.swizzled_viewWillAppear(animated:))
            exchangeSeletor(target: UIViewController.classForCoder(),originalSelector: originalSelector,swizzledSelector: swizzledSelector)
            let originalSelector1 = #selector(UIViewController.viewWillDisappear(_:))
            let swizzledSelector1 = #selector(UIViewController.swizzled_viewWillDisappear(animated:))
            exchangeSeletor(target: UIViewController.classForCoder(),originalSelector: originalSelector1,swizzledSelector: swizzledSelector1)
        }
    }
    @objc func swizzled_viewWillAppear(animated: Bool) {
        //需要注入的代码写在此处
        self.swizzled_viewWillAppear(animated: animated)
        let page = "\(NSStringFromClass(classForCoder))"
        DSAppInfoTool.shared.updateExistPage(page)
        DSAnalysisManager.shared.trackPageIn(page: page)
        DSLogger.shared.debug( "\(NSStringFromClass(classForCoder))--Appear")
        //跟踪记录page会话
        DSPageDurationManager.shared.startRecord(page)
        
        
    }
    @objc func swizzled_viewWillDisappear(animated: Bool) {
        //需要注入的代码写在此处
        self.swizzled_viewWillDisappear(animated: animated)
        let page = "\(NSStringFromClass(classForCoder))"
        DSAnalysisManager.shared.trackPageViewEnd(page)
        DSAppInfoTool.shared.updatePrePage(page)
        DSLogger.shared.debug( "\(NSStringFromClass(classForCoder))--Disappear")
        DSAnalysisManager.shared.trackPageOut(page: page)
        //停止页面会话记录
        DSPageDurationManager.shared.stopRecord(page)
    }
}
