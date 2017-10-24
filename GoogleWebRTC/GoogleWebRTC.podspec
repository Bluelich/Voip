Pod::Spec.new do |spec|
  spec.name         = "GoogleWebRTC"
  spec.version      = "1.1.20266"
  spec.summary      = "WebRTC iOS SDK"
  spec.description  = <<-DESC
                    WebRTC is a free, open project that provides browsers and mobile applications with Real-Time Communications (RTC) capabilities via simple APIs.
                   DESC
  spec.homepage     = "https://webrtc.org/"
  spec.license      = { :type => 'Multiple', :file => 'LICENSE.txt' }
  spec.author       = "The WebRTC project authors."
  spec.platform     = :ios, "9.0"
  spec.requires_arc = true
  spec.preserve_paths = [ "LICENSE.md","README.md" ]
  spec.source       = { :http => 'https://dl.google.com/dl/cpdc/10797d3d24433975/GoogleWebRTC-1.1.20266.tar.gz' }
  spec.ios.vendored_frameworks = "Frameworks/frameworks/WebRTC.framework"
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