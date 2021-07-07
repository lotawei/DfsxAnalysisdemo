//
//  DSLeadIntroView.swift
//  dfsxanalysisDemo
//
//  Created by 伟龙 on 2021/1/25.
//

import Foundation
import UIKit
class DSLeadIntroView:UIView {
    lazy var  imgview:UIImageView  = {
       let  imgview = UIImageView()
        return imgview
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    
    
}


class DSLeadIntroStackView:UIView {
    var  stacksubViews = [UIView]()
    lazy var  statckView:UIStackView = {
        let  stackView = UIStackView.init()
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        
        return stackView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUpDatas(_ strs:[String])  {
        for sta in stacksubViews {
            sta.removeFromSuperview()
        }
        self.stacksubViews = generateSubView(strs)
        
    }
    func generateSubView(_ strs:[String] ) -> [UIView] {
        var  subviews = [UIView]()
        for str in strs {
            let label = UILabel.init()
            label.text = str
        }
        return subviews
    }
    
    
}

