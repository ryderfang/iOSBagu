workspace 'BAGU'
inhibit_all_warnings!
#! 解决 swift 静态库引用问题
use_frameworks! :linkage => :static
install! 'cocoapods', :warn_for_unused_master_specs_repo => false

def commonPods
  pod 'BGStaticLib', :path => './StaticLib'
  pod 'SwiftBagu', :path => './Foundation/SwiftBagu'
end

#! Mac console
target 'ObjcBagu' do
  platform :osx, '10.9'
  commonPods
  project 'Foundation/ObjcBagu/ObjcBagu.xcodeproj'
end

#! iOS
def iosPods
  pod 'AFNetworking', :path => 'Vendor/AFNetworking'
  pod 'SnapKit', :path => 'Vendor/SnapKit'
end

target 'UIKitBagu' do
  platform :ios, '10.0'
  iosPods
  project 'UIKit/UIKitBagu/UIKitBagu.xcodeproj'
end

