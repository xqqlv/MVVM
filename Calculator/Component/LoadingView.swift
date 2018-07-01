//
//  LoadingView.swift
//  takeaway
//
//  Created by 徐强强 on 2018/2/1.
//  Copyright © 2018年 zaihui. All rights reserved.
//

import UIKit

public let delayTime: TimeInterval = 1.5

private let padding: CGFloat = 14
private let cornerRadius: CGFloat = 12
private let loadingWidth_Height: CGFloat = 37
private let textFont = UIFont.systemFont(ofSize: 14)
private let hudOffset = CGPoint(x: 0, y: -50)

public class LoadingView: UIView {
    
    private var delay: TimeInterval = delayTime
    private var activityView: UIActivityIndicatorView?
    private var text: String?
    private var hudWidth: CGFloat = 110
    private var hudHeight: CGFloat = 110
    private let textHudWidth: CGFloat = 130
    
    
    // MARK: - init
    
    // enable ：是否允许用户交互，默认允许。
    init(text: String?,
         delay: TimeInterval,
         enable: Bool = true,
         offset: CGPoint = hudOffset,
         superView: UIView) {
        self.delay = delay
        self.text = text
        
        super.init(frame: CGRect(origin: .zero, size: CGSize(width: hudWidth, height: hudHeight)))
        setupUI()
        addLoadingView(offset: offset, superView: superView)
        
        if !enable {
            superView.addSubview(screenView)
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        self.layer.cornerRadius = cornerRadius
        addActivityView()
        addLabel()
    }
    
    private func addLoadingView(offset: CGPoint, superView: UIView) {
        guard self.superview == nil else {
            return
        }
        
        superView.addSubview(self)
        self.alpha = 0
        
        if text != nil {
            hudWidth = textHudWidth
        }
        addConstraint(width: hudWidth, height: hudHeight)
        superView.addConstraint(toCenterX: self,
                                constantX: offset.x,
                                toCenterY: self,
                                constantY: offset.y)
    }
    
    private func addLabel() {
        
        var labelY: CGFloat = 0.0
        labelY = padding * 2 + loadingWidth_Height
        
        if let text = text {
            textLabel.text = text
            addSubview(textLabel)
            
            addConstraint(to: textLabel, edgeInset: UIEdgeInsets(top: labelY,
                                                                 left: padding / 2,
                                                                 bottom: -padding,
                                                                 right: -padding / 2))
            let textSize: CGSize = size(from: text)
            hudHeight = textSize.height + labelY + padding
        }
    }
    
    private func addActivityView() {
        activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityView?.translatesAutoresizingMaskIntoConstraints = false
        activityView?.startAnimating()
        addSubview(activityView!)
        
        generalConstraint(at: activityView!)
    }
    
    public func show() {
        self.animate(hide: false) {
        }
    }
    
    //MARK: - Hide func
    
    public func hide() {
        self.animate(hide: true) {
            
        }
    }
    
    // MARK: - method
    
    private func size(from text: String) -> CGSize {
        return text.textSizeWithFont(font: textFont, constrainedToSize: CGSize(width: hudWidth - padding, height: CGFloat(MAXFLOAT)))
    }
    
    private func generalConstraint(at view: UIView) {
        
        view.addConstraint(width: loadingWidth_Height, height: loadingWidth_Height)
        if let _ = text {
            addConstraint(toCenterX: view, toCenterY: nil)
            addConstraint(with: view,
                          topView: self,
                          leftView: nil,
                          bottomView: nil,
                          rightView: nil,
                          edgeInset: UIEdgeInsets(top: padding, left: 0, bottom: 0, right: 0))
        } else {
            addConstraint(toCenterX: view, toCenterY: view)
        }
    }
    
    //MARK: - setter && getter
    
    private lazy var screenView: UIView = {
        let view = UIView()
        view.frame = UIScreen.main.bounds
        view.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.font = textFont
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    
}

// MARK: - Extension String

extension String {
    
    fileprivate func textSizeWithFont(font: UIFont, constrainedToSize size: CGSize) -> CGSize {
        var textSize: CGSize!
        if size.equalTo(CGSize.zero) {
            let attributes = NSDictionary(object: font, forKey: NSAttributedStringKey.font as NSCopying)
            textSize = self.size(withAttributes: attributes as? [NSAttributedStringKey: Any])
        } else {
            let option = NSStringDrawingOptions.usesLineFragmentOrigin
            let attributes = NSDictionary(object: font, forKey: NSAttributedStringKey.font as NSCopying)
            
            let stringRect = self.boundingRect(with: size,
                                               options: option,
                                               attributes: attributes as? [NSAttributedStringKey: Any],
                                               context: nil)
            textSize = stringRect.size
        }
        return textSize
    }
}

// MARK: - Extension LoadingView

extension LoadingView {
    
    fileprivate class func asyncAfter(duration: TimeInterval, completion: (() -> Void)?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            completion?()
        }
    }
}

// MARK: - Extension UIView

extension UIView {
    fileprivate func animate(hide: Bool, completion: (() -> Void)? = nil) {
        
        UIView.animate(withDuration: 0.3,
                       animations: {
                        if hide {
                            self.alpha = 0
                        } else {
                            self.alpha = 1
                        }
        }) { _ in
            completion?()
        }
    }
}

// MARK: - Extension UIView

extension UIView {
    
    fileprivate func addConstraint(width: CGFloat, height: CGFloat) {
        if width > 0 {
            addConstraint(NSLayoutConstraint(item: self,
                                             attribute: .width,
                                             relatedBy: .equal,
                                             toItem: nil,
                                             attribute: NSLayoutAttribute(rawValue: 0)!,
                                             multiplier: 1,
                                             constant: width))
        }
        if height > 0 {
            addConstraint(NSLayoutConstraint(item: self,
                                             attribute: .height,
                                             relatedBy: .equal,
                                             toItem: nil,
                                             attribute: NSLayoutAttribute(rawValue: 0)!,
                                             multiplier: 1,
                                             constant: height))
        }
    }
    
    fileprivate func addConstraint(toCenterX xView: UIView?, toCenterY yView: UIView?) {
        addConstraint(toCenterX: xView, constantX: 0, toCenterY: yView, constantY: 0)
    }
    
    func addConstraint(toCenterX xView: UIView?,
                       constantX: CGFloat,
                       toCenterY yView: UIView?,
                       constantY: CGFloat) {
        if let xView = xView {
            addConstraint(NSLayoutConstraint(item: xView,
                                             attribute: .centerX,
                                             relatedBy: .equal,
                                             toItem: self,
                                             attribute: .centerX,
                                             multiplier: 1, constant: constantX))
        }
        if let yView = yView {
            addConstraint(NSLayoutConstraint(item: yView,
                                             attribute: .centerY,
                                             relatedBy: .equal,
                                             toItem: self,
                                             attribute: .centerY,
                                             multiplier: 1,
                                             constant: constantY))
        }
    }
    
    fileprivate func addConstraint(to view: UIView, edgeInset: UIEdgeInsets) {
        addConstraint(with: view,
                      topView: self,
                      leftView: self,
                      bottomView: self,
                      rightView: self,
                      edgeInset: edgeInset)
    }
    
    fileprivate func addConstraint(with view: UIView,
                                   topView: UIView?,
                                   leftView: UIView?,
                                   bottomView: UIView?,
                                   rightView: UIView?,
                                   edgeInset: UIEdgeInsets) {
        if let topView = topView {
            addConstraint(NSLayoutConstraint(item: view,
                                             attribute: .top,
                                             relatedBy: .equal,
                                             toItem: topView,
                                             attribute: .top,
                                             multiplier: 1,
                                             constant: edgeInset.top))
        }
        if let leftView = leftView {
            addConstraint(NSLayoutConstraint(item: view,
                                             attribute: .left,
                                             relatedBy: .equal,
                                             toItem: leftView,
                                             attribute: .left,
                                             multiplier: 1,
                                             constant: edgeInset.left))
        }
        if let bottomView = bottomView {
            addConstraint(NSLayoutConstraint(item: view,
                                             attribute: .bottom,
                                             relatedBy: .equal,
                                             toItem: bottomView,
                                             attribute: .bottom,
                                             multiplier: 1,
                                             constant: edgeInset.bottom))
        }
        if let rightView = rightView {
            addConstraint(NSLayoutConstraint(item: view,
                                             attribute: .right,
                                             relatedBy: .equal,
                                             toItem: rightView,
                                             attribute: .right,
                                             multiplier: 1,
                                             constant: edgeInset.right))
        }
    }
}

