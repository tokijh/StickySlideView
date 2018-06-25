Pod::Spec.new do |s|
  s.name             = 'StickySlideView'
  s.version          = '1.0'
  s.swift_version    = '4.1'
  s.summary          = 'SlideView synchronized with ScrollView'
  s.description      = 'SlideView synchronized with ScrollView'
  s.homepage         = 'https://github.com/tokijh/StickySlideView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'tokijh' => 'tokijh@naver.com' }
  s.source           = { :git => 'https://github.com/tokijh/StickySlideView.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.source_files = 'StickySlideView/*swift'
end