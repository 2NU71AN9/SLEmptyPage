# SLEmptyPage
利用RunTime设置UITableView和UICollectionView没有展示信息时显示自定义的空状态页面

pod 'SLEmptyPage'

AppDelegate中添加以下代码
```
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        SLEmptyPageManager.enable = true
        return true
    }
```
