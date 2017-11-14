# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'
inhibit_all_warnings!

target 'Voip' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  # use_frameworks!

  # Pods for Voip
  pod 'Utility',             :path => './Utility'
  pod 'SDKVersion',          :path => './SDKVersion'
  pod 'AVSDK',               :path => './CallSDK/AVSDK/'
  pod 'ILiveSDK',            :path => './CallSDK/ILiveSDK/'
  pod 'IMSDK',               :path => './CallSDK/IMSDK/'
  pod 'QAVEffect',           :path => './CallSDK/QAVEffect/'
  pod 'TILCallSDK',          :path => './CallSDK/TILCallSDK/'
#  pod 'GoogleWebRTC_Helper', :path => './GoogleWebRTC/Helper'
  pod 'GoogleWebRTC'       #,:path => './GoogleWebRTC'
  pod 'SocketRocket'
  pod 'JPush'
  pod 'NWPusher'
  pod 'YYModel'
  target 'VoipTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'VoipUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
