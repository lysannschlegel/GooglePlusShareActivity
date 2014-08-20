Pod::Spec.new do |s|
  s.name         = "GooglePlusShareActivity"
  s.version      = "0.2.6"
  s.license      = 'MIT'
  s.summary      = "An UIActivity subclass for Sharing on Google+"
  s.homepage     = "http://github.com/lysannschlegel/GooglePlusShareActivity"
  s.author       = { "Lysann Schlegel" => "http://github.com/lysannschlegel" }
  s.source       = { :git => "https://github.com/sticksen/GooglePlusShareActivity.git"}
  s.source_files = "GooglePlusShareActivity/*.{h,m}"
  s.resources = "GooglePlusShareActivity/*.png"
  s.requires_arc = true
  s.platform = :ios, "6.0"
  s.frameworks = 'Foundation', 'UIKit'
  s.xcconfig = {"FRAMEWORK_SEARCH_PATHS" => "\"$(PODS_ROOT)/google-plus-ios-sdk/google-plus-ios-sdk-1.7.0\"" }
  s.dependency 'google-plus-ios-sdk', '1.7.0'
end