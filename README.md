# SLEmptyPage
利用RunTime设置UITableView, UICollectionView, WebView没有展示信息时显示自定义的空状态页面

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
tableView.emptyView?.topMargen = 300 // 距离顶部多少, 默认-1, 在屏幕中间靠上
tableView.emptyView?.text = "暂无数据"
tableView.emptyView?.actionTitle = "重新加载"
tableView.emptyView?.refreshAction = { [weak self] in
        print("重新加载")
}
```
```
webView.sl_load(URLRequest(url: URL(string: "https://www.baidu.com")!))

// WKNavigationDelegate
func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
   webView.showEmptyView()
}
func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
   webView.hideEmptyView()
}
func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
   webView.hideEmptyView()
}
```
