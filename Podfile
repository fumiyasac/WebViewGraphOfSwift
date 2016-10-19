platform :ios, '9.0'
swift_version = '3.0'
use_frameworks!
target 'WebViewGraphOfSwift' do
  pod 'RealmSwift'

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '3.0'
      end
    end
  end
end
