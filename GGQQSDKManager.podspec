Pod::Spec.new do |s|
  s.name             = 'GGQQSDKManager'
  s.version          = '0.1.0'
  s.summary          = 'A reusable pod library for QQ SDK'

  s.description      = <<-DESC
封装QQSDK，提供登录、分享等功能的便捷接口。
                       DESC

  s.homepage         = 'https://github.com/github6022244/GGQQSDKManager.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Developer' => 'developer@example.com' }
  s.source           = { :git => 'https://github.com/github6022244/GGQQSDKManager.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'

  s.source_files = 'GGQQSDKManager/Classes/*.{h,m}'
  
  s.exclude_files = 'GGQQSDKManager/Classes/TencentOpenAPI.xcframework/**/*'
  
  s.public_header_files = 'GGQQSDKManager/Classes/*.h'
  
  s.resources = ['GGQQSDKManager/Assets/**/*.png']

  s.vendored_frameworks = 'GGQQSDKManager/Classes/TencentOpenAPI.xcframework'

  s.frameworks = 'Security', 'SystemConfiguration', 'CoreGraphics', 'CoreTelephony', 'Foundation', 'UIKit', 'WebKit'
  
  s.libraries = 'iconv', 'sqlite3', 'z', 'c++'

  s.xcconfig = {
    'OTHER_LDFLAGS' => '-ObjC -all_load',
    'ENABLE_BITCODE' => 'NO'
  }

  s.pod_target_xcconfig = {
    'CODE_SIGNING_ALLOWED' => 'NO',
    'CODE_SIGNING_REQUIRED' => 'NO',
    'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES'  # 移到这里
  }

  s.requires_arc = true
  
  s.swift_versions = ['5.0']
  
end
