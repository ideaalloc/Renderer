#
# Be sure to run `pod lib lint Renderer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.swift_version    = '4.1.2'
  s.name             = 'Renderer'
  s.version          = '1.0.7'
  s.summary          = 'ATP Renderer'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
ATP Renderer is for Atlas Protocol Targeting Interactive Element Rendering
                       DESC

  s.homepage         = 'https://github.com/ideaalloc/Renderer.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'LGPL', :file => 'LICENSE' }
  s.author           = { 'Bill Lv' => 'bill.lv@atlasp.io' }
  s.source           = { :git => 'https://github.com/ideaalloc/Renderer.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'Renderer/**/*'
  s.exclude_files = 'Renderer/Renderer/Info.plist'
  s.exclude_files = 'Renderer/RendererTests/Info.plist'

  # s.public_header_files = 'Pods/**/*.h'
  s.frameworks = 'UIKit'
  s.dependency 'DLRadioButton', '~> 1.4'
  s.dependency 'Validator'
end

