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
            refreshBtn.setTitle(actionTitle, for: .normal)
            refreshBtn.isHidden = actionTitle == nil
        }
    }
    /// 按钮点击触发的闭包
    @objc public var refreshAction: (() -> Void)?
    /// 距离顶部多少, -1时在屏幕中间
    @objc public var topMargen: CGFloat = -1 {
        didSet {
            topConstraint.constant = topMargen
            topConstraint.isActive = topMargen != -1
            centerYConstraint.isActive = topMargen == -1
        }
    }
    
    @IBOutlet private weak var imageView: UIImageView! {
        didSet {
            imageView.image = image ?? SLEmptyPageManager.defaultImage
        }
    }
    @IBOutlet private weak var textLabel: UILabel! {
        didSet {
            textLabel.text = text ?? SLEmptyPageManager.defaultText
            textLabel.isHidden = text == nil && SLEmptyPageManager.defaultText == nil
        }
    }
    @IBOutlet private weak var refreshBtn: UIButton! {
        didSet {
            refreshBtn.layer.cornerRadius = 22.5
            refreshBtn.clipsToBounds = true
            refreshBtn.backgroundColor = SLEmptyPageManager.defaultActionBackColor
            refreshBtn.setTitle(actionTitle ?? SLEmptyPageManager.defaultActionTitle, for: .normal)
            refreshBtn.isHidden = actionTitle == nil && SLEmptyPageManager.defaultActionTitle == nil
        }
    }
    @IBOutlet private weak var topConstraint: NSLayoutConstraint!
    @IBOutlet private weak var centerYConstraint: NSLayoutConstraint!

    @IBAction private func refreshButtonClick(_ sender: UIButton) {
        refreshAction?()
    }
}

extension SLEmptyView {
    public class func loadView() -> SLEmptyView {
        guard let path = Bundle.main.path(forResource: "Resource", ofType: "bundle"),
              let bundle = Bundle(path: path),
              let view = bundle.loadNibNamed("SLEmptyView", owner: nil, options: nil)?.last as? SLEmptyView else {
            return SLEmptyView()
        }
        return view
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = SLEmptyPageManager.defaultEmptyViewBgColor
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        snp.my_makeConstraints { (make) in
            make.size.equalToSuperview()
            make.center.equalToSuperview()
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        centerYConstraint.constant = -(superview?.safeAreaInsets.top ?? 0) - (isLandscape ? 0 : 80)
        centerYConstraint.isActive = topMargen == -1
        topConstraint.isActive = topMargen != -1
    }
    
    // 是否横屏
    private var isLandscape: Bool {
        UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight
    }
}

private extension ConstraintViewDSL {
    func my_makeConstraints(_ closure: (_ make: ConstraintMaker) -> Void) {
        guard let target = target as? UIView,
            target.superview != nil else {
            return
        }
        makeConstraints(closure)
    }
}
