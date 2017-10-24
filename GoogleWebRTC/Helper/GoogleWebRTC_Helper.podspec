Pod::Spec.new do |spec|
  spec.name         = "GoogleWebRTC_Helper"
  spec.version      = "1.0"
  spec.summary      = "WebRTC iOS SDK Helper"
  spec.description  = <<-DESC
                    Auto import the expected frameworks.
                   DESC
  spec.homepage     = "https://www.bluelich.com"
  spec.license      = "MIT"
  spec.author       = { "Bluelich" => "bluelich@qq.com" }
  spec.platform     = :ios, "9.0"
  spec.source       = { :path => "./Sources" }
  spec.preserve_paths = [ "./Sources/README.md" ]
  spec.frameworks   = "Security", 
					            "CFNetwork",
        					    "GLKit",
        					    "AudioToolbox",
        					    "AVFoundation",
        					    "CoreAudio",
        					    "CoreMedia",
        					    "CoreVideo",
        					    "CoreMedia",
        					    "CoreGraphics",
        					    "OpenGLES",
					            "QuartzCore"
  spec.libraries    = "stdc++.6", 
  					          "sqlite3",
					            "c++", 
					            "icucore"
  spec.xcconfig     = { "OTHER_CFLAGS" => "-ObjC", "ENABLE_BITCODE" => "NO" }
end