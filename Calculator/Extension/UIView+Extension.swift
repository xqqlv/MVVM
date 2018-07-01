//
//  UIView+Extension.swift
//  takeaway
//
//  Created by jike on 2018/1/24.
//  Copyright © 2018年 zaihui. All rights reserved.
//

import UIKit

extension UIView {
    // 添加点击事件
    func addOnClickListener(target: AnyObject, action: Selector) {
        let gr = UITapGestureRecognizer(target: target, action: action)
        gr.numberOfTapsRequired = 1
        isUserInteractionEnabled = true
        addGestureRecognizer(gr)
    }

    // 移除所有子控件
    func removeAllSubViews() {
        self.subviews.forEach { view in
            view.removeFromSuperview()
        }
    }
}

// MARK: -- Frame Convenience

extension UIView {
    var origin: CGPoint {
        get {
            return frame.origin
        }
        set {
            frame.origin = newValue
        }
    }

    var size: CGSize {
        get {
            return frame.size
        }
        set {
            frame.size = newValue
        }
    }

    var x: CGFloat {
        get {
            return origin.x
        }
        set {
            frame.origin.x = newValue
        }
    }

    var y: CGFloat {
        get {
            return origin.y
        }
        set {
            frame.origin.y = newValue
        }
    }

    var width: CGFloat {
        get {
            return size.width
        }
        set {
            frame.size.width = newValue
        }
    }

    var height: CGFloat {
        get {
            return size.height
        }
        set {
            frame.size.height = newValue
        }
    }

    var centerX: CGFloat {
        get {
            return center.x
        }
        set {
            center.x = newValue
        }
    }

    var centerY: CGFloat {
        get {
            return center.y
        }
        set {
            center.y = newValue
        }
    }

}
