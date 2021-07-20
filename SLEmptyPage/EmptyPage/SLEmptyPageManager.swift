//
//  SLEmptyPageManager.swift
//  XiaocaoPlusNew
//
//  Created by X.T.X on 2018/1/17.
//  Copyright © 2018年 shiliukeji. All rights reserved.
//

import UIKit

public class SLEmptyPageManager: NSObject {

    /// 加载时提示内容, nil时隐藏label
    @objc public static var defaultLoadingText: String? = "正在加载中..."
    /// 空状态展示图片
    @objc public static var defaultImage = UIImage(named: "emptyImage", in: SLEmptyView.loadBundle(), compatibleWith: nil)
    /// 空状态提示内容, nil时隐藏label
    @objc public static var defaultText: String? = "没有找到数据哦~"
    /// 按钮文字, nil时隐藏按钮
    @objc public static var defaultActionTitle: String?
    /// 按钮背景颜色
    @objc public static var defaultActionBackColor: UIColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
    /// EmptyView背景颜色
    @objc public static var defaultEmptyViewBgColor: UIColor = {
        if #available(iOS 13.0, *) {
            return UIColor.systemBackground
        } else {
            return .white
        }
    }()

    @objc public static var enable: Bool = false {
        didSet {
            enable ? SLEmptyPageManager.begin() : ()
        }
    }
    private static var exchanged = false // 是否已经进行过
    private static func begin() {
        if exchanged { return }
        exchanged = true

        RunTime.exchangeMethod(selector: #selector(UITableView.reloadData),
                               replace: #selector(UITableView.table_emptyReloadData),
                               class: UITableView.self)

        RunTime.exchangeMethod(selector: #selector(UITableView.layoutSubviews),
                               replace: #selector(UITableView.table_emptyLayoutSubviews),
                               class: UITableView.self)

        RunTime.exchangeMethod(selector: #selector(UITableView.insertRows(at:with:)),
                               replace: #selector(UITableView.table_emptyInsertRows(at:with:)),
                               class: UITableView.self)

        RunTime.exchangeMethod(selector: #selector(UITableView.deleteRows(at:with:)),
                               replace: #selector(UITableView.table_emptyDeleteRows(at:with:)),
                               class: UITableView.self)

        RunTime.exchangeMethod(selector: #selector(UITableView.insertSections(_:with:)),
                               replace: #selector(UITableView.table_emptyInsertSections(_:with:)),
                               class: UITableView.self)

        RunTime.exchangeMethod(selector: #selector(UITableView.deleteSections(_:with:)),
                               replace: #selector(UITableView.table_emptyDeleteSections(_:with:)),
                               class: UITableView.self)

        RunTime.exchangeMethod(selector: #selector(UICollectionView.reloadData),
                               replace: #selector(UICollectionView.coll_emptyReloadData),
                               class: UICollectionView.self)

        RunTime.exchangeMethod(selector: #selector(UICollectionView.layoutSubviews),
                               replace: #selector(UICollectionView.coll_emptyLayoutSubviews),
                               class: UICollectionView.self)

        RunTime.exchangeMethod(selector: #selector(UICollectionView.insertItems(at:)),
                               replace: #selector(UICollectionView.coll_emptyInsertItems(at:)),
                               class: UICollectionView.self)

        RunTime.exchangeMethod(selector: #selector(UICollectionView.deleteItems(at:)),
                               replace: #selector(UICollectionView.coll_emptyDeleteItems(at:)),
                               class: UICollectionView.self)

        RunTime.exchangeMethod(selector: #selector(UICollectionView.insertSections(_:)),
                               replace: #selector(UICollectionView.coll_emptyInsertSections(_:)),
                               class: UICollectionView.self)

        RunTime.exchangeMethod(selector: #selector(UICollectionView.deleteSections(_:)),
                               replace: #selector(UICollectionView.coll_emptyDeleteSections(_:)),
                               class: UICollectionView.self)
    }
}
