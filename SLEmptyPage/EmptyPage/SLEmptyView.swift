//
//  SLEmptyView.swift
//  SLEmptyPage
//
//  Created by RY on 2018/8/14.
//  Copyright © 2018年 SL. All rights reserved.
//

import UIKit
import SnapKit

public class SLEmptyView: UIView {
    
    /// 展示图片,不设置时用默认的
    @objc public var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    /// 提示内容,不设置时用默认的,设置nil时隐藏label
    @objc public var text: String? {
        didSet {
            textLabel.text = text
            textLabel.isHidden = text == nil
        }
    }
    /// 按钮文字,不设置时用默认的,设置nil时隐藏按钮
    @objc public var actionTitle: String? {
        didSet {
            button.setTitle(actionTitle, for: .normal)
            button.isHidden = actionTitle == nil
        }
    }
    /// 按钮点击触发的闭包
    @objc public var tapAction: (() -> Void)?
    /// 距离顶部多少, -1时在屏幕中间
    @objc public var offsetY: CGFloat = -1 {
        didSet {
            if offsetY != -1 {
                stackView.snp.makeConstraints { (make) in
                    make.top.equalToSuperview().offset(offsetY)
                }
            }
        }
    }
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = image ?? SLEmptyPageManager.defaultImage
        return imageView
    }()
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.5741485357, green: 0.5741624236, blue: 0.574154973, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = text ?? SLEmptyPageManager.defaultText
        label.isHidden = text == nil && SLEmptyPageManager.defaultText == nil
        return label
    }()
    private lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 35/2
        button.backgroundColor = SLEmptyPageManager.defaultActionBackColor
        button.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
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
        super.init(frame: CGRect.zero)
        backgroundColor = SLEmptyPageManager.defaultEmptyViewBgColor
        addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(textLabel)
        stackView.addArrangedSubview(UILabel())
        stackView.addArrangedSubview(button)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        stackView.snp.makeConstraints { (make) in
            make.width.centerX.equalToSuperview()
            make.height.lessThanOrEqualToSuperview()
            if offsetY != -1 {
                make.top.equalToSuperview().offset(offsetY)
            } else {
                make.centerY.equalToSuperview().offset(-UIApplication.shared.statusBarFrame.height - 44)
            }
        }
        button.snp.makeConstraints { (make) in
            make.width.equalTo(120)
            make.height.equalTo(35)
        }
    }
    
    @objc func buttonClick() {
        tapAction?()
    }
}
