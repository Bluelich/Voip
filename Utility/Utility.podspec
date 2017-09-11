Pod::Spec.new do |spec|
  spec.name         = "Utility"
  spec.version      = "0.0.1"
  spec.summary      = "Handle some data."
  spec.description  = <<-DESC
                    Handle the data.
                   DESC
  spec.homepage     = "http://www.bluelich.com"
  spec.license      = "MIT"
  spec.author             = { "Bluelich" => "bluelich@qq.com" }
  spec.platform     = :ios, "8.0"
  spec.requires_arc = true
  spec.source       = { :git => "", :tag => spec.version.to_s }
  spec.source_files = 'Sources/**/*.{h,m}'
  spec.resources    = ['Sources/**/*.xib']
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
  spec.xcconfig     = { "OTHER_CFLAGS" => "-ObjC", "ENABLE_BITCODE" => "NO" }
end
