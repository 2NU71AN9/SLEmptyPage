//
//  SLEmptyPageExtension.swift
//  XiaocaoPlusNew
//
//  Created by X.T.X on 2018/1/17.
//  Copyright © 2018年 shiliukeji. All rights reserved.
//

import UIKit
import WebKit

public extension UIScrollView {
    private struct EmptyViewKey {
        static let emptyViewKey = UnsafeRawPointer(bitPattern: "scroll_emptyViewKey".hashValue)!
        static let oldEmptyViewKey = UnsafeRawPointer(bitPattern: "scroll_oldEmptyViewKey".hashValue)!
        static let emptyViewEnableKey = UnsafeRawPointer(bitPattern: "scroll_emptyViewEnableKey".hashValue)!
        static let isLoadingKey = UnsafeRawPointer(bitPattern: "scroll_isLoading".hashValue)!
        static let isLoadingEnableKey = UnsafeRawPointer(bitPattern: "scroll_isLoadingEnable".hashValue)!
        static let reloadTime = UnsafeRawPointer(bitPattern: "scroll_reloadTime".hashValue)!
    }

    @objc var oldEmptyView: SLEmptyView? {
        get {
            return objc_getAssociatedObject(self, EmptyViewKey.oldEmptyViewKey) as? SLEmptyView
        }
        set {
            // 防止多次设置emptyView
            if oldEmptyView?.superview != nil { return }
            if let emptyView = newValue {
                objc_setAssociatedObject(self, EmptyViewKey.oldEmptyViewKey, emptyView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }

    /// tableView和collectionView必须实现有多少个section的协议
    @objc var emptyView: SLEmptyView? {
        get {
            // emptyView为空时自动创建一个,使每个UIScrollView必有一个emptyView
            var view = objc_getAssociatedObject(self, EmptyViewKey.emptyViewKey) as? SLEmptyView
            if view == nil {
                view = SLEmptyView.loadView()
                self.oldEmptyView = view
                objc_setAssociatedObject(self, EmptyViewKey.emptyViewKey, view, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return view
        }
        set {
            if let emptyView = newValue {
                self.oldEmptyView = self.emptyView
                objc_setAssociatedObject(self, EmptyViewKey.emptyViewKey, emptyView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }

    /// 控制显不显示emptyView
    @objc var emptyViewEnable: Bool {
        get {
            return objc_getAssociatedObject(self, EmptyViewKey.emptyViewEnableKey) as? Bool ?? true
        }
        set {
            objc_setAssociatedObject(self, EmptyViewKey.emptyViewEnableKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    /// 是否在加载阶段
    @objc var isLoading: Bool {
        get {
            return objc_getAssociatedObject(self, EmptyViewKey.isLoadingKey) as? Bool ?? true
        }
        set {
            objc_setAssociatedObject(self, EmptyViewKey.isLoadingKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
            if emptyView?.isLoading != newValue { emptyView?.isLoading = newValue }
        }
    }
    /// 控制是否在加载阶段
    @objc var isLoadingEnable: Bool {
        get {
            return objc_getAssociatedObject(self, EmptyViewKey.isLoadingEnableKey) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, EmptyViewKey.isLoadingEnableKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    @objc var reloadTime: Int {
        get {
            return objc_getAssociatedObject(self, EmptyViewKey.reloadTime) as? Int ?? 0
        }
        set {
            objc_setAssociatedObject(self, EmptyViewKey.reloadTime, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
}

extension UITableView {

    @objc func table_emptyLayoutSubviews() {
        table_emptyLayoutSubviews()
        if emptyView == nil {
            emptyView = SLEmptyView.loadView()
        }
        setEmptyView {}
    }

    @objc func table_emptyInsertRows(at indexPath: [IndexPath], with animation: UITableView.RowAnimation) {
        setEmptyView { [weak self] in
            guard let base = self else { return }
            base.table_emptyInsertRows(at: indexPath, with: animation)
        }
    }

    @objc func table_emptyDeleteRows(at indexPath: [IndexPath], with animation: UITableView.RowAnimation) {
        setEmptyView { [weak self] in
            guard let base = self else { return }
            base.table_emptyDeleteRows(at: indexPath, with: animation)
        }
    }

    @objc func table_emptyInsertSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) {
        setEmptyView { [weak self] in
            guard let base = self else { return }
            base.table_emptyInsertSections(sections, with: animation)
        }
    }

    @objc func table_emptyDeleteSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) {
        setEmptyView { [weak self] in
            guard let base = self else { return }
            base.table_emptyDeleteSections(sections, with: animation)
        }
    }

    @objc func table_emptyReloadData() {
        reloadTime += 1
        if reloadTime > 1 { isLoading = false }
        if emptyView != nil {
            setEmptyView {
                [weak self] in
                guard let base = self else { return }
                base.table_emptyReloadData()
            }
        } else {
            emptyView = SLEmptyView.loadView()
            self.table_emptyReloadData()
        }
    }
}

extension UICollectionView {

    @objc func coll_emptyLayoutSubviews() {
        coll_emptyLayoutSubviews()
        if emptyView == nil {
            emptyView = SLEmptyView.loadView()
        }
    }

    @objc func coll_emptyInsertItems(at indexPaths: [IndexPath]) {
        setEmptyView { [weak self] in
            guard let base = self else { return }
            base.coll_emptyInsertItems(at: indexPaths)
        }
    }

    @objc func coll_emptyDeleteItems(at indexPaths: [IndexPath]) {
        setEmptyView { [weak self] in
            guard let base = self else { return }
            base.coll_emptyDeleteItems(at: indexPaths)
        }
    }

    @objc func coll_emptyInsertSections(_ sections: IndexSet) {
        setEmptyView { [weak self] in
            guard let base = self else { return }
            base.coll_emptyInsertSections(sections)
        }
    }

    @objc func coll_emptyDeleteSections(_ sections: IndexSet) {
        setEmptyView { [weak self] in
            guard let base = self else { return }
            base.coll_emptyDeleteSections(sections)
        }
    }

    @objc func coll_emptyReloadData() {
        reloadTime += 1
        if reloadTime > 1 { isLoading = false }
        if emptyView != nil {
            setEmptyView { [weak self] in
                guard let base = self else { return }
                base.coll_emptyReloadData()
            }
        } else {
            self.coll_emptyReloadData()
        }
    }
}

extension UITableView {
    private func setEmptyView(event: () -> Void) {
        if frame.width == 0 || frame.height == 0 {
            event()
            return
        }
        guard let dataSource = dataSource,
            let sectionCount = dataSource.numberOfSections?(in: self) else {
                event()
                return
        }

        var isHasRows = false

        for index in 0 ..< sectionCount {
            if dataSource.tableView(self, numberOfRowsInSection: index) != 0 {
                isHasRows = true
                break
            }
        }

        if isHasRows {
            oldEmptyView?.removeFromSuperview()
            emptyView?.removeFromSuperview()
            event()
            return
        }

        event()

        if let emptyView = emptyView, emptyViewEnable, subviews.contains(emptyView) == false {
            emptyView.isLoading = isLoadingEnable && isLoading
            addSubview(emptyView)
        }
    }
}

extension UICollectionView {
    private func setEmptyView(event: () -> Void) {
        if frame.size.width == 0 || frame.size.height == 0 {
            event()
            return
        }
        guard let dataSource = dataSource,
            let sectionCount = dataSource.numberOfSections?(in: self) else {
                event()
                return
        }

        var isHasRows = false

        for index in 0 ..< sectionCount {
            if dataSource.collectionView(self, numberOfItemsInSection: index) != 0 {
                isHasRows = true
                break
            }
        }

        if isHasRows {
            oldEmptyView?.removeFromSuperview()
            emptyView?.removeFromSuperview()
            event()
            return
        }

        event()

        if let emptyView = emptyView, emptyViewEnable, subviews.contains(emptyView) == false {
            emptyView.isLoading = isLoadingEnable && isLoading
            addSubview(emptyView)
        }
    }
}

public extension WKWebView {

    private struct EmptyViewKey {
        static let emptyViewKey = UnsafeRawPointer(bitPattern: "webView_emptyViewKey".hashValue)!
        static let oldEmptyViewKey = UnsafeRawPointer(bitPattern: "webView_oldEmptyViewKey".hashValue)!
        static let requestKey = UnsafeRawPointer(bitPattern: "webView_requestKey".hashValue)!
    }

    @objc var oldEmptyView: SLEmptyView? {
        get {
            return objc_getAssociatedObject(self, EmptyViewKey.oldEmptyViewKey) as? SLEmptyView
        }
        set {
            // 防止多次设置emptyView
            if oldEmptyView?.superview != nil { return }
            if let emptyView = newValue {
                objc_setAssociatedObject(self, EmptyViewKey.oldEmptyViewKey, emptyView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }

    @objc var emptyView: SLEmptyView? {
        get {
            return objc_getAssociatedObject(self, EmptyViewKey.emptyViewKey) as? SLEmptyView
        }
        set {
            if let emptyView = newValue {
                self.oldEmptyView = self.emptyView
                objc_setAssociatedObject(self, EmptyViewKey.emptyViewKey, emptyView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }

    @objc var sl_request: URLRequest? {
        get {
            return objc_getAssociatedObject(self, EmptyViewKey.requestKey) as? URLRequest
        }
        set {
            if let request = newValue {
                objc_setAssociatedObject(self, EmptyViewKey.requestKey, request, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
}

public extension WKWebView {
    func sl_load(_ request: URLRequest) {
        sl_request = request
        load(request)
    }

    func showEmptyView() {
        if emptyView == nil {
            let view = SLEmptyView.loadView()
            view.text = "加载失败"
            view.actionTitle = "重新加载"
            view.refreshAction = { [weak self] in
                if self?.url != nil {
                    self?.reload()
                } else if let request = self?.sl_request {
                    self?.load(request)
                }
            }
            addSubview(view)
            emptyView = view
        } else {
            addSubview(emptyView!)
        }
    }

    func hideEmptyView() {
        emptyView?.removeFromSuperview()
    }
}
