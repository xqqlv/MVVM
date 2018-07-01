//
//  NoDataView.swift
//  takeaway
//
//  Created by 徐强强 on 2018/3/16.
//  Copyright © 2018年 zaihui. All rights reserved.
//

import UIKit

class NoDataView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        autoLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        addSubview(imageView)
        addSubview(textLabel)
    }
    
    func autoLayout() {
        
        imageView.snp.makeConstraints { [unowned self] (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(82)
            make.size.equalTo(self.imageView.image?.size ?? .zero)
        }
        
        textLabel.snp.makeConstraints { [unowned self] (make) in
            make.top.equalTo(self.imageView.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
            make.height.equalTo(22)
        }
    }
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.textColor = .grayTextColor
        
        return label
    }()
}

extension NoDataView {
    var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.snp.updateConstraints { (make) in
                make.size.equalTo(newValue?.size ?? .zero)
            }
        }
    }
    
    var text: String? {
        get {
            return textLabel.text
        }
        set {
            textLabel.text = newValue
        }
    }
    
    var imageViewTopMargin: CGFloat {
        get {
            return imageView.y
        }
        set {
            imageView.snp.updateConstraints { (make) in
                make.top.equalTo(newValue)
            }
        }
    }
    
}
