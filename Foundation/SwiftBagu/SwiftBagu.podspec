Pod::Spec.new do |spec|
  # 基础信息
  spec.name = "SwiftBagu"
  spec.version = "0.0.1"
  spec.source = { :git => "https://github.com/ryderfang/iOSBagu.git", :tag => "#{spec.version}" } 
  # 描述信息
  spec.summary = "SwiftBagu"
  spec.description = <<-DESC
    静态库
  DESC
  spec.homepage = "https://github.com/ryderfang/iOSBagu"
  spec.license = { :type => "NONE", :text => "个人项目" }
  spec.author = {
      "ryder" => "fray9166@gmail.com"
  }
  # 源码，头文件，库文件
  spec.swift_version = '5.0'
  spec.source_files = "SwiftBagu/*.{swift,m,mm}", "SwiftBagu/*/*.{swift,m,mm}"

  # for framework
  # spec.vendored_frameworks = 'SwiftBagu.framework'
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
