
Pod::Spec.new do |s|


  s.name         = "EasyNavigation"
  s.version      = "1.0.4"
  s.summary      = "一款超级简单的导航条管理工具,没有UINavigationBar和UINavigationItem这两个类。完全是对UIView的操作。 所有操作都能一行代码，操作之间完全独立，互不影响。"
  s.description  = "一款超级简单的导航条管理工具。完全自定义导航条。没有UINavigationBar和UINavigationItem这两个类。完全是对UIView的操作。 所有操作都能一行代码，操作之间完全独立，互不影响。集成简单，使用简单。"
  s.homepage     = "https://github.com/chenliangloveyou/EasyNavigation"
  s.license      = "MIT"
  s.author       = { "chenliangloveyou" => "ios_elite@163.com" }
  s.source       = { :git => "https://github.com/chenliangloveyou/EasyNavigation.git", :commit => "7b9344824994477d3ffae056aa20dbeba801a9ca" }
  s.source_files = "EasyNavigation/*.{h,m}"
  s.resource     = 'EasyNavigation/EasyNavButton.bundle'
  # s.public_header_files = "Classes/**/*.h"
  s.ios.deployment_target= '7.0'

 
end
