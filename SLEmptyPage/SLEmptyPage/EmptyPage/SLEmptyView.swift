//
//  SLEmptyView.swift
//  SLEmptyPage
//
//  Created by RY on 2018/8/14.
//  Copyright © 2018年 SL. All rights reserved.
//

import UIKit

public class SLEmptyView: UIView {
    
    /// 默认展示图片
    static var defaultImage: UIImage? = {
        let path = Bundle(for: SLEmptyView.self).resourcePath! + "/Resource.bundle"
        let CABundle = Bundle(path: path)!
        return UIImage(named: "emptyImage", in:  CABundle, compatibleWith: nil)
    }()
    /// 默认提示内容, nil时隐藏label
    static var defaultText: String? = "没有找到任何内容哦~"
    /// 默认按钮文字, nil时隐藏按钮
    static var defaultActionTitle: String? = "重新加载"
    
    /// 展示图片,不设置时用默认的
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    /// 提示内容,不设置时用默认的,设置nil时隐藏label
    var text: String? {
        didSet {
            textLabel.text = text
            textLabel.isHidden = text == nil
        }
    }
    /// 按钮文字,不设置时用默认的,设置nil时隐藏按钮
    var actionTitle: String? {
        didSet {
            button.setTitle(actionTitle, for: .normal)
            button.isHidden = actionTitle == nil
        }
    }
    /// 按钮点击触发的闭包
    var action: (() -> Void)?
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = image ?? SLEmptyView.defaultImage
        return imageView
    }()
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        label.text = text ?? SLEmptyView.defaultText
        label.isHidden = text == nil && SLEmptyView.defaultText == nil
        return label
    }()
    private lazy var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        button.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        button.setTitle(actionTitle ?? SLEmptyView.defaultActionTitle, for: .normal)
        button.isHidden = actionTitle == nil && SLEmptyView.defaultActionTitle == nil
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        return button
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        addSubview(imageView)
        addSubview(textLabel)
        addSubview(button)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        layoutViews()
    }
    
    private func layoutViews() {
        imageView.frame = CGRect(x: center.x - 125, y: center.y + 84 - 250, width: 250, height: 250)
        textLabel.frame = CGRect(x: 0, y: imageView.frame.maxY + 20, width: bounds.width, height: 30)
        button.frame = CGRect(x: center.x - 100, y: textLabel.frame.maxY + 30, width: 200, height: 45)
        button.layer.cornerRadius = button.bounds.height/2
    }
    
    @objc func buttonClick() {
        action?()
    }
}
