//
//  NoNetView.swift
//  takeaway
//
//  Created by 徐强强 on 2018/3/16.
//  Copyright © 2018年 zaihui. All rights reserved.
//

import UIKit

class NoNetView: UIView {
    
    var reloadBlock: VoidBlock?
    
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
        addSubview(reloadButton)
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
        
        reloadButton.snp.makeConstraints { [unowned self] (make) in
            make.top.equalTo(self.textLabel.snp.bottom).offset(34)
            make.centerX.equalToSuperview()
            make.height.equalTo(34)
            make.width.equalTo(90)
        }
    }
    
    @objc func reloadButtonClick() {
        reloadBlock?()
    }
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "no_net_icon"))
        
        return imageView
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = .grayTextColor
        label.text = "网络连接断开，请检查网络。"
        
        return label
    }()
    
    private lazy var reloadButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitle("重新加载", for: .normal)
        button.setTitleColor(.brandBlue, for: .normal)
        button.addTarget(self, action: #selector(reloadButtonClick), for: .touchUpInside)
        
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.brandBlue.cgColor
        
        return button
    }()

}

extension NoNetView {
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


