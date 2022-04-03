platform :ios, "12.0"

target 'Elated' do
  
  use_frameworks!
  
  pod 'FBSDKCoreKit/Swift'
  pod 'FBSDKLoginKit/Swift'
  pod 'FBSDKShareKit'
  pod 'Moya/RxSwift'
  pod 'RxRelay'
  pod 'RxCocoa'
  pod 'NSObject+Rx'
  pod 'Alamofire', '~> 4.3'
  pod 'SwiftyJSON', '~> 4.0'
  pod 'GoogleSignIn'
  pod 'lottie-ios', '~> 3.0.4'
  pod 'ViewPager-Swift'
  pod 'Firebase/Auth'
  pod 'Firebase/Analytics'
  pod 'Firebase/DynamicLinks'
  pod 'SnapKit', '~> 5.0.1'
  pod 'WARangeSlider'
  pod 'SpotifyLogin'
  pod 'IQKeyboardManagerSwift'
  pod 'NVActivityIndicatorView'
  pod 'Firebase/Crashlytics'
  pod 'SideMenu'
  pod 'iCarousel'
  pod 'PhoneNumberKit', '~> 3.3'
  pod 'Kingfisher', '~> 7.0'
  pod 'AMPopTip', '~> 4.6.0'
  pod "DragDropiOS"
  pod "SwiftSyllables"
  pod "FirebaseDatabase"
  pod "FirebaseStorage"

end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'dwarf'
    end
  end
end
