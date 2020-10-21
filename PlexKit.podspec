Pod::Spec.new do |spec|
    spec.name         = "PlexKit"
    spec.version      = "1.2.1"
    spec.summary      = "An async, type-safe Plex interface in Swift."
    spec.homepage     = "https://github.com/lcharlick/PlexKit"
    spec.license      = { :type => "MIT", :file => "LICENSE" }
    spec.author             = { "Lachlan Charlick" => "lachlan.charlick@gmail.com" }
    spec.social_media_url   = "https://twitter.com/lcharlick"
  
    spec.ios.deployment_target = "10.0"
    spec.osx.deployment_target = "10.12"
    # spec.watchos.deployment_target = "2.0"
    spec.tvos.deployment_target = "10.0"
    spec.swift_versions = "5.2"
  
    spec.source        = { :git => "https://github.com/lcharlick/PlexKit.git", :tag => "#{spec.version}" }
    spec.source_files  = "Sources/PlexKit/**/*.swift"
  end