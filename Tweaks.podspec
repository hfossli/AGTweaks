Pod::Spec.new do |spec|
  spec.name         = 'Tweaks'
  spec.version      = '1.2'
  spec.license      =  { :type => 'BSD' }
  spec.homepage     = 'https://github.com/facebook/Tweaks'
  spec.authors      = { 'Grant Paul' => 'tweaks@grantpaul.com', 'Kimon Tsinteris' => 'kimon@mac.com' }
  spec.summary      = 'Easily adjust parameters for iOS apps in development.'
  spec.source       = { 
  	:git => 'https://github.com/facebook/Tweaks.git', 
  	:tag => spec.version.to_s 
  }
  spec.source_files = 'Source/**/*.{h,m}'
  spec.requires_arc = true
  spec.social_media_url = 'https://twitter.com/fbOpenSource'
  spec.framework = 'MessageUI', 'UIKit', 'Foundation'
  spec.ios.deployment_target = '6.0'
end
