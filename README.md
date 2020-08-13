# SLEmptyPage
利用RunTime设置UITableView和UICollectionView没有展示信息时显示自定义的空状态页面

```
pod 'SLEmptyPage'
```

AppDelegate中添加以下代码
```
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
     SLEmptyPageManager.enable = true
     return true
}
```
```
tableView.emptyViewEnable = false // 关闭
tableView.emptyView?.offsetY = 300
tableView.emptyView?.text = "暂无数据"
tableView.emptyView?.actionTitle = "重新加载"
tableView.emptyView?.tapAction = { [weak self] in
        print("重新加载")
}
```
