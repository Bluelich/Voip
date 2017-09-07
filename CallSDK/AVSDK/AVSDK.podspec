Pod::Spec.new do |spec|
  spec.name         = "AVSDK"
  spec.version      = "1.9.2.17.28736"
  spec.summary      = "Handle some data."
  spec.description  = <<-DESC
                    Handle the data.
                   DESC
  spec.homepage     = "http://www.bluelich.com"
  spec.license      = "MIT"
  spec.author             = { "Bluelich" => "bluelich@qq.com" }
  spec.platform     = :ios, "8.0"
  spec.requires_arc = true
  spec.source       = { :git => "", :tag => '1.9.2.17.OpenSDK_1.9.2- 28736' }
  spec.ios.vendored_frameworks = 'Sources/*.framework'
  # s.resources = "Resources/*.png"
  spec.frameworks   = "Security", 
					  "Foundation",
					  "UIKit",
					  "CoreTelephony",
					  "CoreFoundation",
					  "CFNetwork",
					  "AssetsLibrary",
					  "CoreGraphics",
					  "CoreMedia",
					  "SystemConfiguration",
					  "Accelerate",
					  "VideoToolbox",
					  "CoreVideo",
					  "AVFoundation"
  spec.libraries    = "stdc++.6", 
					  "c++", 
					  "bz2",
					  "z",
					  "iconv",
					  "resolv",
					  "sqlite3.0",
					  "protobuf"
  spec.xcconfig     = { "OTHER_CFLAGS" => "-ObjC" }
end
