Pod::Spec.new do |s|

s.name         = "SLEmptyPage"
s.version      = "1.0.9"
s.swift_version  = "5.0"
s.summary      = "空状态页"
s.description  = "设置UITableView和UICollectionView没有展示信息时显示自定义的空状态页面"
s.homepage     = "https://github.com/2NU71AN9/SLEmptyPage" #项目主页，不是git地址
s.license      = { :type => "MIT", :file => "LICENSE" } #开源协议
s.author       = { "孙梁" => "1491859758@qq.com" }
s.platform     = :ios, "11.0"
s.source       = { :git => "https://github.com/2NU71AN9/SLEmptyPage.git", :tag => "v#{s.version}" } #存储库的git地址，以及tag值
s.source_files  =  "SLEmptyPage/EmptyPage/*.swift" #需要托管的源代码路径
s.resources     = 'SLEmptyPage/EmptyPage/*.bundle'
s.requires_arc = true #是否支持ARC
s.dependency "SnapKit"

end
