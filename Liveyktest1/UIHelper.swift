//
//  UIHelper.swift
//  Liveyktest1
//
//  Created by yons on 16/9/19.
//  Copyright © 2016年 xiaobo. All rights reserved.
//
import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}

