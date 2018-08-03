//
//  SLEmptyView.swift
//  XiaocaoPlusNew
//
//  Created by X.T.X on 2018/1/17.
//  Copyright © 2018年 shiliukeji. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit

/// 默认的图片和说明文字
let defaultEmptyNormalImage = UIImage(named: "emptyImage")
let defaultEmptyLogoutImage = UIImage(named: "emptyImage")
let defaultEmptyNoServiceImage = UIImage(named: "emptyImage")
let defaultEmptyNormalText = "没有找到信息哦"
let defaultEmptyLogoutText = "您还没有登录呢"
let defaultEmptyNoServiceText = "您的网络好像出了点问题"
let defaultEmptyLogoutTitle = "登录"
let defaultEmptyNoServiceTitle = "重新加载"

/// 空状态页面类型
enum EmptyType {
    /// 普通
    case normal
    /// 未登录
    case logout
    /// 无网络
    case noService
}

class SLEmptyView: UIView {

    /// 空状态页面类型
    var emptyType: EmptyType = .normal {
        didSet {
            switch emptyType {
            case .normal:
                emptyImageView.image = image
                emptyLabel.text = text
                emptyBtn.isHidden = title == nil
                emptyBtn.setTitle(title, for: .normal)
            case .logout:
                emptyImageView.image = defaultEmptyLogoutImage
                emptyLabel.text = defaultEmptyLogoutText
                emptyBtn.isHidden = false
                emptyBtn.setTitle(defaultEmptyLogoutTitle, for: .normal)
            case .noService:
                emptyImageView.image = defaultEmptyNoServiceImage
                emptyLabel.text = defaultEmptyNoServiceText
                emptyBtn.isHidden = false
                emptyBtn.setTitle(defaultEmptyNoServiceTitle, for: .normal)
            }
        }
    }
    
    /// 显示图片
    var image: UIImage? = defaultEmptyNormalImage{
        didSet {
            switch emptyType {
            case .normal:
                emptyImageView.image = image
            case .logout:
                emptyImageView.image = defaultEmptyLogoutImage
            case .noService:
                emptyImageView.image = defaultEmptyNoServiceImage
            }
        }
    }
    
    /// 显示文字
    var text: String? = defaultEmptyNormalText {
        didSet {
            switch emptyType {
            case .normal:
                emptyLabel.text = text
            case .logout:
                emptyLabel.text = defaultEmptyLogoutText
            case .noService:
                emptyLabel.text = defaultEmptyNoServiceText
            }
        }
    }
    
    /// 按钮标题
    var title: String? {
        didSet {
            switch emptyType {
            case .normal:
                emptyBtn.isHidden = title == nil
                emptyBtn.setTitle(title, for: .normal)
            case .logout:
                emptyBtn.isHidden = false
                emptyBtn.setTitle(defaultEmptyLogoutTitle, for: .normal)
            case .noService:
                emptyBtn.isHidden = false
                emptyBtn.setTitle(defaultEmptyNoServiceTitle, for: .normal)
            }
        }
    }
    
    // 按钮点击事件
    var tapAction: ((EmptyType) -> Void)?
    
    private let bag = DisposeBag()
    private let emptyTypeVariable = Variable(EmptyType.normal)
    
    private var emptyImageView = UIImageView()
    private var emptyLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = UIColor.darkGray
    }
    private var emptyBtn = UIButton().then {
        $0.isHidden = true
        $0.sl_clip(radius: 20)
        $0.backgroundColor = sl_theme.SLAlmostColor
    }
    
    init(type: EmptyType, tapAction: ((EmptyType) -> Void)? = nil){
        super.init(frame: CGRect.zero)
        backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        setupUI()
        self.tapAction = tapAction
        emptyTypeVariable.value = type
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        emptyTypeVariable.asObservable().subscribe(onNext: { [weak self] (type) in
            self?.emptyType = type
        }).disposed(by: bag)
        
        emptyBtn.rx.tap.subscribe(onNext: { [weak self] (_) in
            self?.tapAction?(self?.emptyType ?? .normal)
        }).disposed(by: bag)
        
        addSubview(emptyImageView)
        addSubview(emptyLabel)
        addSubview(emptyBtn)
        
        emptyImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-80.H)
            make.width.lessThanOrEqualToSuperview()
            make.height.lessThanOrEqualToSuperview()
        }
        emptyLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(emptyImageView.snp.bottom).offset(15)
            make.width.lessThanOrEqualToSuperview()
            make.height.lessThanOrEqualTo(50)
        }
        emptyBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(emptyLabel.snp.bottom).offset(50.H)
            make.width.greaterThanOrEqualTo(180.W)
            make.height.equalTo(40)
        }
    }
}

