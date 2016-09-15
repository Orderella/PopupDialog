Pod::Spec.new do |s|
  s.name             = 'PopupDialog'
  s.version          = '0.5.1'
  s.summary          = 'A simple custom popup dialog view controller'
  s.homepage         = 'https://github.com/orderella/PopupDialog'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Martin Wildfeuer' => 'mwfire@mwfire.de', 'Andrew Reed' => 'andrew_reed@hotmail.com' }
  s.source           = { :git => 'https://github.com/Reedyuk/PopupDialog.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/orderella'

  s.ios.deployment_target = '9.0'
  s.source_files = 'PopupDialog/Classes/**/*'
end
