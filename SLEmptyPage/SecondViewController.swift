//
//  SecondViewController.swift
//  SLEmptyPage
//
//  Created by RY on 2018/8/14.
//  Copyright © 2018年 SL. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.emptyViewEnable = false
//        tableView.emptyView?.topMargen = 300
//        tableView.isLoadingEnable = false
        tableView.emptyView?.actionTitle = "重新加载"
        tableView.emptyView?.refreshAction = { [weak self] in
            self?.loadData()
        }
        return tableView
    }()

    var dateArray: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        loadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.snp.makeConstraints { (make) in
            make.size.equalToSuperview()
            make.center.equalToSuperview()
        }
    }
    
    private func loadData() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.dateArray = [] //["1", "2", "下拉", "1", "2", "下拉", "1", "2", "下拉", "1", "2", "下拉", "1", "2", "下拉", "1", "2", "下拉", "1", "2", "下拉", "1", "2", "下拉"]
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}

extension SecondViewController: UITableViewDelegate, UITableViewDataSource {
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return dateArray.count
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            var cell = tableView.dequeueReusableCell(withIdentifier: "cellid")
            if cell == nil {
                cell = UITableViewCell(style: .value1, reuseIdentifier: "cellid")
            }
            cell?.textLabel?.text = dateArray[indexPath.row]
            return cell!
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 50
        }

        func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            dateArray.removeAll()
            tableView.reloadData()
        }
}
