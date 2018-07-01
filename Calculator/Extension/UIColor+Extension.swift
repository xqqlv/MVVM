//
//  UIColor+Extension.swift
//  takeaway
//
//  Created by heyongjian on 2017/12/28.
//  Copyright © 2017年 zaihui. All rights reserved.
//

import UIKit

public extension UIColor {
    /**
     UIColor with hex string
     
     - parameter hexString: #000000
     - parameter alpha:     alpha value
     
     - returns: UIColor
     */
    convenience init(hexString: String, alpha: Double = 1.0) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (1, 1, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(255 * alpha) / 255)
    }

    class var brandBlue: UIColor {
        return UIColor(hexString: "#6C9CFF")
    }

    class var tabbarSelectedTextColor: UIColor {
        return brandBlue
    }

    class var viewBackgroundColor: UIColor {
        return UIColor(hexString: "#FAFAFA") //LightGrey
    }

    class var blackTextColor: UIColor {
        return UIColor(hexString: "#303030")
    }

    class var grayTitleColor: UIColor {
        return UIColor(hexString: "#666666")
    }

    class var grayTextColor: UIColor {
        return UIColor(hexString: "#999999")
    }

    class var redTextColor: UIColor {
        return UIColor(hexString: "#FF6767")
    }

    class var grayLineColor: UIColor {
        return UIColor(hexString: "#EBEBEB")
    }

    class var grayShadowColor: UIColor {
        return UIColor(hexString: "#979797")
    }

    class var blackAlpha40: UIColor {
        return UIColor(hexString: "#000000", alpha: 0.4)
    }
    
    class var buttonHighlightedColor: UIColor {
        return UIColor(hexString: "#D9D9D9")
    }
    
    class var whiteAlpha0: UIColor {
        return UIColor(hexString: "#FFFFFF", alpha: 0)
    }
    
    class var whiteAlpha50: UIColor {
        return UIColor(hexString: "#FFFFFF", alpha: 0.5)
    }
    
    class var whiteAlpha90: UIColor {
        return UIColor(hexString: "#FFFFFF", alpha: 0.9)
    }
}




