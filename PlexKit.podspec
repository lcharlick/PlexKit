#
#  Be sure to run `pod spec lint PlexKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = "PlexKit"
  spec.version      = "1.2.0"
  spec.summary      = "An async, type-safe Plex interface in Swift."
  spec.homepage     = "https://github.com/lcharlick/PlexKit"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "Lachlan Charlick" => "lachlan.charlick@gmail.com" }
  spec.social_media_url   = "https://twitter.com/lcharlick"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  # spec.platform     = :ios
  # spec.platform     = :ios, "5.0"

  #  When using multiple platforms
  spec.ios.deployment_target = "10.0"
  spec.osx.deployment_target = "10.12"
  # spec.watchos.deployment_target = "2.0"
  # spec.tvos.deployment_target = "9.0"
  spec.swift_versions = "5.2"


  spec.source       = { :git => "https://github.com/lcharlick/PlexKit.git", :tag => "#{spec.version}" }
  spec.source_files  = "PlexKit", "PlexKit/**/*.swift"
  spec.exclude_files = "Classes/Exclude"

  # spec.public_header_files = "Classes/**/*.h"
end
