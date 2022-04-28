workspace 'BAGU'
platform :osx, '10.9'
inhibit_all_warnings!
# 解决 swift 静态库引用问题
use_frameworks! :linkage => :static

install! 'cocoapods', :warn_for_unused_master_specs_repo => false

def commonPods
    pod 'BGStaticLib', :path => './StaticLib'
    pod 'SwiftBagu', :path => './Foundation/SwiftBagu'
end

target 'ObjcBagu' do
    commonPods
    project 'Foundation/ObjcBagu/ObjcBagu.xcodeproj'
end

target 'UIKitBagu' do
    project 'UIKit/UIKitBagu/UIKitBagu.xcodeproj'
end

