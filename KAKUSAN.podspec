#
# Be sure to run `pod lib lint KAKUSAN.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KAKUSAN'
  s.version          = '0.5.0'
  s.summary          = 'Automatically detect when a user takes a screenshot, and share that screenshot.'
  s.description      = <<-DESC
Automatically detect when a user takes a screenshot, and share that screenshot.
(with "UIActivityViewController")
                       DESC

  s.homepage         = 'https://blog.anzfactory.xyz/'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'anzfactory' => 'anz.factory@gmail.com' }
  s.source           = { :git => 'https://github.com/anzfactory/KAKUSAN.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/AnzNetJp'

  s.ios.deployment_target = '10.0'

  s.source_files = 'KAKUSAN/Classes/**/*'
end
