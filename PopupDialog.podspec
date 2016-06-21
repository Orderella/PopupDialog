#
# Be sure to run `pod lib lint PopupDialog.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PopupDialog'
  s.version          = '0.1.0'
  s.summary          = 'A simple custom popup dialog view controller'
  s.description      = <<-DESC
TODO: A simple custom popup popup dialog view controller. Easy to customize with appearance.
                       DESC

  s.homepage         = 'https://github.com/orderella/PopupDialog'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Martin Wildfeuer' => 'mwfire@mwfire.de' }
  s.source           = { :git => 'https://github.com/orderella/PopupDialog.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/orderella'

  s.ios.deployment_target = '9.0'
  s.source_files = 'PopupDialog/Classes/**/*'
end
