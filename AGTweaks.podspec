Pod::Spec.new do |spec|
  spec.name         = 'AGTweaks'
  spec.version      = '1.0.1'
  spec.license      =  { :type => 'BSD' }
  spec.homepage     = 'https://github.com/facebook/Tweaks'
  spec.authors      = { 'Grant Paul' => 'tweaks@grantpaul.com', 'Kimon Tsinteris' => 'kimon@mac.com', 'Håvard Fossli' => 'hfossli@gmail.com' }
  spec.summary      = 'Easily adjust parameters for iOS apps in development.'
  spec.source       = { 
  	:git => 'https://github.com/hfossli/AGTweaks.git', 
  	:tag => spec.version.to_s 
  }
  spec.source_files = 'Source/**/*.{h,m}'
  spec.requires_arc = true
  spec.framework = 'MessageUI', 'UIKit', 'Foundation'
  spec.ios.deployment_target = '6.0'
end
