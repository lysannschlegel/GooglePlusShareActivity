Pod::Spec.new do |s|
  s.name         = 'GooglePlusShareActivity'
  s.version      = '0.2.10'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.summary      = 'An UIActivity subclass for Sharing on Google+'
  s.homepage     = 'http://github.com/lysannschlegel/GooglePlusShareActivity'
  s.authors      = { 'Lysann Schlegel' => 'http://github.com/lysannschlegel' }
  s.source       = { :git => 'https://github.com/lysannschlegel/GooglePlusShareActivity.git', :tag => s.version.to_s }

  s.source_files = 'GooglePlusShareActivity/*.{h,m}'
  s.resources    = 'GooglePlusShareActivity/*.png'
  s.frameworks   = 'Foundation', 'UIKit'
  s.requires_arc = true
  s.platform     = :ios, '6.0'

  s.dependency 'googleplus-ios-sdk', '~> 1.7.1'
  s.xcconfig     = { 'FRAMEWORK_SEARCH_PATHS' => "\"$(PODS_ROOT)/googleplus-ios-sdk/**/\"" }
end
