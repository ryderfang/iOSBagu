Pod::Spec.new do |spec|
  # 基础信息
  spec.name = "BGStaticLib"
  spec.version = "0.0.1"
  spec.source = { :git => "https://github.com/ryderfang/iOSBagu.git", :tag => "#{spec.version}" } 
  # 描述信息
  spec.summary = "BGStaticLib"
  spec.description = <<-DESC
    静态库
  DESC
  spec.homepage = "https://github.com/ryderfang/iOSBagu"
  spec.license = { :type => "NONE", :text => "个人项目" }
  spec.author = {
      "ryder" => "fray9166@gmail.com"
  }
  # 源码，头文件，库文件
  spec.source_files = "BGStaticLib/BGStaticLib/*.{h,m,mm,c}"
  # spec.public_header_files = "BGStaticLib/BGStaticLib/*.h"

  # for framework
  # spec.vendored_frameworks = 'BGStaticLib.framework'
  spec.user_target_xcconfig = {
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'
  }

  # 编译选项
  # spec.platform = :ios, "9.0"
  spec.platform = :osx, "10.9"
  # 依赖
  # spec.libraries = 'c++'
  # spec.dependency ""
  end
