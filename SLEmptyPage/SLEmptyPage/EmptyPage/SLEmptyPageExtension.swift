//
//  SLEmptyPageExtension.swift
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
        static let emptyViewEnableKey = UnsafeRawPointer(bitPattern:"scroll_emptyViewEnableKey".hashValue)!
    }
    
    var oldEmptyView: SLEmptyView? {
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
    var emptyView: SLEmptyView? {
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
    var emptyViewEnable: Bool? {
        get {
            return objc_getAssociatedObject(self, EmptyViewKey.emptyViewEnableKey) as? Bool
        }
        set {
            if let value = newValue {
                objc_setAssociatedObject(self, EmptyViewKey.emptyViewEnableKey, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
}

extension UITableView {
    
    @objc func table_emptyLayoutSubviews() {
        table_emptyLayoutSubviews()
        if emptyView == nil {
            emptyView = SLEmptyView()
        }
        emptyView?.frame = bounds
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
        emptyView?.frame = bounds
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
        
        oldEmptyView?.removeFromSuperview()
        if isHasRows {
            emptyView?.removeFromSuperview()
            event()
            return
        }
        
        event()
        
        if emptyView != nil && emptyViewEnable ?? true {
            isScrollEnabled = false
            addSubview(emptyView!)
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
        
        oldEmptyView?.removeFromSuperview()
        if isHasRows {
            emptyView?.removeFromSuperview()
            event()
            return
        }
        
        event()
        
        if emptyView != nil && emptyViewEnable ?? true {
            isScrollEnabled = false
            addSubview(emptyView!)
        }
    }
}