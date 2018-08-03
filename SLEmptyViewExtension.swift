//
//  SLEmptyViewExtension.swift
//  XiaocaoPlusNew
//
//  Created by X.T.X on 2018/1/17.
//  Copyright © 2018年 shiliukeji. All rights reserved.
//

import UIKit

extension UIScrollView {
    private struct EmptyViewKey {
        static let emptyViewKey = UnsafeRawPointer(bitPattern:"scroll_emptyViewKey".hashValue)!
        static let oldEmptyViewKey = UnsafeRawPointer(bitPattern:"scroll_oldEmptyViewKey".hashValue)!
    }
    
    var oldEmptyView: UIView? {
        get {
            return objc_getAssociatedObject(self, EmptyViewKey.oldEmptyViewKey) as? UIView
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
    var emptyView: UIView? {
        get {
            return objc_getAssociatedObject(self, EmptyViewKey.emptyViewKey) as? UIView
        }
        set {
            if let emptyView = newValue {
                self.oldEmptyView = self.emptyView
                objc_setAssociatedObject(self, EmptyViewKey.emptyViewKey, emptyView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
}

extension UITableView {
    
    @objc func table_emptyLayoutSubviews() {
        table_emptyLayoutSubviews()
        guard let emptyView = emptyView,
            bounds != emptyView.frame else { return }
        emptyView.frame = bounds
    }
    
    @objc func table_emptyInsertRows(at indexPath: [IndexPath], with animation: UITableViewRowAnimation) {
        setEmptyView { [weak self] in
            guard let base = self else { return }
            base.table_emptyInsertRows(at: indexPath, with: animation)
        }
    }
    
    @objc func table_emptyDeleteRows(at indexPath: [IndexPath], with animation: UITableViewRowAnimation) {
        setEmptyView { [weak self] in
            guard let base = self else { return }
            base.table_emptyDeleteRows(at: indexPath, with: animation)
        }
    }
    
    @objc func table_emptyInsertSections(_ sections: IndexSet, with animation: UITableViewRowAnimation) {
        setEmptyView { [weak self] in
            guard let base = self else { return }
            base.table_emptyInsertSections(sections, with: animation)
        }
    }
    
    @objc func table_emptyDeleteSections(_ sections: IndexSet, with animation: UITableViewRowAnimation) {
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
            self.table_emptyReloadData()
        }
    }
    
    func setEmptyView(event: () -> ()) {
        if frame.width == 0 || frame.height == 0 {
            event()
            return
        }
        guard let dataSource = dataSource,
           let sectionCount = dataSource.numberOfSections?(in: self) else { return }
        
        var isHasRows = false
        
        for index in 0 ..< sectionCount {
            if dataSource.tableView(self, numberOfRowsInSection: index) != 0 {
                isHasRows = true
                break
            }
        }
    
        isScrollEnabled = isHasRows
        oldEmptyView?.removeFromSuperview()
        if isHasRows {
            emptyView?.removeFromSuperview()
            event()
            return
        }
    
        event()
        
        if let emptyView = emptyView as? SLEmptyView {
            /// 无网络连接时展示无网络状态页面
            emptyView.emptyType = SLNetworkStatusManager.shared.networkStatus == .notReachable
                ? .noService : emptyView.emptyType
        }
        emptyView?.frame = bounds
        addSubview(emptyView ?? UIView())
    }
}

extension UICollectionView {
    
    @objc func coll_emptyLayoutSubviews() {
        coll_emptyLayoutSubviews()
        guard let emptyView = emptyView, bounds != emptyView.frame else{ return }
        emptyView.frame = bounds
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
        setEmptyView { [weak self] in
            guard let base = self else { return }
            base.coll_emptyReloadData()
        }
    }
    
    func setEmptyView(event: () -> ()) {
        if frame.size.width == 0 || frame.size.height == 0 { return }
        guard let dataSource = dataSource else { return }
        guard let sectionCount = dataSource.numberOfSections?(in: self) else { return }
        
        var isHasRows = false
        for index in 0 ..< sectionCount {
            if dataSource.collectionView(self, numberOfItemsInSection: index) != 0 {
                isHasRows = true
                break
            }
        }
        
        isScrollEnabled = isHasRows
        oldEmptyView?.removeFromSuperview()
        
        if isHasRows {
            emptyView?.removeFromSuperview()
            coll_emptyReloadData()
            return
        }
        
        coll_emptyReloadData()
        
        if let view = emptyView as? SLEmptyView  {
            /// 无网络连接时展示无网络状态页面
            view.emptyType = SLNetworkStatusManager.shared.networkStatus == .notReachable
                ? .noService : view.emptyType
        }
        emptyView?.frame = bounds
        addSubview(emptyView ?? UIView())
    }
    
}
