# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'VimeoPlayer' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  def common_pods_for_all_targets
    pod 'RxSwift'
    pod 'RxCocoa'
    pod 'RxFlow'
    pod 'RxNuke'
    pod 'RxAVFoundation'
  end
  
  def common_pods_for_test_targets
    pod 'Quick'
    pod 'Nimble'
    pod 'RxTest'
  end

  
  # Pods for VimeoPlayer
  common_pods_for_all_targets

  
  target 'VimeoPlayerTests' do
    inherit! :search_paths
    # Pods for testing
    common_pods_for_all_targets
    common_pods_for_test_targets
  end

  target 'VimeoPlayerUITests' do
    # Pods for testing
    common_pods_for_all_targets
    common_pods_for_test_targets
  end

end
