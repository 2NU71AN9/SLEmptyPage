//
//  SLEmptyView.swift
//  SLEmptyPage
//
//  Created by RY on 2018/8/14.
//  Copyright © 2018年 SL. All rights reserved.
//

import UIKit

public class SLEmptyView: UIView {
    
    /// 展示图片,不设置时用默认的
    public var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    /// 提示内容,不设置时用默认的,设置nil时隐藏label
    public var text: String? {
        didSet {
            textLabel.text = text
            textLabel.isHidden = text == nil
        }
    }
    /// 按钮文字,不设置时用默认的,设置nil时隐藏按钮
    public var actionTitle: String? {
        didSet {
            button.setTitle(actionTitle, for: .normal)
            button.isHidden = actionTitle == nil
        }
    }
    /// 按钮点击触发的闭包
    public var tapAction: (() -> Void)?
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = image ?? SLEmptyPageManager.defaultImage
        return imageView
    }()
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        label.text = text ?? SLEmptyPageManager.defaultText
        label.isHidden = text == nil && SLEmptyPageManager.defaultText == nil
        return label
    }()
    private lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 45/2
        button.backgroundColor = SLEmptyPageManager.defaultActionBackColor
        button.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        button.setTitle(actionTitle ?? SLEmptyPageManager.defaultActionTitle, for: .normal)
        button.isHidden = actionTitle == nil && SLEmptyPageManager.defaultActionTitle == nil
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        return button
    }()
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.center = center
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    public init() {
        super.init(frame: UIScreen.main.bounds)
        backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(textLabel)
        stackView.addArrangedSubview(button)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        //宽度约束
        let widthConstraint = NSLayoutConstraint(item: stackView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: UIScreen.main.bounds.width)
        //高度约束
        let heightConstraint = NSLayoutConstraint(item: stackView, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 200)
        stackView.addConstraints([widthConstraint, heightConstraint])
        // 中心
        let centerConstraint = NSLayoutConstraint(item: stackView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: -100)
        addConstraint(centerConstraint)
        
        //宽度约束
        let widthConstraint2 = NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 200)
        //高度约束
        let heightConstraint2 = NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 45)
        button.addConstraints([widthConstraint2, heightConstraint2])
    }
    
    @objc func buttonClick() {
        tapAction?()
    }
}
