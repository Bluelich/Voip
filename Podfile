# Uncomment the next line to define a global platform for your project
platform :ios, '8.0'
inhibit_all_warnings!

target 'Voip' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  # use_frameworks!

  # Pods for Voip
  pod 'Utility',        :path => './Utility'
  pod 'SDKVersion',     :path => './SDKVersion'
  pod 'AVSDK',          :path => './CallSDK/AVSDK/'
  pod 'ILiveSDK',       :path => './CallSDK/ILiveSDK/'
  pod 'IMSDK',          :path => './CallSDK/IMSDK/'
  pod 'QAVEffect',      :path => './CallSDK/QAVEffect/'
  pod 'TILCallSDK',     :path => './CallSDK/TILCallSDK/'
  pod 'JPush',          '~> 3.0.6'
  pod 'NWPusher',       '~> 0.7.0'
  pod 'YYModel',        '~> 1.0.4'
  target 'VoipTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'VoipUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
