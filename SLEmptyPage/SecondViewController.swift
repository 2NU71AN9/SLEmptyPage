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
        return tableView
    }()

    var dateArray = ["1", "2", "下拉", "1", "2", "下拉", "1", "2", "下拉", "1", "2", "下拉", "1", "2", "下拉", "1", "2", "下拉", "1", "2", "下拉", "1", "2", "下拉"]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.emptyViewEnable = false
//        tableView.emptyView?.topMargen = 300
        tableView.emptyView?.actionTitle = "重新加载"
        tableView.emptyView?.refreshAction = { [weak self] in
            print("重新加载")
            self?.dateArray = ["1", "2", "下拉", "1", "2", "下拉", "1", "2", "下拉", "1", "2", "下拉", "1", "2", "下拉", "1", "2", "下拉", "1", "2", "下拉", "1", "2", "下拉"]
            self?.tableView.reloadData()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.snp.makeConstraints { (make) in
            make.size.equalToSuperview()
            make.center.equalToSuperview()
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
