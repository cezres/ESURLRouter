#
#  Be sure to run `pod spec lint ESURLRouter.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "ESURLRouter"
  s.version      = "0.0.1"
  s.summary      = "ESURLRouter."


  #s.description  = <<-DESC DESC

  s.homepage     = "https://github.com/cezres/ESURLRouter"

  # s.license      = { :type => "MIT", :file => "LICENSE" }


  s.author             = { "云之彼端" => "cezres@163.com" }
  # Or just: s.author    = "云之彼端"
  # s.authors            = { "云之彼端" => "cezres@163.com" }
  # s.social_media_url   = "http://twitter.com/云之彼端"


  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/cezres/ESURLRouter.git", :tag => "#{s.version}" }


  s.source_files  = "ESURLRouter/**/*.{h,m}"
  s.public_header_files = "ESURLRouter/**/*.h"


  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"


  s.requires_arc = true

end
