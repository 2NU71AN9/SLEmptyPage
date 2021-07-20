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

    @objc var isLoading = false {
        didSet {
            setUI()
        }
    }
    /// 加载时提示内容,不设置时用默认的,设置nil时隐藏label
    @objc public var loadingText: String? {
        didSet {
            if isLoading {
                textLabel.text = loadingText
                textLabel.isHidden = loadingText == nil
            }
        }
    }
    /// 空状态展示图片,不设置时用默认的
    @objc public var image: UIImage? {
        didSet {
            if !isLoading {
                imageView.image = image
            }
        }
    }
    /// 空状态提示内容,不设置时用默认的,设置nil时隐藏label
    @objc public var text: String? {
        didSet {
            if !isLoading {
                textLabel.text = text
                textLabel.isHidden = text == nil
            }
        }
    }
    /// 空状态按钮文字,不设置时用默认的,设置nil时隐藏按钮
    @objc public var actionTitle: String? {
        didSet {
            refreshBtn.setTitle(actionTitle, for: .normal)
            refreshBtn.isHidden = isLoading || actionTitle == nil
        }
    }
    /// 空状态按钮点击触发的闭包
    @objc public var refreshAction: (() -> Void)?
    /// 距离顶部多少, -1时在屏幕中间
    @objc public var topMargen: CGFloat = -1 {
        didSet {
            topConstraint.constant = topMargen
            topConstraint.isActive = topMargen != -1
            centerYConstraint.isActive = topMargen == -1
        }
    }
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var activityView: UIActivityIndicatorView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var refreshBtn: UIButton! {
        didSet {
            refreshBtn.layer.cornerRadius = 22.5
            refreshBtn.clipsToBounds = true
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
        guard let view = SLEmptyView.loadBundle().loadNibNamed("SLEmptyView", owner: nil, options: nil)?.last as? SLEmptyView else {
            return SLEmptyView()
        }
        return view
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = SLEmptyPageManager.defaultEmptyViewBgColor
        setUI()
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
    
    private func setUI() {
        isLoading ? activityView.startAnimating() : activityView.stopAnimating()
        activityView.isHidden = !isLoading
        imageView.image = image ?? SLEmptyPageManager.defaultImage
        imageView.isHidden = isLoading
        textLabel.text = isLoading ? (loadingText ?? SLEmptyPageManager.defaultLoadingText) : (text ?? SLEmptyPageManager.defaultText)
        textLabel.isHidden = isLoading ? loadingText == nil && SLEmptyPageManager.defaultLoadingText == nil : text == nil && SLEmptyPageManager.defaultText == nil
        refreshBtn.backgroundColor = SLEmptyPageManager.defaultActionBackColor
        refreshBtn.setTitle(actionTitle ?? SLEmptyPageManager.defaultActionTitle, for: .normal)
        refreshBtn.isHidden = isLoading || (actionTitle == nil && SLEmptyPageManager.defaultActionTitle == nil)
    }
}
 
extension SLEmptyView {
    static func loadBundle() -> Bundle {
        let bundle = Bundle(for: SLEmptyView.self)
        var myBundle = Bundle.main
        if let bundleURL = bundle.url(forResource: "SLEmptyPage", withExtension: "bundle") {
            myBundle = Bundle(url: bundleURL) ?? Bundle.main
        }
        return myBundle
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
