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
        static let emptyViewKey = UnsafeRawPointer(bitPattern:"scroll_emptyViewKey".hashValue)!
        static let oldEmptyViewKey = UnsafeRawPointer(bitPattern:"scroll_oldEmptyViewKey".hashValue)!
        static let emptyViewEnableKey = UnsafeRawPointer(bitPattern:"scroll_emptyViewEnableKey".hashValue)!
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
                view = SLEmptyView()
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
            objc_setAssociatedObject(self, EmptyViewKey.emptyViewEnableKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension UITableView {
    
    @objc func table_emptyLayoutSubviews() {
        table_emptyLayoutSubviews()
        if emptyView == nil {
            emptyView = SLEmptyView()
        }
        emptyView?.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
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
        if emptyView != nil {
            setEmptyView {
                [weak self] in
                guard let base = self else { return }
                base.table_emptyReloadData()
            }
        } else {
            emptyView = SLEmptyView()
            self.table_emptyReloadData()
        }
    }
}

extension UICollectionView {
    
    @objc func coll_emptyLayoutSubviews() {
        coll_emptyLayoutSubviews()
        if emptyView == nil {
            emptyView = SLEmptyView()
        }
        emptyView?.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
    }
    
    @objc func coll_emptyInsertItems(at indexPaths: [IndexPath]){
        setEmptyView { [weak self] in
            guard let base = self else { return }
            base.coll_emptyInsertItems(at: indexPaths)
        }
    }
    
    @objc func coll_emptyDeleteItems(at indexPaths: [IndexPath]){
        setEmptyView { [weak self] in
            guard let base = self else { return }
            base.coll_emptyDeleteItems(at: indexPaths)
        }
    }
    
    @objc func coll_emptyInsertSections(_ sections: IndexSet){
        setEmptyView { [weak self] in
            guard let base = self else { return }
            base.coll_emptyInsertSections(sections)
        }
    }
    
    @objc func coll_emptyDeleteSections(_ sections: IndexSet){
        setEmptyView { [weak self] in
            guard let base = self else { return }
            base.coll_emptyDeleteSections(sections)
        }
    }
    
    @objc func coll_emptyReloadData() {
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
    private func setEmptyView(event: () -> ()) {
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
            addSubview(emptyView)
        }
    }
}

extension UICollectionView {
    private func setEmptyView(event: () -> ()) {
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
            addSubview(emptyView)
        }
    }
}

public extension WKWebView {
    
    private struct EmptyViewKey {
        static let emptyViewKey = UnsafeRawPointer(bitPattern:"webView_emptyViewKey".hashValue)!
        static let oldEmptyViewKey = UnsafeRawPointer(bitPattern:"webView_oldEmptyViewKey".hashValue)!
        static let requestKey = UnsafeRawPointer(bitPattern:"webView_requestKey".hashValue)!
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
 
extension WKWebView {
    public func showEmptyView() {
        if emptyView == nil {
            let view = SLEmptyView()
            view.text = "加载失败"
            view.actionTitle = "重新加载"
            view.tapAction = { [weak self] in
                if self?.url != nil {
                    self?.reload()
                } else if let request = self?.sl_request {
                    self?.load(request)
                }
            }
            view.frame = bounds
            addSubview(view)
            emptyView = view
        } else {
            addSubview(emptyView!)
        }
    }
    public func hideEmptyView() {
        emptyView?.removeFromSuperview()
    }
    
    @objc func sl_load(_ request: URLRequest) {
        sl_request = request
        load(request)
    }
}
